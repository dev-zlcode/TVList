//
//  MethodDetailViewController.h
//  MVCTest
//
//  Created by 张雷 on 16/1/6.
//  Copyright © 2016年 zhanlgei. All rights reserved.
//

#import "BaseViewController.h"

@interface MethodDetailViewController : BaseViewController

// 0 html 1 http
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *string;

@end
