//
//  MethodDetailViewController.m
//  MVCTest
//
//  Created by 张雷 on 16/1/6.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "MethodDetailViewController.h"

@interface MethodDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;
@property (weak, nonatomic) IBOutlet UIButton *menuDayButton;

@end

@implementation MethodDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if (self.type == 0)
    {
        [self.webView loadHTMLString:self.string baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }
    else
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.string]];
        [self.webView loadRequest:request];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - 一般响应
// 上一页
- (IBAction)previousDayBtn:(id)sender
{

}

// 下一页
- (IBAction)nextDayBtn:(id)sender
{

}

// 时间菜单
- (IBAction)menuDayBtn:(id)sender
{

}


@end
