//
//  SelectFliterConfigure.h
//  MVCTest
//
//  Created by 乐业天空 on 15/7/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 颜色 大小 配置类
 */
@interface SelectFliterConfigure : NSObject

/** 标题点击颜色*/
@property(nonatomic,strong) UIColor *titleColor;
/** 标题默认颜色*/
@property(nonatomic,strong) UIColor *titleColorDefault;
/** 标题字体*/
@property(nonatomic,strong) UIFont *titleFont;
/** 标题小线颜色*/
@property(nonatomic,strong) UIColor *lineColor;
/** 标题小线高度*/
@property(nonatomic,assign) CGFloat lineHeight;
/** 背景线颜色*/
@property(nonatomic,strong) UIColor *bgLineColor;
/** 背景线高度*/
@property(nonatomic,assign) CGFloat bgLineHeight;

@end
