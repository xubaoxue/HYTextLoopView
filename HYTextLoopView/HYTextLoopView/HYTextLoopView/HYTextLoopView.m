//
//  HYTextLoopView.m
//  HYTextLoopView
//
//  Created by 徐保学 on 2019/12/3.
//  Copyright © 2019 徐保学. All rights reserved.
//

#import "HYTextLoopView.h"

@interface HYTextLoopCell ()

@property (nonatomic, strong) UILabel       *contentLbl;

@end

@implementation HYTextLoopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.contentLbl];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark ============ lazy
- (UILabel *)contentLbl
{
    if (_contentLbl == nil) {
        _contentLbl = [[UILabel alloc] initWithFrame:self.frame];
        _contentLbl.font = [UIFont systemFontOfSize:14];
        _contentLbl.textColor = [UIColor grayColor];
        _contentLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLbl;
}

@end

@interface HYTextLoopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger         currentRowIndex;
@property (nonatomic, assign) NSTimeInterval    interval;
@property (nonatomic, strong) NSTimer           *myTimer;
@property (nonatomic,   copy) selectTextBlock   selectBlock;
@property (nonatomic,   weak) UITableView       *tableView;

@end

@implementation HYTextLoopView

#pragma mark - 初始化方法
+ (instancetype)textLoopViewWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock
{
    HYTextLoopView *loopView = [[HYTextLoopView alloc] initWithFrame:frame];
    loopView.dataSource = dataSource;
    loopView.selectBlock = selectBlock;
    loopView.interval = timeInterval ? timeInterval : 1.0;
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 32;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        _tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark ============ tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HYTextLoopCell";
    HYTextLoopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[HYTextLoopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.contentLbl setText:self.dataSource[indexPath.row]];

    return cell;
}


#pragma mark ============ tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) {
        self.selectBlock(_dataSource[indexPath.row], indexPath.row);
    }
}


#pragma mark ============ scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 以无动画的形式跳到第1组的第0行
    if (_currentRowIndex == _dataSource.count) {
        _currentRowIndex = 0;
        [_tableView setContentOffset:CGPointZero];
    }
}

#pragma mark ============ 定时器
- (void)setInterval:(NSTimeInterval)interval
{
    _interval = interval;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    _myTimer = timer;
}

- (void)timer
{
    self.currentRowIndex++;
    NSLog(@"%ld", (long)_currentRowIndex);
    [self.tableView setContentOffset:CGPointMake(0, _currentRowIndex * _tableView.rowHeight) animated:YES];
}

@end
