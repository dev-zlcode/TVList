//
//  FMDBManager.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDB.h"

//数据库类用于辅助model操作数据库 该类使用FMDB第三方库进行异步操作
@interface FMDBManager : NSObject
{
    NSString *databasePath;
}

//单例初始化方法
+(id)defaultFMDBManager;

//根据条件更新数据记录
-(BOOL) updateDataByQueue:(NSString*)tableName params:(NSDictionary*)params conditions:(NSString*)conditions;
//根据条件批量更新或者新增数据记录用于优惠券列表差分更新
-(BOOL) updateOrInsertBatchByQueue:(NSString*)tableName byAllParams:(NSArray*)allParams andCheckColumn:(NSString*)columnName;
//根据条件查询一条数据
- (NSDictionary*) findDataByQueue:(NSString*)tableName  select:(NSString*)select conditions:(NSString*)conditions;
//插入一条数据记录
-(BOOL) insertOneByQueue:(NSString*)tableName params:(NSDictionary*)params;
//批量插入数据记录
-(BOOL) insertBatchByQueue:(NSString*)tableName byAllParams:(NSArray*)allParams;
//清空对应的数据表数据
- (void) truncateTable:(NSString *)tableName;
//发现符合条件的所有数据记录
- (NSArray*) findAllDataByQueue:(NSString*)tableName  select:(NSString*)select conditions:(NSString*)conditions;

@end
