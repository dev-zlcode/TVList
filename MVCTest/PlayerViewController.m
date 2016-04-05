//
//  PlayerViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/22.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "PlayerViewController.h"
#import "LDZMoviePlayerController.h"
#import "ZLVideoPlayerView.h"
@interface PlayerViewController ()<ZLVideoPlayerViewDelegate>

@property (nonatomic,strong) ZLVideoPlayerView *videoPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger seleteRow;

@end

@implementation PlayerViewController

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.videoPlayer clear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.channel;
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.videoPlayer = [[ZLVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 250) WithPlayUrl:@"" withTitle:self.channel view:self.view];
    self.videoPlayer.delegate = self;
    self.videoPlayer.backButton.hidden = YES;
    [self.view addSubview:self.videoPlayer];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 直播
    if (self.type == 0)
    {
        [self getLiveTask];
    }
    // 回放
    else
    {
        [self getBackLiveTask];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.type == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"直播源%@",@(indexPath.row)];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"回播片段%@",@(indexPath.row)];
    }
    
    if (indexPath.row == self.seleteRow)
    {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    
    self.seleteRow = indexPath.row;
    [self.videoPlayer setDataSource:[NSURL URLWithString:self.dataArray[indexPath.row]]];
    
    [tableView reloadData];
}

#pragma mark - ZLVideoPlayerViewDelegate
- (void) zLVideoPlayerViewBack:(ZLVideoPlayerView *)videoPlayerView
{
    if (!videoPlayerView.isFull)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 一般响应

#pragma mark - 网络响应
// 获取直播列表
- (void)getLiveTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"http://vdn.live.cntv.cn/api2/live.do?channel=pa://cctv_p2p_hd%@&client=iosapp",self.channel];
    
    [HttpManager get:urlStr pars:nil success:^(NSMutableDictionary *sucRetDic) {
        [self hideIndicatorView];
        
        NSArray *array = [[sucRetDic objectForKey:@"hls_url"] allValues];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![Tools isEmpty:obj])
            {
                [self.dataArray addObject:obj];
            }
        }];
        
        if (self.dataArray.count > 0)
        {
            [self.videoPlayer setDataSource:[NSURL URLWithString:self.dataArray[0]]];
            self.seleteRow = 0;
        }
        
        [self.tableView reloadData];
        NSLog(@"%@",array);
        
    } failure:^{
        [self hideIndicatorView];
    }];
}

// 获取回放列表
- (void)getBackLiveTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"http://vdn.apps.cntv.cn/api/liveback.do?channel=%@&starttime=%@&endtime=%@&from=web&url=http://tv.cntv.cn/live/%@/",self.channel,[Tools timedsampToDate:@(self.starttime).stringValue withFormatter:@"yyyyMMddHHmm"],[Tools timedsampToDate:@(self.endtime).stringValue withFormatter:@"yyyyMMddHHmm"],self.channel];
    
    [HttpManager get:urlStr pars:nil success:^(NSMutableDictionary *sucRetDic) {
        [self hideIndicatorView];
        
        NSArray *array = [[sucRetDic objectForKey:@"video"] objectForKey:@"chapters"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![Tools isEmpty:[obj objectForKey:@"url"]])
            {
                [self.dataArray addObject:[obj objectForKey:@"url"]];
            }
        }];
        
        if (self.dataArray.count > 0)
        {
            [self.videoPlayer setDataSource:[NSURL URLWithString:self.dataArray[0]]];
            self.seleteRow = 0;
        }
        
        [self.tableView reloadData];
        NSLog(@"%@",self.dataArray);
        
    } failure:^{
        [self hideIndicatorView];
    }];
}

@end
