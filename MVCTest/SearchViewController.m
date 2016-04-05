//
//  SearchViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"
#import "SearchDetailViewController.h"

#import "SearchInfo.h"

#import "SearchDetailHeaderCell.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"搜索";
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initView];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"SearchDetailHeaderCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    // 搜索栏
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.frame = CGRectMake(0, 0, 320, 44);
    self.searchBar.placeholder = @"请输入电影、电视、动漫名字";
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if ([Tools isEmpty:searchBar.text])
    {
        [self showTipView:TipTypeError withTitle:@"搜索词不能为空"];
        return;
    }
    
    [self getNamelTask:searchBar.text];
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
    SearchInfo *info = self.dataArray[indexPath.row];
    
    SearchDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDetailHeaderCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:info.item_icon1]];
    cell.sorce.text = @([info.item_score floatValue]).stringValue;
    cell.Star.value = [info.item_score floatValue]/2.0;
    cell.type.text = [NSString stringWithFormat:@"类型：%@",[Tools pingjieStringFromArray:info.item_tag string:@"|"]];
    cell.area.text = [NSString stringWithFormat:@"地区：%@",info.item_area];
    cell.year.text = [NSString stringWithFormat:@"年代：%@年",@(info.item_year).stringValue];
    
    if (info.item_episodeCount.integerValue == 999999)
    {
         cell.timeLong.text = [NSString stringWithFormat:@"集数：1集"];
    }
    else
    {
        cell.timeLong.text = [NSString stringWithFormat:@"集数：%@集",@([info.item_episodeCount integerValue]).stringValue];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    
    SearchInfo *info = self.dataArray[indexPath.row];
    
    SearchDetailViewController *vc = [[SearchDetailViewController alloc] init];
    vc.title = info.item_title;
    vc.item_sid = info.item_sid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmpty delegete
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无结果";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - 网络响应
- (void)getNamelTask:(NSString *)keyword
{
    self.searchBar.text = keyword;
    
    [self showIndicatorWithTitle:@"搜索中..."];
    [HttpManager getAuth:[NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL,GET_SEAECH]
                    pars:@{@"keyword":[Tools encodeToPercentEscapeString:keyword],
                                                      @"pageIndex":@"1",
                                                      @"pageSize":@"100",
                           //                           @"contentType":@"tv"
                           }
                 success:^(NSMutableDictionary *sucRetDic) {
                     [self hideIndicatorView];
                     
                     [self.dataArray removeAllObjects];
                     NSArray *array = [sucRetDic objectForKey:@"items"];
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         [self.dataArray addObject:[SearchInfo yy_modelWithJSON:obj]];
                     }];
                     
                     [self.tableView reloadData];
                     
                 } failure:^{
                     [self hideIndicatorView];
                 }];
}

@end
