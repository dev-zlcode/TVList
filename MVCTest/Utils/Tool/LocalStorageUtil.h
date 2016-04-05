//
//  LocalStorageUtil.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorageUtil : NSObject

+ (void) setArray:(NSArray *)info forKey:(NSString *)key;
+ (NSArray *) getArray:(NSString *)key;
+ (void) setInfo:(NSString *)info forKey:(NSString *)key;
+ (NSString *) getInfo:(NSString *)key;
+ (void) removeInfo:(NSString *)key;
+ (BOOL) getBoolValue:(NSString *) key;
+ (void) setBoolValue:(BOOL) v forKey:(NSString *)key;

@end
