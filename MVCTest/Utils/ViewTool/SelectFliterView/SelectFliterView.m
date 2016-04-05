//
//  SelectFliterView.m
//  MVCTest
//
//  Created by 乐业天空 on 15/7/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "SelectFliterView.h"

#define SelectFliterViewBaseTag    42693

/**
 * 按钮组件
 */
@interface SelectFliterViewBtn : UIButton

@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,strong) SelectFliterConfigure *config;

@end

@implementation SelectFliterViewBtn

-(id)initWithFrame:(CGRect)frame withConfig:(SelectFliterConfigure *)config
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.config = config;
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.userInteractionEnabled = NO;
        self.btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-config.lineHeight);
        self.btn.titleLabel.font = config.titleFont;
        [self.btn setTitleColor:config.titleColor forState:UIControlStateNormal];
        [self addSubview:self.btn];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-config.lineHeight, frame.size.width, config.lineHeight)];
        self.lineView.backgroundColor = config.lineColor;
        self.lineView.hidden = YES;
        [self addSubview:self.lineView];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected)
    {
        [self.btn setTitleColor:self.config.titleColor forState:UIControlStateNormal];
        [self.lineView setHidden:NO];
    }
    else
    {
        [self.btn setTitleColor:self.config.titleColorDefault forState:UIControlStateNormal];
        [self.lineView setHidden:YES];
    }
}

@end

/**
 * 选择器
 */
@interface SelectFliterView()

@property(nonatomic,strong) NSArray *titleArray;

@end
@implementation SelectFliterView

- (id)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr withConfig:(SelectFliterConfigure *)config
{
    self=[super initWithFrame:frame];
    if (self)
    {
        for (int i=0; i<titleArr.count; i++)
        {
            self.titleArray = titleArr;
            
            SelectFliterViewBtn *btn = [[SelectFliterViewBtn alloc] initWithFrame:CGRectMake(frame.size.width/titleArr.count*i, 0, frame.size.width/titleArr.count, frame.size.height-config.bgLineHeight/[[UIScreen mainScreen] scale]) withConfig:config];
            btn.tag = SelectFliterViewBaseTag + i;
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [btn.btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setIsSelected:NO];
            [self addSubview:btn];
            
            if (i==0)
            {
                [btn setIsSelected:YES];
            }
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-config.bgLineHeight, frame.size.width, config.bgLineHeight)];
        view.backgroundColor = config.bgLineColor;
        [self addSubview:view];
    }
    return self;
}

#pragma mark - 按钮响应
-(void)click:(SelectFliterViewBtn *)sender
{
    if (self.selectIndex != sender.tag-SelectFliterViewBaseTag)
    {
        self.selectIndex = sender.tag-SelectFliterViewBaseTag;
        
        for (NSInteger i = 0; i < self.titleArray.count; i ++)
        {
            SelectFliterViewBtn *btn = (SelectFliterViewBtn *)[self viewWithTag:SelectFliterViewBaseTag+i];
            btn.isSelected = NO;
            
        }
        
        sender.isSelected = YES;
        
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(selectFliterView:withValue:)])
            {
                [self.delegate selectFliterView:self withValue:sender.tag-SelectFliterViewBaseTag];
            }
        }
    }
}

#pragma mark - 重写
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        SelectFliterViewBtn *btn = (SelectFliterViewBtn *)[self viewWithTag:SelectFliterViewBaseTag+i];
        btn.isSelected = NO;
    }
    
    SelectFliterViewBtn *sender = (SelectFliterViewBtn *)[self viewWithTag:selectIndex+SelectFliterViewBaseTag];
    sender.isSelected = YES;
}

@end
