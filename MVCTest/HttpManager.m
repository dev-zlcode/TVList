//
//  HttpManager.m
//  MVCTest
//
//  Created by 乐业天空 on 15/7/3.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

// 通用post请求
+ (void)post:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock
{
    NSLog(@"url:%@\n%@",URLString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"url:%@\n%@\nresponse:%@",URLString,dic,[[NSString alloc] initWithData:[Tools objectToJSON:responseObject] encoding:NSUTF8StringEncoding]);
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            successDicBlack([NSMutableDictionary dictionaryWithDictionary:responseObject]);
        }
        else
        {
            errBlock();
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        errBlock();
    }];
}

// 通用get请求
+ (void)get:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock
{
    NSLog(@"url:%@\n%@",URLString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *retDic = [Tools JSONToObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
         NSLog(@"url:%@\n%@\nresponse:%@",URLString,dic,[[NSString alloc] initWithData:[Tools objectToJSON:retDic] encoding:NSUTF8StringEncoding]);
        
        successDicBlack([NSMutableDictionary dictionaryWithDictionary:retDic]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        errBlock();
    }];
}

// 获取网页
+ (void)postHtml:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessStrBlack)successStrBlack failure:(ErrorBlack)errBlock;
{
    NSLog(@"url:%@\n%@",URLString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"url:%@\n%@\nresponse:%@",URLString,dic,str);
        if (str)
        {
            successStrBlack(str);
        }
        else
        {
            errBlock();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errBlock();
    }];
}

// 电视猫 auth2.0 访问
+ (void)getAuth:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parDic setObject:[LocalStorageUtil getInfo:MORETV_ACCESS_TOKEN] forKey:@"access_token"];
    [HttpManager get:URLString
                pars:parDic
             success:^(NSMutableDictionary *sucRetDic) {
               
                 // 获取信息成功
                 if ([sucRetDic[@"status"] integerValue] == 0)
                 {
                     successDicBlack(sucRetDic);
                 }
                 // token过期
                 else if ([sucRetDic[@"status"] integerValue] == 106)
                 {
                     // 获取token
                     [self getTokenSuccess:^(NSString *sucRetStr) {
                         
                         [parDic setObject:[LocalStorageUtil getInfo:MORETV_ACCESS_TOKEN] forKey:@"access_token"];
                         [
                          HttpManager get:URLString
                                     pars:parDic
                                  success:^(NSMutableDictionary *sucRetDic) {
                                      successDicBlack(sucRetDic);
                                  } failure:^{
                                      errBlock();
                                  }];
                         
                     } failure:^(NSString *errRetStr) {
                         errBlock();
                     }];
                 }
                 else
                 {
                     errBlock();
                 }
                 
           } failure:^{
               errBlock();
           }];
}

+ (void) getTokenSuccess:(SuccessStrBlack)successStrBlack failure:(ErrorStrBlack)errStrBlock;
{
    // 获取authorize
    [HttpManager get:[NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL,GET_AUTHORIZE]
                pars:@{@"appid":MORETV_APP_ID}
             success:^(NSMutableDictionary *sucRetDic) {
                 
                 // 获取authorize成功
                 if ([sucRetDic[@"status"] integerValue] == 200)
                 {
                     [LocalStorageUtil setInfo:sucRetDic[@"authorize_code"] forKey:MORETV_AUTHORIZE_CODE];
                     
                     // 获取token
                     [HttpManager get:[NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL,GET_ACCESS_TOKEN]
                                 pars:@{@"authorize_code":[LocalStorageUtil getInfo:MORETV_AUTHORIZE_CODE],
                                        @"key":[MyObject createKey]}
                              success:^(NSMutableDictionary *sucRetDic) {
                                  
                                  // 获取token成功
                                  if ([sucRetDic[@"status"] integerValue] == 200)
                                  {
                                      [LocalStorageUtil setInfo:sucRetDic[@"access_token"] forKey:MORETV_ACCESS_TOKEN];
                                      successStrBlack(@"获取token成功");
                                  }
                                  // 获取token失败
                                  else
                                  {
                                      errStrBlock(@"获取token失败");
                                  }
                              } failure:^{
                                  errStrBlock(@"获取token失败");
                              }];
                 }
                 // 获取authorize失败
                 else
                 {
                     errStrBlock(@"获取authorize失败");
                 }
             } failure:^{
                 errStrBlock(@"获取authorize失败");
             }];
}

@end
