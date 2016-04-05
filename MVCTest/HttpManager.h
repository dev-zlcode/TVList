//
//  HttpManager.h
//  MVCTest
//
//  Created by 乐业天空 on 15/7/3.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

/**
 请求成功回掉
 retDic       结果字典
 retStr       结果字符串
 */
typedef void(^SuccessBlack)(void);
typedef void(^SuccessArrBlack)(NSMutableArray *sucRetArr);
typedef void(^SuccessDicBlack)(NSMutableDictionary *sucRetDic);
typedef void(^SuccessStrBlack)(NSString *sucRetStr);

/**
 请求失败回掉
 retDic       结果字典
 retStr       结果字符串
 */
typedef void(^ErrorBlack)(void);
typedef void(^ErrorArrBlack)(NSMutableArray *errorRetArr);
typedef void(^ErrorDicBlack)(NSMutableDictionary *errRetDic);
typedef void(^ErrorStrBlack)(NSString *errRetStr);

// 通用post请求
+ (void)post:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock;

// 通用get请求
+ (void)get:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock;

// 获取网页
+ (void)postHtml:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessStrBlack)successStrBlack failure:(ErrorBlack)errBlock;

// 电视猫 auth2.0 访问
+ (void)getAuth:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock;

@end
