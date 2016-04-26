//
//  ViewController.m
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import "ViewController.h"

#import "TSZCircleProgressPercentView.h"


@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self setUI];
}


- (void)setUI{
    
    TSZCircleProgressPercentView *proView = [[TSZCircleProgressPercentView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    proView.center = self.view.center;
    
    
//    for (int i = 0; i <= 23233; i++) {
    
//        NSLog(@"%zd " , i);
        
        // 卡一秒执行
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        

            
            [proView drawCircleWithPercent:80
                                  duration:2
                                 lineWidth:15
                                 clockwise:YES
                                   lineCap:kCALineCapRound
                                 fillColor:[UIColor clearColor]
                               strokeColor:[UIColor orangeColor]
                            animatedColors:nil];
//        });
//    }
    
    
    proView.percentLabel.font = [UIFont systemFontOfSize:35];
    
    [proView startAnimation];
    
    [self.view addSubview:proView];
    
}


@end
