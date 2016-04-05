//
//  PDDetailInfo.h
//  MVCTest
//
//  Created by 张雷 on 16/1/9.
//  Copyright © 2016年 zhanlgei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDetailInfo : NSObject

// 节目名
@property (nonatomic,strong) NSString *t;
// 播放时间
@property (nonatomic,strong) NSString *showTime;
// 开始时间
@property (nonatomic,assign) NSInteger st;
// 结束时间
@property (nonatomic,assign) NSInteger et;
// 节目时长
@property (nonatomic,assign) NSInteger duration;

// -1 暂未播放 0 直播 1 回播
@property (nonatomic,assign) NSInteger isLiving;

@end
