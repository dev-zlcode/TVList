//
//  ProvincePDListlInfo.m
//  MVCTest
//
//  Created by 张雷 on 16/1/11.
//  Copyright © 2016年 zhanlgei. All rights reserved.
//

#import "ProvincePDListlInfo.h"

@implementation ProvincePDListlInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@\n",self.time,self.channelName];
}

- (id)initProvincePDListlInfo:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {

        NSArray *array = [dic objectForKey:@"td"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([[obj objectForKey:@"_class"] isEqualToString:@"chnl"])
            {
                self.channelName = [[[obj objectForKey:@"div"] objectForKey:@"a"] objectForKey:@"__text"];
                self.channelUrl = [[[obj objectForKey:@"div"] objectForKey:@"a"] objectForKey:@"_href"];
            }
            else if ([[obj objectForKey:@"_class"] isEqualToString:@"cur"])
            {
                self.time = [[obj objectForKey:@"div"] objectForKey:@"__text"];
            }
            else
            {
                self.t = [[[obj objectForKey:@"div"] objectForKey:@"a"] objectForKey:@"__text"];
                if ([Tools isEmpty:self.t])
                {
                    self.t = [[obj objectForKey:@"div"] objectForKey:@"__text"];
                }
            }
            
        }];
    }
    return self;
}

@end
