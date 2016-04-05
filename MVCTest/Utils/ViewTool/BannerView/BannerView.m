//
//  BannerView.m
//  Test
//
//  Created by 乐业天空 on 15/11/20.
//  Copyright © 2015年 myjobsky. All rights reserved.
//

#import "BannerView.h"

//引导页切换动画时间
#define AnimationTime 1

@interface BannerView()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSInteger _speed;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)NSArray *array;

@end

@implementation BannerView

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.array = array;
        
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  self.frame.size.width, self.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*self.array.count, self.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0 ; i < self.array.count; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:self.array[i]];
        // TODO 网络图片更换出
        imageView.userInteractionEnabled = YES;
        imageView.restorationIdentifier = @(i).stringValue;
        [self.scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
    }
    
    self.page = [[UIPageControl alloc] init];
    self.page.frame = CGRectMake(0, self.frame.size.height-20,  self.frame.size.width, 20);
    [self.page addTarget:self action:@selector(pageClick) forControlEvents:UIControlEventTouchUpInside];
    self.page.numberOfPages = self.array.count;
    self.page.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:self.page];
    
    //定时器
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        _speed = 1;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 小不点切换
-(void)pageClick
{
    NSInteger index = self.page.currentPage;
    [UIView animateWithDuration:AnimationTime animations:^{
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width*index, 0);
    }];
}

#pragma amrk - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.scrollView.contentOffset.x/self.frame.size.width;
    self.page.currentPage = index;
}

#pragma mark - 定时器
-(void)timer:(NSTimer *)sender
{
    //让图片自动切换
    self.page.currentPage += _speed;
    if(self.page.currentPage == self.array.count-1 || self.page.currentPage == 0)
    {
        _speed = -_speed;
    }
    self.scrollView.contentOffset = CGPointMake(self.page.currentPage*self.scrollView.bounds.size.width, 0);
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    if ([self.delegate respondsToSelector:@selector(bannerView:index:)])
    {
        [self.delegate bannerView:self index:[imageView.restorationIdentifier integerValue]];
    }
}

@end
