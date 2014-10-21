//
//  Default.h
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface Default : NSObject

+ (NSString *)server;



+ (CGSize)screenSize;


+ (UIColor *)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b;


+ (UIColor *)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b withA:(CGFloat)a;

+(int)systemMajorVersion;
+(BOOL)isiOS8;
+(BOOL)isiOS7;
+(BOOL)isiOS6;
+(BOOL)isiOS5;


+ (void)showHubMessage:(NSString *)message;

+ (void)showHubMessage:(NSString *)message hiddenAfterTime:(NSTimeInterval)time;


+ (MBProgressHUD *)showHubMessageManualHidden:(NSString *)message;

@end
