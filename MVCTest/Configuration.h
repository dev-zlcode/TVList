//
//  Configuration.h
//  MVCTest
//
//  Created by 张雷 on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#ifndef MVCTest_Configuration_h
#define MVCTest_Configuration_h

/**
 * 网络配置文件
 */

static const NSString *GET_YS_URL = @"http://serv.cbox.cntv.cn/json/zhibo/yangshipindao/ysmc/index.json"; // 央视
static const NSString *GET_WS_URL = @"http://serv.cbox.cntv.cn/json/zhibo/weishipindao/wsmc/index.json";  // 卫视
static const NSString *GET_DF_URL = @"http://serv.cbox.cntv.cn/json/zhibo/difangpindao/dfmc/index.json";  // 地方
static const NSString *GET_DETAIL_URL = @"http//tv.cntv.cn/index.php";                                    // 节目预告

static const NSString *LOCAL_HOST_URL = @"http://open.moretv.com.cn";

static const NSString *GET_AUTHORIZE = @"/authorize";                       // authorize接口
static const NSString *GET_ACCESS_TOKEN = @"/get_access_token";             // get_access_token接口
static const NSString *GET_MOVIESITE = @"/moviesite";                       // 内容分类列表接口

static const NSString *GET_POSITION = @"/position/movie";                   // 不同类型的内容推荐
static const NSString *GET_NEW = @"/new/movie";                             // 不同类型的最近更新列表
static const NSString *GET_SUBJECTS = @"/subjects/movie";                   // 获取专辑列表
static const NSString *GET_PAGE = @"page/index";                            // 混搭推荐列表
static const NSString *GET_CHANNEL = @"/channel/live";                      // 直播推荐

static const NSString *GET_LIVE = @"/live";                                 // 直播频道
static const NSString *GET_KEYWORD = @"/keyword";                           // 内容搜索
static const NSString *GET_SEAECH = @"/search";                             // 中文搜索

#endif
