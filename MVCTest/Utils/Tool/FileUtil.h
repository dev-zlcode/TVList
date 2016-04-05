//
//  FileUtil.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

/*删除特殊字符
 *@param    str   需要处理的字符串
 *@retrun   NSString    处理后的字符串
 */
+ (NSString *)delegateSpecialCharacters:(NSString *)str;

//存储路径
+ (NSString *)getPath;

//判断文件是否存在
+ (BOOL)isExistFile:(NSString *)name;

//获取文件数据
+ (NSData *)getFile:(NSString *)name;

//保存文件
+ (BOOL)saveFile:(NSData *)file WithFileName:(NSString *)name;

//删除文件
+ (BOOL)removeFile:(NSString *)name;

//下载文件并保存
+ (void)downloadFileWithHttp:(NSString *)url
    withCallBackNotification:(NSString *)callbackNotification;

//获取文件夹大小
+(NSString *)getSizeCache;

//清理缓存：删除文件夹
+(void)clearCache;

@end
