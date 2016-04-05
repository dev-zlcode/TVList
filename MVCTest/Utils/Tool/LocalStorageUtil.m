//
//  LocalStorageUtil.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "LocalStorageUtil.h"

@implementation LocalStorageUtil

+(void) setArray:(NSArray *)info forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *) getArray:(NSString *)key
{
    NSArray *info = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return info;
}

+(void) setInfo:(NSString *)info forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getInfo:(NSString *)key
{
    NSString *info = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (info == nil) {
        return @"";
    }
    return info;
}

+ (BOOL) getBoolValue:(NSString *) key
{
    NSNumber *v = (NSNumber *) [[NSUserDefaults standardUserDefaults]
                                objectForKey:key];
    BOOL boolValue = v && v.boolValue;
    boolValue = YES;
    return boolValue;
}

+(void) setBoolValue:(BOOL) v forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:v]
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeInfo:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
