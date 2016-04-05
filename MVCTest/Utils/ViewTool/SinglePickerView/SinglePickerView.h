//
//  SinglePickerView.h
//  fasfasf
//
//  Created by 乐业天空 on 15/11/7.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinglePickerViewDelegate;
@interface SinglePickerView : UIView

@property(nonatomic,assign) id delegate;

// 初始化  最佳高度260
- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;

// 显示
- (void)showPickerView;
// 隐藏
- (void)hidePickerView;

@end

@protocol SinglePickerViewDelegate <NSObject>

- (void)singlePicker:(SinglePickerView *)view index:(NSInteger)index value:(NSString *)value;

@end