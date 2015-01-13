//
//  AppDelegate.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AppDelegate.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Default.h"
#import "MobClick.h"

#define UMENG_APPKEY @"54b4b655fd98c5744900099d"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSMutableDictionary *heroIDList;
    NSMutableArray *heroList;
    NSMutableDictionary *itemIDList;
    NSMutableArray *itemList;
    NSMutableDictionary *runeIDList;
    NSMutableArray *runeList;
    
    
    NSMutableArray *dataArray;
    
    MBProgressHUD *_hud;
}

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self umengTrack];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //GetData
        [self getHeroList];
        [self getItemList];
        [self getRuneList];
    });
    
    UITabBarController *controller = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = controller.tabBar;
    tabBar.tintColor = [UIColor whiteColor];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem0 = [tabBar.items objectAtIndex:0];

    UIImage * selectedImage1 = [UIImage imageNamed:@"hero_1"];
    UIImage * image1 = [[UIImage imageNamed:@"hero_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    tabBarItem1.title = @"英雄";
    [tabBarItem1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:image1];

    
    UIImage * selectedImage = [UIImage imageNamed:@"news_1"];
    UIImage * image = [[UIImage imageNamed:@"news_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    
    [tabBarItem0 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:image];
    
//    tabBarItem0.title = @"新闻";
    
    [self.window makeKeyAndVisible];
    _hud = [Default showHubMessageManualHidden:@"加载中，请稍后..."];

    return YES;
    
}

- (void)setSecondViewController:(SecondViewController *)secondViewController
{
    _secondViewController = secondViewController;
    _secondViewController.dataArray = dataArray;
}


- (void)getHeroList
{
    heroList = [[NSMutableArray alloc]init];
    heroIDList = [[NSMutableDictionary alloc]init];
    
    //getHeroList
    [heroIDList addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"HeroIDList"]];
    [heroList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"HeroList"]];
    NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForNewsLocation:@"全部"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString * heroId in resultArray) {
        NSString *location = [heroIDList objectForKey:heroId];
        if ([heroList count] > 0) {
            [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
        }
    }
    dataArray = tempArray;
    if (self.secondViewController) {
        self.secondViewController.dataArray = dataArray;
    }
    //getFromNetwork
    NSString *url = [NSString stringWithFormat:@"%@?method=getHeroList",[Default server]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getHeroList success");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [heroIDList removeAllObjects];
            [heroList removeAllObjects];
            [heroList addObjectsFromArray:[dict objectForKey:@"data"]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImageView *imageView = [[UIImageView alloc] init];
                for (int i=0; i<[heroList count]; i++) {
                    [imageView setImageWithURL:[[heroList objectAtIndex:i] objectForKey:@"icon"]];
                }
            });
            for (int i=0; i<[heroList count]; i++) {
                NSString *heroid = [[heroList objectAtIndex:i] objectForKey:@"id"];
                [heroIDList setObject:[NSString stringWithFormat:@"%d",i] forKey:heroid];
            }
            [[NSUserDefaults standardUserDefaults] setObject:heroIDList forKey:@"HeroIDList"];
            [[NSUserDefaults standardUserDefaults] setObject:heroList forKey:@"HeroList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[DataBase sharedDataBase] insertHeroList:heroList];
            NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForNewsLocation:@"全部"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSString * heroId in resultArray) {
                NSString *location = [heroIDList objectForKey:heroId];
                [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
            }
            dataArray = tempArray;
            if (self.secondViewController) {
                self.secondViewController.dataArray = dataArray;
            }
            NSLog(@"你可以触摸屏幕了");
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hide:YES];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        _hud.hidden = YES;
    }];
    [operation start];
}

- (void)getItemList
{
    itemList = [[NSMutableArray alloc]init];
    itemIDList = [[NSMutableDictionary alloc]init];
    
    //getItemList
    [itemIDList addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"ItemIDList"]];
    [itemList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ItemList"]];
    
    //getFromNetwork
    NSString *url = [NSString stringWithFormat:@"%@?method=getItem",[Default server]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getItem success");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [itemList addObjectsFromArray:[dict objectForKey:@"data"]];
            for (int i=0; i<[itemList count]; i++) {
                NSString *id = [[itemList objectAtIndex:i] objectForKey:@"id"];
                [itemIDList setObject:[NSString stringWithFormat:@"%d",i] forKey:id];
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:itemIDList forKey:@"ItemIDList"];
            [[NSUserDefaults standardUserDefaults] setObject:itemList forKey:@"ItemList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [operation start];
}

- (void)getRuneList
{
    runeList = [[NSMutableArray alloc]init];
    runeIDList = [[NSMutableDictionary alloc]init];
    
    //getItemList
    [itemIDList addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"RuneIDList"]];
    [itemList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RuneList"]];
    
    //getFromNetwork
    NSString *url = [NSString stringWithFormat:@"%@?method=getRune",[Default server]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getRune success");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [runeList addObjectsFromArray:[dict objectForKey:@"data"]];
            for (int i=0; i<[runeList count]; i++) {
                NSString *id = [[runeList objectAtIndex:i] objectForKey:@"id"];
                [runeIDList setObject:[NSString stringWithFormat:@"%d",i] forKey:id];
            }
            [[NSUserDefaults standardUserDefaults] setObject:runeIDList forKey:@"RuneIDList"];
            [[NSUserDefaults standardUserDefaults] setObject:runeList forKey:@"RuneList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [operation start];
}

- (NSDictionary *)getDataItem:(NSString *)dataName ID:(NSString *)itemID{
    NSDictionary *data = NULL;
    if ([dataName isEqualToString:@"Hero"]){
        NSInteger index = [[heroIDList objectForKey:itemID] integerValue];
        data = [heroList objectAtIndex:index];
    }
    else if ([dataName isEqualToString:@"Item"]){
        NSInteger index = [[itemIDList objectForKey:itemID] integerValue];
        data = [itemList objectAtIndex:index];
    }
    else if ([dataName isEqualToString:@"Rune"]){
        NSInteger index = [[runeIDList objectForKey:itemID] integerValue];
        data = [runeList objectAtIndex:index];
    }
    return data;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
