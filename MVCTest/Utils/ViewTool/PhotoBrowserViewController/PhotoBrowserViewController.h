//
//  PhotoBrowserViewController.h
//  fasfasf
//
//  Created by 乐业天空 on 15/11/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController

/*
 
 用例
 PhotoBrowserViewController *photo = [[PhotoBrowserViewController alloc] init];
 photo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 photo.imageUrlArray = @[@"http://f.hiphotos.baidu.com/image/pic/item/ac4bd11373f08202f7fce43e49fbfbedab641b40.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/bd315c6034a85edff028d53d4b540923dd547503.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/a2cc7cd98d1001e9efbd8211ba0e7bec54e7972f.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/023b5bb5c9ea15cec9328200b4003af33b87b2df.jpg"];
 photo.currentNum = 2;
 [self presentViewController:photo animated:YES completion:nil];
 
 */

// 图片url数组
@property(nonatomic,strong) NSArray *imageUrlArray;
// 图片标题数组
@property(nonatomic,strong) NSArray *titleArray;
// 当前图片
@property(nonatomic,assign) NSInteger currentNum;

@end
