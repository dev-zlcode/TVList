//
//  CastInfo.h
//  MVCTest
//
//  Created by 张雷 on 16/1/23.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CastInfo : NSObject

// icon 45*45
@property (nonatomic,strong) NSString *image45;
// 介绍
@property (nonatomic,strong) NSString *intro;
// 完整图片
@property (nonatomic,strong) NSString *whole_image;
// 区域
@property (nonatomic,strong) NSString *area;
// 类型 person
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *douban_image;
@property (nonatomic,strong) NSString *image;
// 演员名字
@property (nonatomic,strong) NSString *actor;
// App调用字串
@property (nonatomic,strong) NSString *link_data;
// 英文名
@property (nonatomic,strong) NSString *actor_en;
// 生日
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *constellation;
// 微博id
@property (nonatomic,strong) NSString *weiboId;
// 工作类型 演员|副导演
@property (nonatomic,strong) NSString *job;
// 荣誉 奖项
@property (nonatomic,strong) NSString *honor;
// App调用字串
@property (nonatomic,strong) NSString *background_image;

// 影集
@property (nonatomic,strong) NSArray *stills;


@end
