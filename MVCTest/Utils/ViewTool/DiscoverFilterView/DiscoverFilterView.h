//
//  DiscoverFilterView.h
//  CallService
//
//  Created by ; on 14-11-22.
//  Copyright (c) 2014年 aa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverFilterViewDelegate;
@interface DiscoverFilterView : UIView

// 当前选中按钮 默认为-1表示没有选中任何按钮
@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic, assign) id<DiscoverFilterViewDelegate>delegate;

// 自定义初始化方法
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArr;
/*
 * index:   按钮序号从0开始
 * string:  需要设置的内容
 */
- (void)setTitleIndex:(NSInteger)index stirng:(NSString *)string;
// 初始化制定标题
- (void)resetTitleIndex:(NSInteger)index;
// 初始化所有标题
- (void)resetAllTitle;

@end

@protocol DiscoverFilterViewDelegate <NSObject>

// 第一次选中
- (void)filterView:(DiscoverFilterView *)view selectIndex:(NSInteger)index;
// 第二次选中
- (void)filterView:(DiscoverFilterView *)view reSelectIndex:(NSInteger)index;

@end
