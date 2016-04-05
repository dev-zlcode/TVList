//
//  HomeViewController.m
//  MVCTest
//
//  Created by 张雷 on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectFliterView.h"
#import "SelectFliterConfigure.h"
#import "ListViewController.h"
#import "MenuViewController.h"
#import "ProvinceViewController.h"

@interface HomeViewController ()<SelectFliterViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) SelectFliterView *selectFliterView;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*4, self.scrollView.bounds.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"首页";

    [self initView];
    
    [self getAppleVersion];
}

- (void)initView
{
    // 选择器
    SelectFliterConfigure *config = [[SelectFliterConfigure alloc] init];
    config.titleColor = Color;
    config.titleColorDefault = [UIColor blackColor];
    config.titleFont = [UIFont systemFontOfSize:14];
    config.lineColor = Color;
    config.lineHeight = 2;
    
    self.selectFliterView = [[SelectFliterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) withTitleArr:@[@"央视",@"卫视",@"其他",@"省市"] withConfig:config];
    self.selectFliterView.delegate = self;
    self.selectFliterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectFliterView];
    
    // 央视
    ListViewController *vc1 = [[ListViewController alloc] init];
    vc1.view.frame = CGRectMake(0, 0, ScreenWidth, self.scrollView.bounds.size.height);
    [self addChildViewController:vc1];
    vc1.type = 0;
    [self.scrollView addSubview:vc1.view];
    
    // 卫视
    ListViewController *vc2 = [[ListViewController alloc] init];
    vc2.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.bounds.size.height);
    [self addChildViewController:vc2];
    vc2.type = 1;
    [self.scrollView addSubview:vc2.view];
    
    // 其他
    ListViewController *vc3 = [[ListViewController alloc] init];
    vc3.view.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, self.scrollView.bounds.size.height);
    [self addChildViewController:vc3];
    vc3.type = 2;
    [self.scrollView addSubview:vc3.view];
    
    // 省市
    MenuViewController *vc4 = [[MenuViewController alloc] init];
    vc4.view.frame = CGRectMake(ScreenWidth*3, 0, ScreenWidth, self.scrollView.bounds.size.height);
    [self addChildViewController:vc4];
    [self.scrollView addSubview:vc4.view];
    
    // 滑动到指定界面
    [self selectViewController:self.type];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //让视图切换的时候，按钮切换
    CGPoint point = scrollView.contentOffset;
    NSInteger currentPage = point.x/ScreenWidth;
    
    [self selectViewController:currentPage];
}

#pragma mark - SelectFliterViewDelegate
-(void)selectFliterView:(SelectFliterView *)selectFliterView withValue:(NSInteger)value
{
    [self selectViewController:value];
}

#pragma mark - 一般响应
// 滑动到指定界面
- (void)selectViewController:(NSInteger)index
{
    self.selectFliterView.selectIndex = index;
    
    switch (index)
    {
        case 0:// 央视
        {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
            break;
        case 1:// 卫视
        {
            self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        }
            break;
        case 2:// 其他
        {
            self.scrollView.contentOffset = CGPointMake(ScreenWidth*2, 0);
        }
            break;
        case 3:// 省市
        {
            self.scrollView.contentOffset = CGPointMake(ScreenWidth*3, 0);
        }
            break;
            
        default:
            break;
    }
}

-(void)getAppleVersion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APP_ID];
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        NSString *string = [NSString stringWithString:operation.responseString];
        
        NSLog(@"%@",string);
        
        NSLog(@"线上版本信息：%@",string);
        if ((string!=nil)&&([string length]>0))
        {
            //获取当前版本
            NSDictionary *localDic = [[NSBundle mainBundle] infoDictionary];
            //CFBundleShortVersionString     version号
            //CFBundleVersion                build号
            NSString *localVersion = [localDic objectForKey:@"CFBundleShortVersionString"];
            
            //获取线上版本号
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = [dic objectForKey:@"results"];
            NSString *version = @"";
            if (array.count)
            {
                NSDictionary *dict = array[0];
                version = [dict objectForKey:@"version"];
            }
            
            NSLog(@"系统:%@---线上:%@",localVersion,version);
            
            if ([Tools compareVersion:version second:localVersion] >= 0)
            {
                [LocalStorageUtil setInfo:@"1" forKey:IS_LINING];
            }
            else
            {
                [LocalStorageUtil setInfo:@"" forKey:IS_LINING];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
