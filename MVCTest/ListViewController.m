//
//  ListViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

#import "PDListCell.h"

#import "PDListInfo.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 重置已加载全部
    
        [self getListTask:self.type];
        
        NSLog(@"下拉刷新");
    }];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PDListCell" bundle:nil] forCellReuseIdentifier:@"PDListCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    
    [self getListTask:type];
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
    PDListInfo *info = self.dataArray[indexPath.row];
    
    PDListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDListCell"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://t.live.cntv.cn/imagehd/%@_01.png",info.channelId]]];
    cell.titleLabel.text =  info.title;
    
    if ([Tools isEmpty:info.t])
    {
        cell.desLabel.attributedText = [Tools setMulColor:[UIColor lightGrayColor] norColor:Color string:@"暂无节目" index:0 count:0];
    }
    else
    {
        cell.desLabel.attributedText = [Tools setMulColor:[UIColor redColor] norColor:Color string:[NSString stringWithFormat:@"正在播放：%@",info.t] index:0 count:5];
    }
   
    if (!info.flag)
    {
        [self getNowEpgTask:indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    PDListInfo *info = self.dataArray[indexPath.row];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.title = info.title;
    vc.channel = info.channelId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    [self getListTask:self.type];
}

#pragma mark - 网络响应
- (void)getListTask:(NSInteger)index
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = @"";
    if (index == 0)
    {
        urlStr = [NSString stringWithFormat:@"%@",GET_YS_URL];
    }
    else if (index == 1)
    {
        urlStr = [NSString stringWithFormat:@"%@",GET_WS_URL];
    }
    else if (index == 2)
    {
        urlStr = [NSString stringWithFormat:@"%@",GET_DF_URL];
    }
    
    [HttpManager post:urlStr
                 pars:nil
              success:^(NSMutableDictionary *sucRetDic) {
                  
                  [self hideIndicatorView];
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      // 结束动画
                      [self.tableView.mj_header endRefreshing];
                  });
                  
                  [self.dataArray removeAllObjects];
                  NSArray *array = [[sucRetDic objectForKey:@"data"] objectForKey:@"items"];
                  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      [self.dataArray addObject:[PDListInfo yy_modelWithJSON:obj]];
                  }];
                  [self.tableView reloadData];
              } failure:^{
                  [self hideIndicatorView];
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      // 结束动画
                      [self.tableView.mj_header endRefreshing];
                  });
              }];
}

- (void)getNowEpgTask:(NSInteger)index
{
    PDListInfo *info = self.dataArray[index];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.cntv.cn/epg/nowepg?serviceId=cbox&c=%@",info.channelId];
    
    [HttpManager post:urlStr
                 pars:nil
              success:^(NSMutableDictionary *sucRetDic) {
                  
                  info.flag = YES;
                  info.t = [sucRetDic objectForKey:@"t"];
                  [self.tableView reloadData];
                  
              } failure:^{
                  
              }];
}

@end
