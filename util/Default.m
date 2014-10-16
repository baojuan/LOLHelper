//
//  Default.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "Default.h"

@implementation Default

+ (NSString *)server
{
    return @"http://lol.d1gl.com/hero/api/";
}


+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}


+ (UIColor *)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b
{
    return [Default colorWithR:r withG:g withB:b withA:1];
}

+ (UIColor *)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b withA:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+(int)systemMajorVersion
{
    static int systemMajorVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* version = [[UIDevice currentDevice] systemVersion];
        systemMajorVersion = [[version componentsSeparatedByString:@"."][0] intValue];
    });
    return systemMajorVersion;
}
+(BOOL)isiOS8
{
    return [Default systemMajorVersion] >= 8;
}
+(BOOL)isiOS7
{
    return [Default systemMajorVersion] >= 7;
}
+ (BOOL)isiOS6
{
    return [Default systemMajorVersion] == 6;
}
+ (BOOL)isiOS5
{
    return [Default systemMajorVersion] == 5;
}

@end
