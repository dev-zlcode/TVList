//
//  BaseViewController.m
//  MVCTest
//
//  Created by 张雷 on 15/6/29.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import "BaseViewController.h"
#import "VersionViewController.h"
#import "HomeViewController.h"

@interface BaseViewController ()<MBProgressHUDDelegate>
// 加载等待
@property(nonatomic,strong)MBProgressHUD * mBProgressHUD;
@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监听网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityManagerNotific:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //如果有标签，标签的高会自动减去
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    //如果不是根视图控制器
    if (self.navigationController.viewControllers.count>1)
    {
        [self setNavigationLeftBarWithTitle:@""];
    }
}

#pragma mark - 设置导航左边按钮
- (void)setNavigationLeftBarWithTitle:(NSString *)title
{
    CGFloat titleWidth=30.0;
    
    CGSize titleSize=[title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];;
    
    if (titleSize.width>30)
    {
        titleWidth=titleSize.width;
    }
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, titleWidth+10, 40)];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 8, 14)];
    [imgView setImage:[Tools imageWithColor:[UIColor whiteColor] image:[UIImage imageNamed:@"ico_arrow_left_black.png"]]];
    [leftBtn addSubview:imgView];
    
    UILabel *tLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0,  titleSize.width, 40)];
    [tLabel setText:title];
    [tLabel setTextColor:[UIColor blackColor]];
    [tLabel setFont:[UIFont systemFontOfSize:17]];
    [leftBtn addSubview:tLabel];
    
    [leftBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBar];
}

#pragma mark - 返回
- (void)gotoBack
{
    [self hideIndicatorView];
    [self hideTipView];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 显示指示器
- (void)showIndicatorWithTitle:(NSString *)title
{
    [self showIndicatorWithTitle:title view:self.view];
}

- (void)showIndicatorWithTitle:(NSString *)title view:(UIView *)view
{
    if (self.mBProgressHUD)
    {
        [self.mBProgressHUD removeFromSuperview];
    }
    
    self.mBProgressHUD = [[MBProgressHUD alloc] initWithView:view];
    self.mBProgressHUD.delegate =self;
    [view addSubview:self.mBProgressHUD];
    
    // 内容类型
    self.mBProgressHUD.mode = MBProgressHUDModeIndeterminate;
    // 动画类型
    self.mBProgressHUD.animationType = MBProgressHUDAnimationFade;
    // 显示的文字
    self.mBProgressHUD.labelText = title;
    self.mBProgressHUD.labelFont = [UIFont systemFontOfSize:14];
    
    [self.mBProgressHUD show:YES];
}

#pragma mark - 隐藏指示器
- (void)hideIndicatorView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mBProgressHUD hide:YES];
    });
}

#pragma mark - 显示提示视图
- (void)showTipView:(TipType)type withTitle:(NSString *)title
{
    switch (type)
    {
        case TipTypeSuccess:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:self.view];
            tipView.delegate =self;
            [self.view addSubview:tipView];
            
            tipView.mode = MBProgressHUDModeCustomView;
            tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:1.5f];
        }
            break;
        case TipTypeError:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:self.view];
            tipView.delegate =self;
            [self.view addSubview:tipView];
            
            tipView.mode = MBProgressHUDModeCustomView;
            tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Errormark.png"]];
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:1.5f];
        }
            break;
        case TipTypeInfo:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:self.view];
            tipView.delegate =self;
            [self.view addSubview:tipView];
            
            // 内容类型
            tipView.mode = MBProgressHUDModeText;
            // 动画类型
            tipView.animationType = MBProgressHUDAnimationFade;
            // 显示的文字
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            // 边距
            tipView.margin = 10.f;
            // 圆角
            tipView.cornerRadius = 5.0f;
            // y偏移
            tipView.yOffset = self.view.bounds.size.height/2.0-50;
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showTipView:(TipType)type title:(NSString *)title
{
    UIWindow *view = APPDelegate.window;
    
    switch (type)
    {
        case TipTypeSuccess:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:view];
            [view addSubview:tipView];
            
            tipView.mode = MBProgressHUDModeCustomView;
            tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:1.5f];
        }
            break;
        case TipTypeError:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:view];
            [view addSubview:tipView];
            
            tipView.mode = MBProgressHUDModeCustomView;
            tipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Errormark.png"]];
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:1.5f];
        }
            break;
        case TipTypeInfo:
        {
            MBProgressHUD * tipView = [[MBProgressHUD alloc] initWithView:view];
            [view addSubview:tipView];
            
            // 内容类型
            tipView.mode = MBProgressHUDModeText;
            // 动画类型
            tipView.animationType = MBProgressHUDAnimationFade;
            // 显示的文字
            tipView.labelText = title;
            tipView.labelFont = [UIFont systemFontOfSize:14];
            // 边距
            tipView.margin = 10.f;
            // 圆角
            tipView.cornerRadius = 5.0f;
            // y偏移
            tipView.yOffset = view.bounds.size.height/2.0-50;
            
            [tipView show:YES];
            [tipView hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
}

- (void)hideTipView
{
    
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (hud)
    {
        [hud removeFromSuperview];
    }
}

#pragma 监听网络通知
-(void)networkReachabilityManagerNotific:(NSNotification *)sender
{
    // 非引导页 登录页显示 显示
    if (![self isKindOfClass:[VersionViewController class]] && ![self isKindOfClass:[HomeViewController class]])
    {
        NSDictionary *dic = sender.userInfo;
        if ([[dic objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue]>0)
        {
            NSLog(@"%@",@"网络已连接");
            
            // [self showTipView:TipTypeSuccess withTitle:@"网络已连接"];
        }
        else
        {
            NSLog(@"%@",@"网络已断开");
            
            [self showTipView:TipTypeError withTitle:@"网络已断开"];
        }
    }
}

@end
