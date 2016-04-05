//
//  DetailViewController.m
//  MVCTest
//
//  Created by 张雷 on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "DetailViewController.h"
#import "PlayerViewController.h"

#import "PDDetailCell.h"

#import "PDDetailInfo.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,RMDateSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;
@property (weak, nonatomic) IBOutlet UIButton *menuDayButton;

// 当前选中的日期
@property (nonatomic,strong) NSDate *selectedDate;

@end

@implementation DetailViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDetailTask:self.selectedDate isShow:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
   
    [self initView];
    self.selectedDate = [NSDate date];
    [self getDetailTask:self.selectedDate isShow:YES];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PDDetailCell" bundle:nil] forCellReuseIdentifier:@"PDDetailCell"];
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
    PDDetailInfo *info = self.dataArray[indexPath.row];
    
    PDDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDDetailCell"];
    cell.textLabel.text = info.t;
    // 直播
    if (info.isLiving == 0)
    {
        cell.detailTextLabel.text = @"播放中";
    }
    // 回播
    else if (info.isLiving == 1)
    {
        cell.detailTextLabel.text = @"回播";
    }
    else
    {
        cell.detailTextLabel.text = @"";
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
    
    // 审核通过之后可以使用
//    if ([[LocalStorageUtil getInfo:IS_LINING] integerValue] != 1)
//    {
//        return;
//    }
    
    // wifi 提醒
    if (![NetWorkManager isWifi])
    {
        [UIAlertView presentWithTitle:@"温馨提示"
                          WithMessage:@"当前网络非WIFI环境，是否继续播放"
                         cancelButton:@"取消"
                         otherButtons:@[@"继续播放"]
                             onCancel:^(UIAlertView *alert) {
                                 
                             } onClickedButton:^(UIAlertView *alert, NSUInteger index) {
                                 [self gotoPlay:indexPath];
                             }];
    }
    else
    {
        [self gotoPlay:indexPath];
    }
}

#pragma mark - DZNEmpty delegete
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无节目安排";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate
{
    NSLog(@"确定：%@",aDate);
    
    [self getDetailTask:aDate isShow:YES];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc
{
    NSLog(@"取消");
}

- (void)dateSelectionViewControllerNowButtonPressed:(RMDateSelectionViewController *)vc;
{
    NSLog(@"头按钮");
    
    [vc dismiss];
    
    [self getDetailTask:[NSDate date] isShow:YES];
}

#pragma mark - 自定义方法
- (void) gotoPlay:(NSIndexPath *)indexPath
{
    PDDetailInfo *info = self.dataArray[indexPath.row];
    
    PlayerViewController *vc = [[PlayerViewController alloc] init];
    vc.channel = self.channel;
    vc.starttime = info.st;
    vc.endtime = info.et;
    
    // 直播
    if (info.isLiving == 0)
    {
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 回播
    else if (info.isLiving == 1)
    {
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self showTipView:TipTypeInfo withTitle:@"还未开播"];
    }
}

#pragma mark - 一般响应
// 上一页
- (IBAction)previousDayBtn:(id)sender
{
    [self getDetailTask:[self.selectedDate dateBySubtractingDays:1] isShow:YES];
}

// 下一页
- (IBAction)nextDayBtn:(id)sender
{
    [self getDetailTask:[self.selectedDate dateByAddingDays:1] isShow:YES];
}

// 时间菜单
- (IBAction)menuDayBtn:(id)sender
{
    // RMDateSelectionViewController
    [RMDateSelectionViewController setLocalizedTitleForNowButton:@"今天"];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.hideNowButton = NO;
    [dateSelectionVC show];
    
    // 设置显示格式
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.date = [NSDate date];
}

#pragma mark - 网络响应
// 获取某天的节目列表
- (void)getDetailTask:(NSDate *)date isShow:(BOOL)show
{
    self.selectedDate = date;
    NSString *string = nil;
    switch ([self.selectedDate weekday])
    {
        case 1:string = @"周日"; break;
        case 2:string = @"周一"; break;
        case 3:string = @"周二"; break;
        case 4:string = @"周三"; break;
        case 5:string = @"周四"; break;
        case 6:string = @"周五"; break;
        case 7:string = @"周六"; break;
            
        default:
            break;
    }
    [self.menuDayButton setTitle:[NSString stringWithFormat:@"%@(%@)",[Tools dateToBJTime:date withFormatter:@"yyyy-MM-dd"],string] forState:UIControlStateNormal];
    if (show)
    {
        [self showIndicatorWithTitle:LOADING_INFO];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.cntv.cn/epg/epginfo?serviceId=cbox&c=%@&d=%@",self.channel,[Tools dateToBJTime:date withFormatter:@"yyyyMMdd"]];
    [HttpManager get:urlStr pars:nil success:^(NSMutableDictionary *sucRetDic) {
         [self hideIndicatorView];
        
        NSArray *array = [sucRetDic[self.channel] objectForKey:@"program"];
        [self.dataArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataArray addObject:[PDDetailInfo yy_modelWithDictionary:obj]];
        }];
        [self.tableView reloadData];
        
    } failure:^{
        [self hideIndicatorView];
    }];
}

@end
