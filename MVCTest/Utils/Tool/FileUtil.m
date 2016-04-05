//
//  FileUtil.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

/*删除特殊字符
 *@param    str   需要处理的字符串
 *@retrun   NSString    处理后的字符串
 */
+ (NSString *)delegateSpecialCharacters:(NSString *)str
{
    NSString *str1=[str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"!" withString:@""];
    return str2;
}

//存储路径
+ (NSString *)getPath
{
    NSArray * paths = nil;
    NSString * documentsDirectory = nil;
    
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);;
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *creatDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Caches/MyCache"];
    
    //创建文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"Caches/MyCache"] withIntermediateDirectories:YES attributes:nil error:nil];
    return creatDirectoryPath;
}

#pragma mark - Methods
//保存文件
+ (BOOL)saveFile:(NSData *)file WithFileName:(NSString *)name
{
    if (!file) return NO;
    NSString * dataPath = nil;
    dataPath = [[self getPath] stringByAppendingPathComponent:name];
    
    return [file writeToFile:dataPath atomically:YES];
}

//获取文件数据
+ (NSData *)getFile:(NSString *)name
{
    if (!name || [name isEqualToString:@""])
    {
        return nil;
    }
    NSString * dataPath = nil;
    
    dataPath = [[self getPath] stringByAppendingPathComponent:name];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    return [fm contentsAtPath:dataPath];
}

//删除文件
+ (BOOL)removeFile:(NSString *)name
{
    NSString * dataPath = nil;
    
    dataPath = [[self getPath] stringByAppendingPathComponent:name];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError* error;
    
    return [fm removeItemAtPath:dataPath error:&error];
}

//判断文件是否存在
+ (BOOL)isExistFile:(NSString *)name
{
    if (!name || [name isEqualToString:@""]) {
        return NO;
    }
    NSString * dataPath = nil;
    
    dataPath = [[self getPath] stringByAppendingPathComponent:name];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    return [fm fileExistsAtPath:dataPath];
}

//下载文件并保存
+ (void)downloadFileWithHttp:(NSString *)url withCallBackNotification:(NSString *)callbackNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (imgData) { //下载好后保存
            NSString *fileName = [FileUtil delegateSpecialCharacters:url];
            [FileUtil saveFile:imgData WithFileName:fileName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *retDict=[[NSMutableDictionary alloc] init];
            [retDict setObject:url forKey:@"url"];
            int result=imgData==nil? 0 :1;
            [retDict setObject:[NSNumber numberWithInt:result] forKey:@"result"];
            [[NSNotificationCenter defaultCenter] postNotificationName:callbackNotification object:retDict];
        });
    });
}

//获取文件夹大小:单位M
+(NSString *)getSizeCache
{
    //NSDirectoryEnumerator文件夹枚举器
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self getPath]];
    long long size = 0;
    
    //enumerator类似FMDB的resultSet,执行nextObject，枚举器就会把下一个文件的路径返回，同时enumerator.fileAttributes就是这个文件的属性,
    while ([enumerator nextObject])
    {
        size += [enumerator.fileAttributes fileSize];
    }
    //NSLog(@"目录下所有文件大小：%lld",size);
    
    //attributesOfItemAtPath如果路径写的是一个文件，那么返回的属性是这个文件的属性，大小也就是这个文件的大小；如果路径是一个文件夹的路径，那么返回的是这个文件夹的属性，大小只是这个文件夹所占的空间，不包含文件夹内的文件。
    //NSLog(@"------%lld",[[[NSFileManager defaultManager] attributesOfItemAtPath:NSHomeDirectory() error:nil] fileSize]);
    
    return [NSString stringWithFormat:@"%.1lfM",size/1000.0/1000.0];
}

//清理缓存：删除文件夹
+(void)clearCache
{
    //删除文件或文件夹
    [[NSFileManager defaultManager] removeItemAtPath:[self getPath] error:nil];
}

@end
