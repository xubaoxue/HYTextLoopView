//
//  ViewController.m
//  HYTextLoopView
//
//  Created by 徐保学 on 2019/12/3.
//  Copyright © 2019 徐保学. All rights reserved.
//

#import "ViewController.h"
#import "HYTextLoopView.h"

#define rgba(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    HYTextLoopView *loopView = [HYTextLoopView textLoopViewWith:@[] loopInterval:1000.0 initWithFrame:CGRectMake(5, 4, kScreenWidth - 200, 32) selectBlock:^(NSString *selectString, NSInteger index) {

        #warning 点击回调,注意循环引用问题weakSelf
    }];
    
    [self.view addSubview:loopView];
    }


@end
