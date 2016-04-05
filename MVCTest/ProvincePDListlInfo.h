//
//  ProvincePDListlInfo.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/11.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvincePDListlInfo : NSObject

@property (nonatomic,strong)NSString *channelName;
@property (nonatomic,strong)NSString *channelUrl;
@property NSString *time;
@property NSString *t;

- (id)initProvincePDListlInfo:(NSDictionary *)dic;

@end
