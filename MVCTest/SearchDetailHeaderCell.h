//
//  SearchDetailHeaderCell.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/23.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface SearchDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *sorce;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *Star;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *timeLong;

@end
