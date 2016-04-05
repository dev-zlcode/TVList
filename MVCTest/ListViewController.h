//
//  ListViewController.h
//  MVCTest
//
//  Created by 张雷 on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "BaseVirtualViewController.h"

@interface ListViewController : BaseVirtualViewController

@property (nonatomic,assign) UInt64 menuid;

/**
 * 0 央视
 * 1 卫视
 * 2 其他
 * 3 省市
 */

@property (nonatomic,assign) NSInteger type;

@end
