//
//  TemplateViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 15/10/15.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layout_tipLab_Height;

@end

@implementation TemplateViewController

#pragma makr - 视图控制器周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, self.scrollView.bounds.size.height);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - 触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // 结束界面所有编辑
    [self.view endEditing:YES];
    // 获得第一响应
    [self.view becomeFirstResponder];
    // 失去第一响应
    [self.view resignFirstResponder];
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
//    if(!cell)
//    {
//        //加载xib
//        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:nil options:nil];
//        for(id obj in nibs)
//        {
//            if([obj isKindOfClass:[ListViewCell class]])
//            {
//                cell = (ListViewCell *)obj;
//            }
//        }
//    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        return MAX(44.0f, 0);
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 自定义方法
- (void)changeDate
{
    // 自定义方法
}

#pragma mark - 网络响应
- (void)getUserInfoTask
{
    //  获取信息
}

- (void)setUserInfoTask
{
    //  提交信息
}

#pragma mark - 一般响应
- (void)buttonClick
{
    // 按钮响应
}

@end
