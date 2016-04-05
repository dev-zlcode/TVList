//
//  MyObject.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/21.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

// 生成key
+ (NSString *) createKey
{
    //  md5(appid+”_”+ secret +”_”+ code)
    NSString *string = [NSString stringWithFormat:@"%@_%@_%@",MORETV_APP_ID,MORETV_SECRET,[LocalStorageUtil getInfo:MORETV_AUTHORIZE_CODE]];
    NSLog(@"%@",string);
    return [Tools md5:string];
}

@end
