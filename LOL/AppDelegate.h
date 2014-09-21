//
//  AppDelegate.h
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (weak, nonatomic) SecondViewController *secondViewController;

@property (strong, nonatomic) UIWindow *window;

- (NSDictionary *)getDataItem:(NSString *)dataName ID:(NSString *)itemID;

@end

