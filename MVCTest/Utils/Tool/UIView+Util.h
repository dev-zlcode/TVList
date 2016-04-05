//
//  UIView+Util.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (UILabel *) labelWithTag:(NSInteger) tag;
- (UIButton *) buttonWithTag:(NSInteger) tag;
- (UIImageView *) imageViewWithTag:(NSInteger) tag;
- (void) setText:(NSString *) text toLabelWithTag:(NSInteger) tag;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

@end
