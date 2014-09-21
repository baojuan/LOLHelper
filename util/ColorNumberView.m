//
//  ColorNumberView.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ColorNumberView.h"

@implementation ColorNumberView

- (void)awakeFromNib
{
    self.color = [UIColor whiteColor];
    self.number = 0.0;
}
- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setNumber:(CGFloat)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色

    [_color setStroke];
    
    
    CGContextSetFillColorWithColor(context, _color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width * self.number, rect.size.height));

    
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, rect.size.width, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 0, rect.size.height);
    
    CGContextAddLineToPoint(context, 0, 0);

    //连接上面定义的坐标点
    CGContextStrokePath(context);
    

    
    
//    //开始一个起始路径
//    CGContextBeginPath(context);
//    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
//    CGContextMoveToPoint(context, 0, 0);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, rect.size.width * self.number, 0);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, rect.size.width * self.number, rect.size.height);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, 0, rect.size.height);
//    
//    CGContextAddLineToPoint(context, 0, 0);
//    
//    //连接上面定义的坐标点
//    CGContextStrokePath(context);
    
}


@end
