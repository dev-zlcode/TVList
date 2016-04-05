//
//  PlayerViewController.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/22.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayerViewController : BaseViewController

// 0 直播 1 回放
@property (nonatomic,assign) NSInteger type;

// 频道名
@property (nonatomic,strong) NSString *channel;
// 开始时间
@property (nonatomic,assign) NSInteger starttime;
// 结束时间
@property (nonatomic,assign) NSInteger endtime;

@end
