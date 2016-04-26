//
//  TSZCircleProgressPercentView.h
//  drawProgressAnimation
//
//  Created by tang on 16/4/26.
//  Copyright © 2016年 shunzhitang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSZCircleProgressPercentView : UIView

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

- (void)drawCircleWithPercent:(CGFloat)percent  duration:(CGFloat)duration lineWidth:(CGFloat)lineWidth clockwise:(BOOL)clockwise  lineCap:(NSString *)lineCap fillColor:(UIColor *)fillColor  strokeColor:(UIColor *)strokeColor  animatedColors:(NSArray *)colors;




@end
