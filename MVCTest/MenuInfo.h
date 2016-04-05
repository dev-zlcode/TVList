//
//  MenuInfo.h
//  MVCTest
//
//  Created by 张雷 on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfo : NSObject

@property NSString *name;
@property (nonatomic,strong)NSString *proId;

- (id)initMenuInfo:(NSDictionary *)dic;

@end
