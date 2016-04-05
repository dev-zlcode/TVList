//
//  VersionViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 15/7/1.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "VersionViewController.h"

//引导页张数
#define Num 3
//引导页切换动画时间
#define AnimationTime 1

#define BtnHeight 30
#define BtnWidth  100

@interface VersionViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *page;

@end

@implementation VersionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //已经使用过软件
    [LocalStorageUtil setInfo:@"1" forKey:@"Logined"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self initView];
}

-(void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*Num, ScreenHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0 ; i < Num; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"VersionImage%d.png",i]];
        [self.scrollView addSubview:imageView];
    }
    
    self.page = [[UIPageControl alloc] init];
    self.page.frame = CGRectMake(0, ScreenHeight-30,  self.view.bounds.size.width, 20);
    [self.page addTarget:self action:@selector(pageClick) forControlEvents:UIControlEventTouchUpInside];
    self.page.numberOfPages = Num;
    self.page.currentPageIndicatorTintColor = [UIColor blackColor];
    self.page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.page];
    
    //直接进入主页
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(ScreenWidth*2+(ScreenWidth-BtnWidth)/2.0, ScreenHeight-BtnHeight-30, BtnWidth, BtnHeight)];
    [nextBtn setBackgroundColor:Color];
    [nextBtn setTitle:@"进入应用" forState:UIControlStateNormal];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 2;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextBtn addTarget:self action:@selector(gotoHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
}

#pragma mark - 进入应用
-(void)gotoHomePage
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [APPDelegate gotoMainViewController];
}

#pragma mark - 小不点切换
-(void)pageClick
{
    NSInteger index = self.page.currentPage;
    [UIView animateWithDuration:AnimationTime animations:^{
        self.scrollView.contentOffset = CGPointMake(ScreenWidth*index, 0);
    }];
}

#pragma amrk - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.scrollView.contentOffset.x/ScreenWidth;
    self.page.currentPage = index;
}
@end
