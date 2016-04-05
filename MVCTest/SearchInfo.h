//
//  SearchInfo.h
//  MVCTest
//
//  Created by 张雷 on 16/1/22.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchInfo : NSObject

@property (nonatomic,strong) NSString *item_subscriptUrl;
// 内容的所属年代
@property (nonatomic,assign) NSInteger item_year;
// 内容类型 movie/tv/jilu/zongyi/comic/kids, subject
@property (nonatomic,strong) NSString *item_contentType;
@property (nonatomic,strong) NSString *item_subscriptCode;
// 内容的总集数
@property (nonatomic,strong) NSString *item_episodeCount;
@property (nonatomic,assign) NSInteger item_duration;
// 内容的唯一标示
@property (nonatomic,strong) NSString *item_sid;
// 节目名
@property (nonatomic,strong) NSString *high;
// 内容当前更新到的集/期 数
@property (nonatomic,strong) NSString *item_episode;
// App调用字串
@property (nonatomic,strong) NSString *link_data;
@property (nonatomic,strong) NSString *show_time;
// 内容的评分
@property (nonatomic,strong) NSString *item_score;
@property (nonatomic,assign) NSInteger item_type;
// 编排内容的title
@property (nonatomic,strong) NSString *item_title;
// 编排内容的海报图 竖图 小
@property (nonatomic,strong) NSString *item_icon1;
// 内容是否高清
@property (nonatomic,strong) NSString *item_isHd;
// 内容所属的地区
@property (nonatomic,strong) NSString *item_area;

// 导演
@property (nonatomic,strong) NSArray *item_director;
// 标签
@property (nonatomic,strong) NSArray *item_tag;
// 演员
@property (nonatomic,strong) NSArray *item_cast;
@property (nonatomic,strong) NSArray *item_host;

@end
