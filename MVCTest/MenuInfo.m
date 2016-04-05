//
//  MenuInfo.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "MenuInfo.h"

@implementation MenuInfo

- (id)initMenuInfo:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.name = [dic objectForKey:@"__text"];
        self.proId = [Tools handleNull:[dic objectForKey:@"_prov"]];
    }
    return self;
}

@end
