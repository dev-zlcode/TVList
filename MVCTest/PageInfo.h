//
//  PageInfo.h
//  MVCTest
//
//  Created by 乐业天空 on 15/12/15.
//  Copyright © 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageInfo : NSObject

// 是否可以上一页
@property(nonatomic,assign) BOOL IsPreviousPage;
// 总条数
@property(nonatomic,assign) NSInteger TotalCount;
// 每页条数
@property(nonatomic,assign) NSInteger PageSize;
// 当前页
@property(nonatomic,assign) NSInteger PageIndex;

// 是否可以下一页
@property(nonatomic,assign) BOOL IsNextPage;
// 总页数
@property(nonatomic,assign) NSInteger TotalPage;

@end
