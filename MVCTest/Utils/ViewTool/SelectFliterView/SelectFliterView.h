//
//  SelectFliterView.h
//  MVCTest
//
//  Created by 乐业天空 on 15/7/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFliterConfigure.h"

@protocol SelectFliterViewDelegate;
@interface SelectFliterView : UIView

- (id)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr withConfig:(SelectFliterConfigure *)config;

/** 
 *当前选中的按钮
 */
@property(nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,assign)id <SelectFliterViewDelegate> delegate;

@end

//协议
@protocol SelectFliterViewDelegate <NSObject>

-(void)selectFliterView:(SelectFliterView *)selectFliterView withValue:(NSInteger)value;

@end
