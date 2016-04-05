//
//  AboutViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 15/11/9.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutViewController

#pragma makr - 视图控制器周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"电视节目单";
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"Setting.html" ofType:nil];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:pathStr]];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *string = [NSString stringWithFormat:@"setVersion(\"版本号:%@\")",[Tools getVersion]];
    [self.webView stringByEvaluatingJavaScriptFromString:string];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isEqualToString:@"www.myjobsky.com"])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        
        return NO;
    }
    
    return YES;
}

@end
