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


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return  self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit{
    
    self.backgroundLayer = [CAShapeLayer layer];
    
    [self.layer addSublayer:self.backgroundLayer];
    
    self.circle  =[CAShapeLayer layer];
    
    [self.layer addSublayer:self.circle];
    
    self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2 , self.frame.size.height / 2)];
    
    [self addSubview:self.percentLabel];
    
    self.colors = [NSMutableArray array];
}

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
    
    [self setupPercentLabel];
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

// 设置显示的信息

- (void)setupPercentLabel{
    
    
    // 居中显示
    
    NSLayoutConstraint *centerHor = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
     NSLayoutConstraint *centerVer = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.percentLabel.translatesAutoresizingMaskIntoConstraints  =  NO;
    
    [self addConstraints:@[centerHor , centerVer]];
    
    [self layoutIfNeeded];
    
    self.percentLabel.text = [NSString stringWithFormat:@"%2d%%" ,(int)self.percent];
    
}

- (void)startAnimation{
    
    [self drawBackgroundCircle];
    
    [self drawCircle];
    
    // 字数的变化
    
    TSZPercentLabel *tweenLabel = [[TSZPercentLabel alloc] initWithObject:self.percentLabel key:@"text" from:0 to:self.percent duration:self.duration];
    tweenLabel.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [tweenLabel start];
    
}

// 画背景圆

- (void)drawBackgroundCircle{
    
    [self.backgroundLayer removeAllAnimations];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration = self.duration;
    
    drawAnimation.repeatCount = 1.0;  // 一次
    
    // 实现
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // 添加
    [self.backgroundLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
}

// 画圆

- (void)drawCircle {
    
    [self.circle removeAllAnimations];
    
    // 使用 CABasicAnimation 做动画
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration = self.duration;
    
    drawAnimation.repeatCount = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    
    CAKeyframeAnimation  *colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    colorsAnimation.values = self.colors;
    
    // 进度
    colorsAnimation.calculationMode = kCAAnimationPaced;
    
    colorsAnimation.removedOnCompletion = NO;
    
    colorsAnimation.fillMode = kCAFillModeForwards;
    
    colorsAnimation.duration = self.duration;
    
    [self.circle  addAnimation:colorsAnimation forKey:@"strokeColor"];
    
}


@end
