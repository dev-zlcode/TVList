//
//  FMDBManager.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "FMDBManager.h"

//数据库名
#define DATABASE_NAME_STRING @"AeonCoupons.db"
//系统信息SQL文
#define TABLE_SYSTEM_INSERT @"insert into t_system (guide_page_flag,app_version,app_min_version,app_update_info,app_update_url) values('1','10000','10000','你该更新应用版本了的','http://www.baidu.com')"

@implementation FMDBManager

//单例初始化方法
+(id)defaultFMDBManager
{
    static FMDBManager *logicCore=nil;
    if (!logicCore)
    {
        logicCore=[[[self class] alloc] init];
    }
    
    return logicCore;
}

//重写父类的init方法
- (FMDBManager*) init
{
    self = [super init];
    if(self)
    {
        [self createDB];
    }
    return self;
}

//创建数据库的方法
-(void)createDB
{
    //获取数据库存放的路径
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: DATABASE_NAME_STRING]];
    
    //创建NSFileManager实例
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //如果数据库不存在则创建
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
        
        [queue inDatabase:^(FMDatabase *db) {
            //系统表建表语句
            NSString *system_table_sql = @"create table if not exists t_system (\
            guide_page_flag bit(1) not null default 1,\
            app_version varchar(10),\
            app_min_version varchar(10),\
            app_update_info varchar(255),\
            app_update_url varchar(255))";
            [db executeUpdate:system_table_sql];
            //插入默认的系统信息
            NSString *table_system_insert = TABLE_SYSTEM_INSERT;
            [db executeUpdate:table_system_insert];
            
            //用户表建表语句
            NSString *user_table_sql = @"create table if not exists t_user (\
            user_id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            protocol_agree_flg tinyint default 0,\
            user_card_id char(13) not null default 0,\
            card_value_date varchar(8) not null,\
            mobile varchar(20) not null,\
            shop_id varchar(13) not null,\
            token varchar(256) not null,\
            over_plus_coupons varchar(50),\
            save_money varchar(50),\
            used_coupons varchar(20),\
            max_shop_update varchar(50),\
            max_coupon_update varchar(50),\
            max_news_update varchar(50),\
            notify_coupon_count smallint,\
            notify_news_count smallint,\
            notify_campaign_count smallint,\
            notify_coupon_count_max_update varchar(50),\
            notify_news_count_max_update varchar(50),\
            notify_campaign_count_max_update varchar(50))";
            [db executeUpdate:user_table_sql];
            
            //优惠券建表语句
            NSString *coupon_table_sql = @"create table if not exists t_coupon (\
            coupon_id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            use_update_date_time_str varchar(50),\
            use_conditon bit(1) default 0,\
            shop_name_str varchar(255),\
            coupon_name varchar(60) not null,\
            type tinyint default 1,\
            draw_status bit(1) default 0,\
            display_order beignet unsigned,\
            display_date_from datetime not null,\
            display_date_to datetime not null,\
            use_date_from diatomite not null,\
            use_date_to datetime not null,\
            original_price varchar(40),\
            discount_price varchar(40),\
            coupon_explain text,\
            image_path_list varchar(255),\
            image_path_detail varchar(255),\
            local_image_path varchar(255),\
            local_image_path_detail varchar(255),\
            use_date_str datetime not null,\
            coupon_type INTEGER,\
            coupon_type_name varchar(60))";
            [db executeUpdate:coupon_table_sql];
            
            //门店建表语句
            NSString *shop_table_sql = @"create table if not exists t_shop (\
            shop_id varchar(13) not null PRIMARY KEY,\
            shop_cd char(10) not null,\
            shop_name varchar(60) not null,\
            address varchar(100) not null,\
            latitude varchar(100) not null,\
            longitude varchar(100) not null,\
            distance_str varchar(60),\
            business_time varchar(20) not null,\
            tel varchar(50) not null,\
            update_date_str varchar(50) not null,\
            group_buying_tel varchar(50) not null)";
            [db executeUpdate:shop_table_sql];
            
            //新闻建表语句
            NSString *news_table_sql = @"create table if not exists t_news (\
            news_id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            title varchar(255),\
            body varchar(2048),\
            image_path varchar(255),\
            local_image_path varchar(255),\
            publish_flg bit(1) not null,\
            update_date_str varchar(8) not null,\
            url varchar(255))";
            [db executeUpdate:news_table_sql];
            
            //访问日志表建表语句
            NSString *accesslog_table_sql = @"create table if not exists t_accesslog (\
            id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            count int unsigned)";
            [db executeUpdate:accesslog_table_sql];
            
            //已使用优惠券表建表语句
            NSString *usedCoupon_table_sql = @"create table if not exists t_used_coupon (\
            coupon_id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            offlineUseTime varchar(50))";
            [db executeUpdate:usedCoupon_table_sql];
            
            //推送消息表建表语句
            NSString *pushmessage_table_sql = @"create table if not exists t_pushmessage (\
            id INTEGER not null PRIMARY KEY AUTOINCREMENT,\
            distance varchar(20),push_content text,enable_flag bit(1))";
            [db executeUpdate:pushmessage_table_sql];
            
        }];
        
    }
}

//插入一条新的记录
//参数：
//tableName是表名
//params对应的参数
-(BOOL) insertOneByQueue:(NSString*)tableName params:(NSDictionary*)params{
    BOOL isSuccess = YES;
    
    //用于存放插入的字段名
    NSMutableString * insertStr1 = [[NSMutableString alloc] init];
    //用于存放插入的字段对应的值
    NSMutableString * insertStr2 = [[NSMutableString alloc] init];
    
    int i = 1;
    
    //遍历参数拼接SQL文所需要的字符串
    for (NSString *key in params) {
        if (i == 1) {//第一个签名
            [insertStr2 appendString:[NSString stringWithFormat:@"`%@`",key]];
            [insertStr1 appendString:[NSString stringWithFormat:@"'%@'",[params objectForKey:key]]];
        }else{
            [insertStr2 appendString:[NSString stringWithFormat:@",`%@`",key]];
            [insertStr1 appendString:[NSString stringWithFormat:@",'%@'",[params objectForKey:key]]];
        }
        
        i++;
    }
    //新建FMDatabaseQueue实例用于异步操作
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    //执行建表SQL文
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"insert into %@ (%@) values(%@)",tableName,insertStr2,insertStr1]];
        
    }];
    
    return isSuccess;
}

//批量插入新的记录
//参数：
//tableName是表名
//allParams对应的参数 是一个包含多个参数字典的数组
-(BOOL) insertBatchByQueue:(NSString*)tableName byAllParams:(NSArray*)allParams{
    BOOL isSuccess = YES;
    
    //新建FMDatabaseQueue实例用于异步操作
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        //遍历数组
        for (NSDictionary *params in allParams) {
            //用于存放插入的字段名
            NSMutableString * insertStr1 = [[NSMutableString alloc] init];
            //用于存放插入的字段对应的值
            NSMutableString * insertStr2 = [[NSMutableString alloc] init];
            
            int i = 1;
            //遍历参数拼接SQL文所需要的字符串
            for (NSString *key in params) {
                if (i == 1) {
                    [insertStr2 appendString:[NSString stringWithFormat:@"`%@`",key]];
                    [insertStr1 appendString:[NSString stringWithFormat:@"'%@'",[params objectForKey:key]]];
                }else{
                    [insertStr2 appendString:[NSString stringWithFormat:@",`%@`",key]];
                    [insertStr1 appendString:[NSString stringWithFormat:@",'%@'",[params objectForKey:key]]];
                }
                
                i++;
            }
            //执行插入一条数据
            [db executeUpdate:[NSString stringWithFormat:@"insert into %@ (%@) values(%@)",tableName,insertStr2,insertStr1]];
        }
        
    }];
    
    return isSuccess;
}

//批量插入或更新数据 用于优惠券差分更新的
//参数：
//tableName表名
//allParams批量数据
//columnName用于检查是否已经存在的字段
-(BOOL) updateOrInsertBatchByQueue:(NSString*)tableName byAllParams:(NSArray*)allParams andCheckColumn:(NSString*)columnName{
    BOOL isSuccess = YES;
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySQL = nil;
        //遍历数组
        for (NSDictionary *params in allParams) {
            //先根据columnName字段及对应的值查找是否已经存在该数据
            querySQL = [NSString stringWithFormat: @"select %1$@ from %2$@ where %1$@ = %3$@",columnName,tableName,[params objectForKey:columnName]];
            FMResultSet *queryResult = [db executeQuery:querySQL];
            
            if ([queryResult next]) {
                //如果已经存在相应的数据则更新
                NSMutableString * updateStr = [[NSMutableString alloc] init];
                
                int i = 1;
                //遍历参数拼接更新字符串
                for (NSString *key in params) {
                    if (i == 1) {
                        [updateStr appendString:[NSString stringWithFormat:@"%@ = '%@'",key,[params objectForKey:key]]];
                    }else{
                        [updateStr appendString:[NSString stringWithFormat:@", %@ = '%@'",key,[params objectForKey:key]]];
                    }
                    
                    i++;
                }
                //执行更新SQL文
                NSString *executeSQL = [NSString stringWithFormat:@"update %@ set %@  where %@ = %@",tableName,updateStr,columnName,[params objectForKey:columnName]];
                [db executeUpdate:executeSQL];
            }else{
                //如果没有存在相应的数据则新建一条记录
                NSMutableString * insertStr1 = [[NSMutableString alloc] init];
                NSMutableString * insertStr2 = [[NSMutableString alloc] init];
                
                int i = 1;
                //遍历参数数组拼接生成所需要的SQL文
                for (NSString *key in params) {
                    if (i == 1) {
                        [insertStr2 appendString:[NSString stringWithFormat:@"`%@`",key]];
                        [insertStr1 appendString:[NSString stringWithFormat:@"'%@'",[params objectForKey:key]]];
                    }else{
                        [insertStr2 appendString:[NSString stringWithFormat:@",`%@`",key]];
                        [insertStr1 appendString:[NSString stringWithFormat:@",'%@'",[params objectForKey:key]]];
                    }
                    
                    i++;
                }
                //执行生成新记录的SQL文
                [db executeUpdate:[NSString stringWithFormat:@"insert into %@ (%@) values(%@)",tableName,insertStr2,insertStr1]];
            }
            
            [queryResult close];
        }
        
    }];
    
    return isSuccess;
}

//按条件更新数据的数据库操作
//参数：
//tableName表名
//params更新的数据键值字典
//conditions更新条件
-(BOOL) updateDataByQueue:(NSString*)tableName params:(NSDictionary*)params conditions:(NSString*)conditions{
    
    NSMutableString * updateStr = [[NSMutableString alloc] init];
    
    int i = 1;
    //遍历参数字典 拼接更新SQL文
    for (NSString *key in params) {
        if (i == 1) {
            [updateStr appendString:[NSString stringWithFormat:@"%@ = '%@'",key,[params objectForKey:key]]];
        }else{
            [updateStr appendString:[NSString stringWithFormat:@", %@ = '%@'",key,[params objectForKey:key]]];
        }
        
        i++;
    }
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    
    NSString *executeSQL = nil;
    
    if(conditions == nil){
        //如果没有条件 则更新全表
        executeSQL = [NSString stringWithFormat:@"update %@ set %@",tableName,updateStr];
    }else{
        //如果有条件则按条件更新
        executeSQL = [NSString stringWithFormat:@"update %@ set %@  where %@",tableName,updateStr,conditions];
    }
    //执行SQL文
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:executeSQL];
        
    }];
    
    return YES;
}

//根据条件查找数据返回键值字典 只得一条数据记录
//参数：
//tableName表名
//select查询所要的字段
//conditions查询条件
- (NSDictionary*) findDataByQueue:(NSString*)tableName  select:(NSString*)select conditions:(NSString*)conditions{
    
    NSString *querySQL;
    
    if(conditions == nil){
        //没有条件则查询全部
        querySQL = [NSString stringWithFormat: @"select %@ from %@",select,tableName];
    }else{
        //有条件就按条件查询
        querySQL = [NSString stringWithFormat: @"select %@ from %@ where %@",select,tableName,conditions];
    }
    
    
    //用于存放查询结果
    NSMutableDictionary *resultArray = [NSMutableDictionary dictionary];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    [queue inDatabase:^(FMDatabase *db) {
        //执行查询SQL
        FMResultSet *queryResult = [db executeQuery:querySQL];
        //读取一条结果集
        if([queryResult next]){
            //所需的结果字段数组
            NSArray *columnArray =[select componentsSeparatedByString:NSLocalizedString(@",", nil)];
            
            NSInteger columnCount = queryResult.columnCount;
            //如果查询的结果的字段数不等于所需的字段数则出错
            if (columnCount == columnArray.count) {
                //遍历字段名储存所需结果数据
                for (int i = 0; i < columnCount; i++) {
                    [resultArray setValue:[queryResult stringForColumn:[columnArray objectAtIndex:i]] forKey:[columnArray objectAtIndex:i]];
                }
            }else{
                //                NSLog(@"ERROR!");
            }
            
        }
        [queryResult close];
    }];
    
    if ([resultArray allKeys].count > 0) {
        return resultArray;
    }else{
        return nil;
    }
}


//按条件查询所需数据（多条记录结果）
//参数：
//tableName表名
//select查询所要的字段
//conditions查询条件
- (NSArray*) findAllDataByQueue:(NSString*)tableName  select:(NSString*)select conditions:(NSString*)conditions{
    NSString *querySQL;
    NSMutableArray *allDatas = [NSMutableArray arrayWithCapacity:0];
    
    
    if(conditions == nil){
        //没有条件则查询全部
        querySQL = [NSString stringWithFormat: @"select %@ from %@",select,tableName];
    }else{
        //有条件则按条件查询
        querySQL = [NSString stringWithFormat: @"select %@ from %@ where %@",select,tableName,conditions];
    }
    //所需的结果字段数组
    NSArray *columnArray =[select componentsSeparatedByString:NSLocalizedString(@",", nil)];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    [queue inDatabase:^(FMDatabase *db) {
        //执行查询SQL文返回结果
        FMResultSet *queryResult = [db executeQuery:querySQL];
        //遍历结果集
        while ([queryResult next]) {
            //resultArray用于存在每条数据结果
            NSMutableDictionary *resultArray = [NSMutableDictionary dictionary];
            NSInteger columnCount = queryResult.columnCount;
            //如果查询的结果的字段数不等于所需的字段数则出错
            if (columnCount == columnArray.count) {
                //遍历字段名储存所需结果数据
                for (int i = 0; i < columnCount; i++) {
                    [resultArray setValue:[queryResult stringForColumn:[columnArray objectAtIndex:i]] forKey:[columnArray objectAtIndex:i]];
                }
                //储存每条记录
                [allDatas addObject:resultArray];
            }else{
                //                NSLog(@"ERROR!");
            }
        }
        [queryResult close];
        
    }];
    //如果结果非空则返回结果数组否则返回nil
    if (allDatas.count >0) {
        return allDatas;
    }else{
        return nil;
    }
    
}

//清空表中记录的方法
//参数：
//tableName 表名
- (void) truncateTable:(NSString *)tableName{
    //新建数据库队列实例
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    [queue inDatabase:^(FMDatabase *db) {
        //执行清空数据表的操作 因为Sqlite没有专门的清表语句 故用此三条SQL文清表
        [db executeStatements:[NSString stringWithFormat:@"delete from '%@';select * from sqlite_sequence;update sqlite_sequence set seq=0 where name='%@';",tableName,tableName]];
        
    }];
}

@end
