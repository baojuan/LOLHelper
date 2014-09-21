//
//  DataBase.m
//  MoFangAPP_PVZ
//
//  Created by 韩傻傻 on 13-8-21.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "DataBase.h"
#import "pinyin.h"


#define FILE_PATH(filename) ([[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:filename])


#define DB_FILENAME @"X.db"


static DataBase *singleton_DB=nil;
@implementation DataBase

- (id)init{
    if(self=[super init]){
        _fmDataBase=[FMDatabase databaseWithPath:FILE_PATH(DB_FILENAME)];
        if([_fmDataBase open]){
            [self createTable];
        }
    }
    return self;
}
+ (DataBase *)sharedDataBase{
    if(!singleton_DB){
        singleton_DB=[[DataBase alloc]init];
    }
    return singleton_DB;
}


- (void)createTable{
    NSArray *tableSql=[NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS hero (serial integer PRIMARY KEY AUTOINCREMENT DEFAULT NULL,heroid TEXT(1024) DEFAULT NULL,ticket TEXT(1024) DEFAULT NULL,coin TEXT(1024) DEFAULT NULL,location TEXT(1024) DEFAULT NULL,name TEXT(1024) DEFAULT NULL)",nil];
    for(NSString *str in tableSql){
        if(![_fmDataBase executeUpdate:str]){
            NSLog(@"create table error:%@",[_fmDataBase lastErrorMessage]);
        }
        NSLog(@"create table success");
    }
}

- (void)insertHeroList:(NSArray *)array
{
    for (NSDictionary *dict in array) {
        [self insertIntoHeroTableForOneModel:dict];
    }
    [_fmDataBase commit];
}

- (void)insertIntoHeroTableForOneModel:(NSDictionary *)dict
{
    if ([self judgeHeroModelIsInDataBase:[dict objectForKey:@"id"]]) {
        return;
    }
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO hero (heroid,ticket,coin,location,name) VALUES (?,?,?,?,?)"];
    if (![_fmDataBase executeUpdate:sql,[dict objectForKey:@"id"],[dict objectForKey:@"ticket"],[dict objectForKey:@"coin"],[dict objectForKey:@"location"],[self getFirstLetter:[dict objectForKey:@"title"]]]) {
        NSLog(@"insert into topic error : %@",[_fmDataBase lastErrorMessage]);
    }
}

- (BOOL)judgeHeroModelIsInDataBase:(NSString *)heroid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM hero WHERE heroid = ?"];
    FMResultSet *rs=[_fmDataBase executeQuery:sql,heroid];
    while ([rs next]) {
        return YES;
    }
    return NO;
    
}

- (NSArray *)getHeroListForNewsLocation:(NSString *)location
{
    NSString *sql;
    if ([location isEqualToString:@"全部"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM hero ORDER BY heroid DESC"];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;

    }
    else {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero WHERE location LIKE '%%%@%%' ORDER BY heroid DESC",location];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;

    }
    

}


- (NSArray *)getHeroListForCoinLocation:(NSString *)location
{
    NSString *sql;
    if ([location isEqualToString:@"全部"]) {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero ORDER BY coin ASC"];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }
    else {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero WHERE location LIKE '%%%@%%' ORDER BY coin ASC",location];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }

    
}



- (NSArray *)getHeroListForTicketLocation:(NSString *)location
{
    NSString *sql;
    if ([location isEqualToString:@"全部"]) {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero ORDER BY ticket ASC"];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }
    else {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero WHERE location LIKE '%%%@%%' ORDER BY heroid ASC",location];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }
    
}



- (NSArray *)getHeroListForEnNameLocation:(NSString *)location
{
    NSString *sql;
    if ([location isEqualToString:@"全部"]) {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero ORDER BY name ASC"];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }
    else {
        sql = [NSString stringWithFormat:@"SELECT heroid FROM hero WHERE location LIKE '%%%@%%' ORDER BY name ASC",location];
        FMResultSet *rs=[_fmDataBase executeQuery:sql];
        NSMutableArray *result=[NSMutableArray array];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"heroid"];
            [result addObject:string];
        }
        return result;
        
    }
}

- (NSString *)getFirstLetter:(NSString *)string
{
    char a = pinyinFirstLetter([string characterAtIndex:0]);
    return [NSString stringWithFormat:@"%c",a];
}


//- (void)insertCollectItem:(ModelItem *)item
//{
//    NSString *sql=[NSString stringWithFormat:@"INSERT INTO collectItem (idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
//    if (![_fmDataBase executeUpdate:sql,item.idLevelStrategy,item.specialid,item.title,item.style,item.typeidLevelStrategy,item.thumb,item.keywords,item.descriptionLevelStrategy,item.url,item.curl,item.listorder,item.useid,item.username,item.inputtime,item.updatetime,item.searchid,item.isdata,item.islink,item.videoid,item.short_title])
//    {
//        NSLog(@"insert into topic error : %@",[_fmDataBase lastErrorMessage]);
//    }
//}
//- (NSArray *)readCollectTypeDate
//{
//    NSString *sql=[NSString stringWithFormat:@"SELECT idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title FROM collectItem"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql];
//    NSMutableArray *result=[NSMutableArray array];
//    while ([rs next]) {
//        ModelItem *item=[[ModelItem alloc]init];
//        
//        [result addObject:item];
//    }
//    return result;
//}
//
//
//
//
//
//- (void)insertTopicTypeData:(NSArray *)array{
//    //准备批量插入
//    [_fmDataBase beginTransaction];
//    for (ModelItem *item in array) {
//        [self insertTopicItem:item];
//    }
//    [_fmDataBase commit];
//}
//
//- (void)insertTopicItem:(ModelItem *)item{
//    NSString *sql=[NSString stringWithFormat:@"INSERT INTO levelStrategy (idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
////    if (![_fmDataBase executeUpdate:sql,item.idLevelStrategy,item.specialid,item.title,item.style,item.typeidLevelStrategy,item.thumb,item.keywords,item.descriptionLevelStrategy,item.url,item.curl,item.listorder,item.useid,item.username,item.inputtime,item.updatetime,item.searchid,item.isdata,item.islink,item.videoid,item.short_title]) {
////        NSLog(@"insert into topic error : %@",[_fmDataBase lastErrorMessage]);
////    }
//}
//
//- (NSArray *)readTopicTypeDate:(NSString *)typeidStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title FROM levelStrategy WHERE typeidLevelStrategy = ?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeidStrategy];
//    NSMutableArray *result=[NSMutableArray array];
//    while ([rs next]) {
//        ModelItem *item=[[ModelItem alloc]init];
//        
//        [result addObject:item];
//    }
//    return result;
//}
//
//- (BOOL)queryCollectHaveDateWiteType:(NSString *)idStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) FROM collectItem WHERE idLevelStrategy=?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,idStrategy];
//    if([rs next]){
//        int count=[rs intForColumn:@"COUNT(*)"];
//        NSLog(@"query item count:%d",count);
//        if(count>0){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (BOOL)queryTopicHaveDateWiteType:(NSString *)typeidStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) FROM levelStrategy WHERE typeidLevelStrategy=?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeidStrategy];
//    if([rs next]){
//        int count=[rs intForColumn:@"COUNT(*)"];
//        NSLog(@"query item count:%d",count);
//        if(count>0){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (void)deleteCollectData:(NSString *)idLevelStrategy
//{
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM collectItem WHERE idLevelStrategy=?"];
//    [_fmDataBase executeUpdate:sql,idLevelStrategy];
//}

@end
