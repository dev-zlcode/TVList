//
//  DetailViewController.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailViewController : BaseViewController

// id
@property (nonatomic,assign) NSInteger listid;
// 频道名
@property (nonatomic,strong) NSString *channel;

@end
