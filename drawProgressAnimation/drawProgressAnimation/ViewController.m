//
//  ViewController.m
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import "ViewController.h"

#import "TSZCircleProgressPercentView.h"
#import "otherProgressView.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

//    [self   setUI];
}

- (void)setUIPro{
    
    otherProgressView *proView = [[otherProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    proView.center = self.view.center;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i <= 23233; i++) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 回到主线程显示图片
                
                proView.percent = i / 23233.0;
                
            });
        }
    });

    
    [self.view addSubview:proView];
    
}


- (void)setUI{
    
    TSZCircleProgressPercentView *proView = [[TSZCircleProgressPercentView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
   
    proView.center = self.view.center;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        double totalNumbers = 23233;
        
        for (int i = 0; i <= totalNumbers ; i++) {
            
//           NSLog(@"%zd " , i);
            
            double  num = (i / totalNumbers) * 100;
            
//             NSLog(@"%f " , num);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 回到主线程显示图片
                
//                proView.percent = i / 23233.0;
                
                [proView drawCircleWithPercent: num
                                      duration:1
                                     lineWidth:10
                                     clockwise:YES
                                       lineCap:kCALineCapRound
                                     fillColor:[UIColor whiteColor]
                                   strokeColor:[UIColor orangeColor]
                                animatedColors:nil];
                
                
            });
        }
        
    });
    
    
    proView.percentLabel.font = [UIFont systemFontOfSize:28];
    
    [proView startAnimation];
    
    [self.view addSubview:proView];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self setUI];
}

@end
