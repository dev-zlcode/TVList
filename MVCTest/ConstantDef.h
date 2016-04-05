//
//  ConstantDef.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#ifndef MVCTest_ConstantDef_h
#define MVCTest_ConstantDef_h

/**
 * 全局变量和宏定义
 */

static NSString   *const APP_ID = @"1076907533";

// http://dev.moretv.com.cn/openapi/api
static NSString   *const MORETV_APP_ID = @"df309a060c6cadbddc4981dccbe6e174"; // AppId
static NSString   *const MORETV_SECRET = @"2cfa2e48f707b7d5188e4d75d8a698b5"; // Secret

// 常量
static NSString   *const MORETV_AUTHORIZE_CODE = @"authorize_code";           // authorize_code
static NSString   *const MORETV_ACCESS_TOKEN = @"access_token";               // access_token

static NSString   *const IS_LINING = @"is_lining";                            // 是否上线

// 提示常量
static NSString   *const NETWORK_ERROR_INFO = @"当前网络不可用";
static NSString   *const API_ERROR_INFO = @"访问失败";
static NSString   *const LOADING_INFO = @"加载中...";

#endif
