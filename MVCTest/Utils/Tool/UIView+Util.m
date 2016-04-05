//
//  UIView+Util.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

- (UILabel *) labelWithTag:(NSInteger) tag
{
    return (UILabel *) [self viewWithTag:tag];
}

- (UIButton *) buttonWithTag:(NSInteger) tag
{
    return (UIButton *) [self viewWithTag:tag];
}

- (UIImageView *) imageViewWithTag:(NSInteger) tag
{
    return (UIImageView *) [self viewWithTag:tag];
}

- (void) setText:(NSString *) text toLabelWithTag:(NSInteger) tag;
{
    UILabel *l = [self labelWithTag:tag];
    if(l)
        l.text = text;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

@end
