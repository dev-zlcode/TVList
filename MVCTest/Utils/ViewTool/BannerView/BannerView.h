//
//  BannerView.h
//  Test
//
//  Created by 乐业天空 on 15/11/20.
//  Copyright © 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 使用方法
 
 - (void)viewDidLoad
 {
 BannerView *view = [[BannerView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 100) array:@[@"123.png",@"123.png",@"123.png"]];
 view.delegate = self;
 [self.view addSubview:view];
 }
 - (void)bannerView:(BannerView *)view index:(NSInteger)index
 {
    // 选中的代理方法
 }
 
 */

@protocol BannerViewDelegate;
@interface BannerView : UIView

@property(nonatomic,assign)id delegate;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end

@protocol BannerViewDelegate <NSObject>

- (void)bannerView:(BannerView *)view index:(NSInteger)index;

@end