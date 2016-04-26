//
//  TSZCircleProgressPercentView.m
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import "TSZCircleProgressPercentView.h"

#define kStartAngle -M_PI_2

@interface TSZCircleProgressPercentView()

@property (nonatomic , strong)CAShapeLayer  *backgroundLayer;

@property (nonatomic , strong) CAShapeLayer *circle;

@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) NSString *lineCap; // kCALineCapButt, kCALineCapRound, kCALineCapSquare

@property (nonatomic) BOOL clockwise;
@property (nonatomic, strong) NSMutableArray *colors;


@end

@implementation TSZCircleProgressPercentView

/**
 * 基于view 的frame去自动计算半径显示
 *
 * @param percent  所占的百分比
 * @param duration
 * @param  lineWidth外圈线的宽度
 * @param clockwise 是不是 顺时针
 * @param fillColor 填充颜色
 * @param strokeColor 线的颜色
 * @param animatedColors  颜色数组动画。如果这个参数是零，描边色将被用于绘制圆
 */

- (void)drawCircleWithPercent:(CGFloat)percent  duration:(CGFloat)duration lineWidth:(CGFloat)lineWidth clockwise:(BOOL)clockwise  lineCap:(NSString *)lineCap fillColor:(UIColor *)fillColor  strokeColor:(UIColor *)strokeColor  animatedColors:(NSArray *)colors{
    
    // 赋值
    
    self.duration = duration;
    self.percent = percent;
    self.lineWidth = lineWidth;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    
    if (colors  != nil) {
        
        for (UIColor *color in colors) {
            
            [self.colors  addObject:(id)color.CGColor];
            
        }
    }else{
        
        [self.colors  addObject:(id)strokeColor.CGColor];
    }
    
    CGFloat  min = MIN(self.frame.size.width, self.frame.size.height);
    
    self.radius = (min - lineWidth) / 2;
    
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius , self.frame.size.height / 2 - self.radius);
    
    self.lineCap = lineCap;
    // 设置背景颜色
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor ];
    
    
}

#pragma mark:  设置背景颜色

- (void)setupBackgroundLayerWithFillColor:(UIColor *)fillColor{

    self.backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle: 2 * M_PI clockwise:self.clockwise].CGPath;
    
    // 设置位置
    self.backgroundLayer.position = self.centerPoint;
    
    // 渲染
    self.backgroundLayer.fillColor = fillColor.CGColor;
    self.backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.backgroundLayer.lineWidth = self.lineWidth;
    self.backgroundLayer.lineCap = self.lineCap;
    self.backgroundLayer.rasterizationScale = 2 * [UIScreen  mainScreen].scale;
    self.backgroundLayer.shouldRasterize = YES;
}

- (void)setupCircleLayerWithStrokeColor:(UIColor *)strokeColor {
    
    CGFloat  endAngle = [self calculateToValueWithPercent:self.percent];
    
    self.circle.path = [ UIBezierPath  bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:endAngle clockwise:self.clockwise].CGPath;
    self.circle.position = self.centerPoint;
    
    self.circle.fillColor = [UIColor clearColor].CGColor;
    
    self.circle.strokeColor = strokeColor.CGColor;
    self.circle.lineWidth = self.lineWidth;
    self.circle.lineCap = self.lineCap;
    self.circle.shouldRasterize  =  YES;
    
    self.circle.rasterizationScale =  2 * [UIScreen mainScreen].scale;
    
}

- (CGFloat)calculateToValueWithPercent:(CGFloat)percent {
    return (kStartAngle + (percent * 2 * M_PI) / 100);
}

@end
