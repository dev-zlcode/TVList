//
//  CarouselView.m
//  xxx
//
//  Created by 乐业天空 on 15/7/14.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "CarouselView.h"

#define CarouselViewTimer 2
#define CarouselViewTag 432481

@interface  CarouselView()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSInteger _speed;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)NSArray *array;

@end
@implementation CarouselView

-(instancetype)initWithFrame:(CGRect)frame withImgArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.array = array;
        
        //滑动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [self addSubview:self.scrollView];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*array.count, self.scrollView.bounds.size.height);
        for (NSInteger i = 0; i < array.count; i ++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            if ([self.array[i] isKindOfClass:[UIImage class]])
            {
                [btn setBackgroundImage:self.array[i] forState:UIControlStateNormal];
            }
            btn.tag = CarouselViewTag+i;
            [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
        }
        
        //page
        self.page = [[UIPageControl alloc] init];
        self.page.bounds = CGRectMake(0, 0, self.frame.size.width, 30);
        self.page.center = CGPointMake(self.frame.size.width/2.0, (self.frame.size.height-30)+30/2.0);
        [self addSubview:self.page];
        [self.page addTarget:self action:@selector(pageClick) forControlEvents:UIControlEventTouchUpInside];
        self.page.numberOfPages = array.count;
        self.page.currentPageIndicatorTintColor = [UIColor blackColor];
        self.page.pageIndicatorTintColor = [UIColor whiteColor];
        
        //定时器
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
            _speed = 1;
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
    return self;
}

#pragma amrk - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    self.page.currentPage = index;
}

#pragma mark - 小不点切换
-(void)pageClick
{
    NSInteger index = self.page.currentPage;
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width*index, 0);
    }];
}

#pragma mark -  定时器
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

#pragma mark - 广告按钮
-(void)addClick:(UIButton *)sender
{
    NSInteger index = sender.tag - CarouselViewTag;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(carouselView:withValue:)])
        {
            [self.delegate carouselView:self withValue:index];
        }
    }
}

@end
