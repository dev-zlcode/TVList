//
//  SettingViewController.m
//  MVCTest
//
//  Created by 张雷 on 15/10/29.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation SettingViewController

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
    
    self.title = @"设置";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.titleArray = @[@"关于电视节目单",@"给我们点个赞吧！"];
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = self.titleArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) // 关于健康食谱大全
    {
        AboutViewController *about = [[AboutViewController alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.section == 1) // 去评分
    {
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"暂时不支持评分功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}

@end
