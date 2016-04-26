//
//  TSZPercentLabel.m
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import "TSZPercentLabel.h"

@interface TSZPercentLabel() <TSZPercentDelegate>

@property (nonatomic , strong) UIView *objectView;
@property (nonatomic  , strong)NSString *key;
@property (strong, nonatomic) TSZPercentLayer *layer;
@end


@implementation TSZPercentLabel

- (instancetype)initWithObject:(UIView *)objectView key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration{
    
    if (self = [super init]) {
        
        self.objectView = objectView;
        self.key = key;
        
        self.layer.fromValue = fromValue;
        self.layer.toValue = toValue;
        self.layer.tweenDuration = duration;
        self.layer.percentDelegate = self;
        [self.objectView.layer  addSublayer:self.layer];
        
    }
    
    return  self;
}

- (void)start{
    
    [self.layer startAnimation];
}

#pragma mark: 代理方法的实现
- (void)layer:(TSZPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue{
    
    int percent = (int)toValue;
    
    NSString *text = [NSString stringWithFormat:@"%2d%%" , percent];
    
    [self.objectView  setValue:text forKey:self.key];
    
}

- (void)layerDidStopAnimation{
    
    int percent  = (int)self.layer.toValue;
    NSString *text = [NSString stringWithFormat:@"%2d%%" , percent];
    
    [self.objectView  setValue:text forKey:self.key];
    [self.layer  removeFromSuperlayer];
}
@end

@interface TSZPercentLayer()

@property (nonatomic , assign) CGFloat animatableProperty;

@property (nonatomic , assign) CGFloat delay;

@property (strong , nonatomic) UIColor *color;

@property (strong , nonatomic) CAMediaTimingFunction * timingFunction;


@end

@implementation TSZPercentLayer

// 动态创建的意思
@dynamic animatableProperty;

@dynamic color;

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration{
    
    
    if (self = [super  init]) {
        self.fromValue = fromValue;
        self.toValue  = toValue;
        self.duration = duration;
        
    }
    return  self;
   
}

- (void)startAnimation{
    
    self.animatableProperty = self.toValue;
}

// layer加载时会通过+ (BOOL)needsDisplayForKey:(NSString *)key 方法来判断当前属性改变是否需要重新绘制。
+ (BOOL) needsDisplayForKey:(NSString *)key{
    
    if([key isEqualToString:@"animatableProperty "] || [key isEqualToString:@"color "] ){
        
        return  YES;
    }else{
        
        return  [super needsDisplayForKey:key];
    }
    
}

/**
 在该方法中利用可用的信息执行任何你想要在图层上的动作。你可能使用该方法给图层添加动画对象或者你可能使用该方法执行另外的任务。
 
 */

- (id<CAAction>)actionForKey:(NSString *)event {
    
    if([event isEqualToString:@"animatableProperty "] || [event isEqualToString:@"color "] ){
        
        return [super actionForKey:event];
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
    
    animation.timingFunction = self.timingFunction;
    animation.fromValue = [NSNumber numberWithFloat:self.fromValue];
    animation.toValue = [NSNumber numberWithFloat:self.toValue];
    animation.duration = self.tweenDuration;
    animation.beginTime = CACurrentMediaTime() + self.delay;
    animation.delegate = self;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.percentDelegate  layerDidStopAnimation];
}

/* 刷新图层的内容。调用-drawInContext：方法
 *然后更新图层的内容''属性。通常，这是
 *不直接调用。 
 */

- (void)display{
    
    
    if (self.presentationLayer != nil) {
        
        TSZPercentLayer *tLayer = (TSZPercentLayer *)self.presentationLayer;
        [self.percentDelegate layer:self didSetAnimationPropertyTo:tLayer.animatableProperty];
        
    }
    
}

@end