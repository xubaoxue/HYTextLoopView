//
//  HYTextLoopView.h
//  HYTextLoopView
//
//  Created by 徐保学 on 2019/12/3.
//  Copyright © 2019 徐保学. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectTextBlock)(NSString *selectString, NSInteger index);


@interface HYTextLoopCell : UITableViewCell

@end

@interface HYTextLoopView : UIView

@property (nonatomic, strong) NSArray *dataSource;

/**
 初始化方法

 @param dataSource 数据源
 @param timeInterval 时间间隔,默认是1.0秒
 @param frame 控件大小
 */
+ (instancetype)textLoopViewWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock;

@end
