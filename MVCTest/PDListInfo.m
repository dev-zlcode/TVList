//
//  PDListInfo.m
//  MVCTest
//
//  Created by 张雷 on 16/1/8.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "PDListInfo.h"

@implementation PDListInfo

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"NewChannelImg" : @"newChannelImg"};
}

@end
