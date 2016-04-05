//
//  SearchDetailViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/23.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "SearchDetailViewController.h"

#import "SearchDetailHeaderCell.h"
#import "SearchDetailIntroCell.h"
#import "SearchDetailCastCell.h"

#import "CastInfo.h"

@interface SearchDetailViewController ()<iCarouselDataSource,iCarouselDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSMutableArray *castArray;
@property (nonatomic,strong) NSDictionary *detailDic;

@property (nonatomic,strong) iCarousel *carousel;

@end

@implementation SearchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageArray = [[NSArray alloc] init];
    self.castArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    [self getDetailInfoTask];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"SearchDetailHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchDetailIntroCell" bundle:nil] forCellReuseIdentifier:@"SearchDetailIntroCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchDetailCastCell" bundle:nil] forCellReuseIdentifier:@"SearchDetailCastCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:return 1;break;
        case 1:return (self.imageArray.count>0)?1:0;break;
        case 2:return 1;break;
        case 3:return self.castArray.count;break;
            
        default:break;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            SearchDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDetailHeaderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.detailDic[@"program"][@"metadata"][@"icon1"]]];
            cell.sorce.text = @([self.detailDic[@"program"][@"score"][@"score"] floatValue]).stringValue;
            cell.Star.value = [self.detailDic[@"program"][@"score"][@"score"] floatValue]/2.0;
            cell.type.text = [NSString stringWithFormat:@"类型：%@",[Tools pingjieStringFromArray:self.detailDic[@"program"][@"metadata"][@"tag"] string:@"|"]];
            cell.area.text = [NSString stringWithFormat:@"地区：%@",self.detailDic[@"program"][@"metadata"][@"area"]];
            cell.year.text = [NSString stringWithFormat:@"年代：%@",self.detailDic[@"program"][@"metadata"][@"year"]];
            cell.timeLong.text = [NSString stringWithFormat:@"片长：%@分钟",self.detailDic[@"program"][@"metadata"][@"duration"]];
            
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            if (!self.carousel)
            {
                self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                self.carousel.type = iCarouselTypeInvertedRotary;
                self.carousel.delegate = self;
                self.carousel.dataSource = self;
                [cell addSubview:self.carousel];
            }
            
            [self.carousel reloadData];
            return cell;
        }
            break;
        case 2:
        {
            SearchDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDetailIntroCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            CastInfo *info = self.castArray[indexPath.row];
            SearchDetailCastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDetailCastCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:info.image45]];
            cell.name.text = info.actor;
            
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:return 160;break;
        case 1:return 200;break;
        case 2:return 60;break;
        case 3:return 44;break;
            
        default:break;
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

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return self.imageArray.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 180)];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (view.bounds.size.width-10), (view.bounds.size.height-10))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArray[index] objectForKey:@"picUrl"]]];
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 1;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return nil;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return 1;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark - iCarousel taps
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %@", @(index));
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
     NSLog(@"Index: %@", carousel);
}

#pragma mark - 网络响应
- (void)getDetailInfoTask
{
    [self showIndicatorWithTitle:LOADING_INFO];

    [HttpManager get:[NSString stringWithFormat:@"http://vod.moretv.com.cn/Service/Program?sid=%@",self.item_sid]
                pars:nil success:^(NSMutableDictionary *sucRetDic) {
                    [self hideIndicatorView];
                    
                    self.detailDic = sucRetDic;
                    
                    NSDictionary *dic = sucRetDic[@"program"][@"metadata"];
                    self.imageArray = [dic objectForKey:@"Stills"];
                    
                    NSArray *castArr = [dic objectForKey:@"cast"];
                    [castArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CastInfo *info = [[CastInfo alloc] init];
                        info.actor = obj;
                        [self.castArray addObject:info];
                    }];
                    
                    
                    [self.castArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self getActorInfoTask:idx];
                    }];

                    [self.tableView reloadData];
                    
                } failure:^{
                    [self hideIndicatorView];
                }];
}

// 获取演员信息
- (void)getActorInfoTask:(NSInteger)index
{
    CastInfo *info = self.castArray[index];
    
    [HttpManager get:[NSString stringWithFormat:@"http://search.moretv.com.cn/name/%@/1",[info.actor stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                pars:nil success:^(NSMutableDictionary *sucRetDic) {
            
                    NSArray *array = [sucRetDic objectForKey:@"items"];
                    if (array.count > 0)
                    {
                        [self.castArray replaceObjectAtIndex:index withObject:[CastInfo yy_modelWithJSON:array[0]]];
                    }
                    
                    [self.tableView reloadData];
                    
                } failure:^{
                    
                }];
}

@end
