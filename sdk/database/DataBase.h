//
//  DataBase.h
//  MoFangAPP_PVZ
//
//  Created by 韩傻傻 on 13-8-21.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject{
    FMDatabase *_fmDataBase;
}

//获取当前类的唯一对象
+ (DataBase *)sharedDataBase;

//根据文件名获取沙盒目录下的全路径
+ (NSString *)filePath:(NSString *)fileName;

////插入收藏
//- (void)insertCollectItem:(ModelItem *)item;
//
////写入各个专题的数据
//- (void)insertTopicTypeData:(NSArray *)array;
//
//
////读取专题数据
//- (NSArray *)readTopicTypeDate:(NSString *)typeidStrategy;
//
////读取收藏数据
//- (NSArray *)readCollectTypeDate;
//
////查询专题是否有数据
//- (BOOL)queryTopicHaveDateWiteType:(NSString *)typeidStrategy;
//
////查询是否收藏
//- (BOOL)queryCollectHaveDateWiteType:(NSString *)typeidStrategy;
//
////删除收藏数据
//- (void)deleteCollectData:(NSString *)idLevelStrategy;
//

//插入英雄列表
- (void)insertHeroList:(NSArray *)array;

//插入道具列表
- (void)insertItemList:(NSArray *)array;

//插入符文列表
- (void)insertRuneList:(NSArray *)array;


- (NSArray *)getHeroListForNewsLocation:(NSString *)location;

- (NSArray *)getHeroListForTicketLocation:(NSString *)location;

- (NSArray *)getHeroListForCoinLocation:(NSString *)location;

- (NSArray *)getHeroListForEnNameLocation:(NSString *)location;


@end
