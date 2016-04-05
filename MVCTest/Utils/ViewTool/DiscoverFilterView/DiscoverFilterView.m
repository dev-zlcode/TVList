//
//  DiscoverFilterView.m
//  CallService
//
//  Created by jason on 14-11-22.
//  Copyright (c) 2014年 aa. All rights reserved.
//

#import "DiscoverFilterView.h"

// 最优高度为44  按钮数量为3到5个最佳

// 标题颜色
#define DiscoverFilterViewTitleColor           [UIColor blackColor]
// 细线颜色
#define DiscoverFilterViewTableSeparatorColor  [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1]
// 细线宽
#define DiscoverFilterViewTableSeparatorWidth 1.0/[UIScreen mainScreen].scale

#define EdgeX 8

@interface DiscoverFilterView()

@property(nonatomic,strong) NSArray *titleArray;

@end

@implementation DiscoverFilterView

#pragma mark - 自定义初始化方法
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)titleArr
{
    self=[super initWithFrame:frame];
    if (self)
    {
        // 保存标题数组
        self.titleArray = titleArr;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectIndex=-1;
        for (NSInteger i=0; i<titleArr.count; i++)
        {
            // 按钮宽度
            CGFloat BtnWidth = ([[UIScreen mainScreen] bounds].size.width-(titleArr.count-1)*DiscoverFilterViewTableSeparatorWidth)/titleArr.count;

            // 背景按钮
            UIButton *barItem=[UIButton buttonWithType:UIButtonTypeCustom];
            barItem.frame=CGRectMake((BtnWidth+DiscoverFilterViewTableSeparatorWidth)*i, 0, BtnWidth, self.frame.size.height-DiscoverFilterViewTableSeparatorWidth);
            [barItem setTag:100+i];
            [barItem addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            
            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(EdgeX, 0, barItem.bounds.size.width-10-EdgeX*2, barItem.bounds.size.height)];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 2;
            label.textColor = DiscoverFilterViewTitleColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titleArr[i];
            label.tag = 200+i;
            [barItem addSubview:label];
            
            // 下拉图标
            UIImageView *arrowImg=[[UIImageView alloc] initWithFrame:CGRectMake(barItem.bounds.size.width-10-EdgeX, (self.frame.size.height-10)/2.0, 10, 10)];
            [arrowImg setImage:[UIImage imageNamed:@"DiscoverFilterView_ico_arrow_down.png"]];
            [barItem addSubview:arrowImg];
            
            [self addSubview:barItem];
            
            // 竖分割线
            UIView *line=[[UIView alloc] initWithFrame:CGRectMake(BtnWidth+(BtnWidth+DiscoverFilterViewTableSeparatorWidth)*i, 0, DiscoverFilterViewTableSeparatorWidth, self.frame.size.height)];
            [line setBackgroundColor:DiscoverFilterViewTableSeparatorColor];
            [self addSubview:line];
        }
        
        // 横分割线
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-DiscoverFilterViewTableSeparatorWidth, self.frame.size.width, DiscoverFilterViewTableSeparatorWidth)];
        [line setBackgroundColor:DiscoverFilterViewTableSeparatorColor];
        [self addSubview:line];
    }
    return self;
}

#pragma mark - 按钮响应
- (void)selectButton:(UIButton *)sender
{
    int btnTag=(int)sender.tag-100;
    if (self.selectIndex==btnTag)
    {
        if ([self.delegate respondsToSelector:@selector(filterView:reSelectIndex:)])
        {
            [self.delegate filterView:self reSelectIndex:self.selectIndex];
        }
        self.selectIndex=-1;
    }
    else
    {
        self.selectIndex=btnTag;
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(filterView:selectIndex:)])
            {
                [self.delegate filterView:self selectIndex:self.selectIndex];
            }
        }
    }
}

#pragma mark - 自定义方法
// 设置标题
- (void)setTitleIndex:(NSInteger)index stirng:(NSString *)string
{
    UILabel *label = (UILabel *)[self viewWithTag:index+200];
    label.text = string;
}

// 初始化制定标题
- (void)resetTitleIndex:(NSInteger)index
{
    [self setTitleIndex:index stirng:self.titleArray[index]];
}

// 初始化所有标题
- (void)resetAllTitle
{
    [self.titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setTitleIndex:idx stirng:obj];
    }];
}

@end
