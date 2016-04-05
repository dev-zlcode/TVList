//
//  MenuViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "MenuViewController.h"
#import "ProvinceViewController.h"
#import "MenuInfo.h"
#import "MenuCell.h"
#import "SettingViewController.h"

@interface MenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    [self getMenuTask];
}

- (void)initView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellWithReuseIdentifier:@"MenuCell"];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}

# pragma mark - UICollectionViewDataSource
//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuInfo *info = self.dataArray[indexPath.row];
  
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 3;
    cell.nameLabel.text = info.name;
    
    NSArray *colorPool = @[@(0x7ecef4), @(0x84ccc9), @(0x88abda),@(0x7dc1dd),@(0xb6b8de)];
    cell.contentView.backgroundColor = RGBHEX([colorPool[arc4random() % colorPool.count] integerValue]);
    
    return cell;
}

//点击元素触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuInfo *info = self.dataArray[indexPath.row];
    
    ProvinceViewController *vc = [[ProvinceViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = info.name;
    vc.proId = info.proId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//设置每块大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //可以通过UICollectionViewFlowLayout属性设置itemSize
    return CGSizeMake((ScreenWidth-20)/3.0, (ScreenWidth-20)/3.0*0.5);
}

//设置边界间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //可以通过UICollectionViewFlowLayout属性设置sectionInset
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//设置表头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
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
    [self getMenuTask];
}

#pragma mark - 网络响应
- (void)getMenuTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.tvmao.com/program/playing/340000"];
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
                      NSArray *spanNodes = [bodyNode findChildTags:@"form"];
                      
                      for (HTMLNode *spanNode in spanNodes)
                      {
                          if ([[spanNode getAttributeNamed:@"name"] isEqualToString:@"locchg"])
                          {
                              // 获取标签内容
                              NSArray *liNode = [spanNode findChildTags:@"a"];
                              [liNode enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  NSDictionary *liDic = [NSDictionary dictionaryWithXMLString:[obj rawContents]];
                                  
                                  MenuInfo *info = [[MenuInfo alloc] initMenuInfo:liDic];
                                  
                                  if ([info.proId integerValue] > 0)
                                  {
                                      [self.dataArray addObject:info];
                                  }
                              }];
                          }
                      }
                      
                      [self.collectionView reloadData];
                      
                  } failure:^{
                      [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
                      [self hideIndicatorView];
                  }];
}

@end
