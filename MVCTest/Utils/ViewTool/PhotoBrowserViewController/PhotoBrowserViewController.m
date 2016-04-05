//
//  PhotoBrowserViewController.m
//  fasfasf
//
//  Created by 乐业天空 on 15/11/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "PhotoBrowserViewController.h"

#define TAG 13123123

@interface PhotoBrowserViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *pageLabel;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initView];
}

- (void)initView
{
    // 滑动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*self.imageUrlArray.count, self.view.bounds.size.height);
    for (NSInteger i = 0; i < self.imageUrlArray.count; i ++)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.tag = i+TAG;
        img.userInteractionEnabled = YES;
        if (self.imageUrlArray.count>i)
        {
            [img sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[i]] placeholderImage:[UIImage imageNamed:nil] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        [self.scrollView addSubview:img];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressG:)];
        [img addGestureRecognizer:longPress];
        
        // 图片标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width*i, self.scrollView.bounds.size.height-70, self.scrollView.bounds.size.width, 21)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (self.titleArray.count>i)
        {
            titleLabel.text = self.titleArray[i];
        }
        [self.scrollView addSubview:titleLabel];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width*self.currentNum, 0);
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapG:)];
    [self.scrollView addGestureRecognizer:tap];
    
    // 页码
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    // 小不点
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-45, self.view.bounds.size.width, 30)];
    self.pageControl.numberOfPages = self.imageUrlArray.count;
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    [self refreshPage];
}

// 刷新界面数据
- (void)refreshPage
{
    NSInteger index = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    
    if ((index>0||index==0)&&index<self.imageUrlArray.count)
    {
        index = index + 1;
    }
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index,(unsigned long)self.imageUrlArray.count];
    
    // 切换小不点
    self.pageControl.currentPage = index-1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    [self refreshPage];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:self.pageControl.currentPage+TAG];
        if (imageView.image)
        {
            [self saveImageToPhotos:imageView.image];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"图片加载中，请稍后重试！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma - UIPageControl响应
- (void)pageControl:(UIPageControl *)sender
{
    // 切换scrollview
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width*self.pageControl.currentPage, 0);
    
    [self refreshPage];
}

#pragma mark - 点击事件：退出
- (void)tapG:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 长按事件：保存图片
- (void)longPressG:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - 保存图片到本地相册
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }
    else
    {
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
