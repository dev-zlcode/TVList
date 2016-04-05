//
//  ProvinceViewController.m
//  MVCTest
//
//  Created by 张雷 on 16/1/11.
//  Copyright © 2016年 zhanlgei. All rights reserved.
//

#import "ProvinceViewController.h"

#import "ProvincePDListlCell.h"
#import "ProvincePDListlInfo.h"

@interface ProvinceViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ProvinceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
  
    [self initView];
    
    [self getDetailTask:[Tools handleNull:self.proId]];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ProvincePDListlCell" bundle:nil] forCellReuseIdentifier:@"ProvincePDListlCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProvincePDListlInfo *info = self.dataArray[indexPath.row];
    
    ProvincePDListlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvincePDListlCell"];
    cell.titleLabel.text = info.channelName;
    
    if ([Tools isEmpty:info.t])
    {
        cell.desLabel.attributedText = [Tools setMulColor:[UIColor lightGrayColor] norColor:Color string:@"暂无节目" index:0 count:0];
    }
    else
    {
        cell.desLabel.attributedText = [Tools setMulColor:[UIColor redColor] norColor:Color string:[NSString stringWithFormat:@"正在播放：%@",info.t] index:0 count:5];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

#pragma mark - DZNEmpty delegete
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击重新加载";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self getDetailTask:[Tools handleNull:self.proId]];
}

#pragma mark - 网络响应
- (void)getDetailTask:(NSString *)string
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.tvmao.com/program/playing/%@",string];
    [HttpManager postHtml:urlStr
                     pars:nil
                  success:^(NSString *sucRetStr) {
                      [self hideIndicatorView];
                      
                      NSError *error = nil;
                      HTMLParser *parser = [[HTMLParser alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"<meta http-equiv=\"Content-Type\" charset=utf-8\" />",sucRetStr] error:&error];
                      
                      if (error)
                      {
                          NSLog(@"Error: %@", error);
                          return;
                      }
                      
                      HTMLNode *bodyNode = [parser body];
                      
                      // 获取标签内容
                      NSArray *spanNodes = [bodyNode findChildTags:@"tr"];
                      
                      for (HTMLNode *spanNode in spanNodes)
                      {
                          if ([[spanNode className] isEqualToString:@""] || [[spanNode className] isEqualToString:@"trd"])
                          {
                              NSDictionary *dic = [NSDictionary dictionaryWithXMLString:[spanNode rawContents]];
                              ProvincePDListlInfo *info = [[ProvincePDListlInfo alloc] initProvincePDListlInfo:dic];
                              [self.dataArray addObject:info];
                          }
                      }
                      
                      [self.tableView reloadData];
                      
                  } failure:^{
                      [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
                      [self hideIndicatorView];
                  }];
}


@end
