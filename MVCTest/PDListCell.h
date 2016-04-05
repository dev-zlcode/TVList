//
//  PDListCell.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/8.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end
