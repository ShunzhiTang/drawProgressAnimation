//
//  TSZPercentLabel.h
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TSZPercentLayer;

@protocol TSZPercentDelegate;


@interface TSZPercentLabel : NSObject

@property (nonatomic ,strong) CAMediaTimingFunction *timingFunction;

- (instancetype)initWithObject:(UIView *)objectView key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration;

- (void)start;

@end

#pragma mark: 在创建一个类 在这个类中 ， 也就是 内部类

@interface TSZPercentLayer : CALayer

@property (nonatomic ,strong) id<TSZPercentDelegate> percentDelegate;

@property (nonatomic ,assign) CGFloat  fromValue;

@property (nonatomic ,assign) CGFloat  toValue;

@property (nonatomic , assign) NSTimeInterval tweenDuration;

- (instancetype)initWithFromValue:(CGFloat)fromValue  toValue:(CGFloat)toValue  duration:(CGFloat)duration;

- (void)startAnimation;

@end

#pragma mark: 实现协议的方法

@protocol TSZPercentDelegate <NSObject>

- (void)layer:(TSZPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue;

- (void)layerDidStopAnimation;

@end


