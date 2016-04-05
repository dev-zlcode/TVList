//
//  HomeViewController.h
//  MVCTest
//
//  Created by 张雷 on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

/**
 * 0 央视
 * 1 卫视
 * 2 其他
 * 3 省市
 */

@property (nonatomic,assign) NSInteger type;

@end
