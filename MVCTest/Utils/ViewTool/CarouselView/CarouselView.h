//
//  CarouselView.h
//  xxx
//
//  Created by 乐业天空 on 15/7/14.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarouselViewDelegate;
@interface CarouselView : UIView

@property(nonatomic,assign) id delegate;

/*
 数组内存放UIImage类型对象
 */
-(instancetype)initWithFrame:(CGRect)frame withImgArray:(NSArray *)array;

@end

@protocol CarouselViewDelegate <NSObject>
/*
 从0开始
 */
-(void)carouselView:(CarouselView *)view withValue:(NSInteger)index;

@end