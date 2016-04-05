//
//  CountdownButton.h
//  Test
//
//  Created by 乐业天空 on 15/11/21.
//  Copyright © 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

/*  
 使用方法
 
 - (void)viewDidLoad
 {
 CountdownButton *button = [[CountdownButton alloc] initWithFrame:CGRectMake(100, 300, 120, 40) firstTitle:@"获取验证码" secondTitle:@"秒后重新获取" time:60];
 button.backgroundColor = [UIColor redColor];
 button.titleLabel.font = [UIFont systemFontOfSize:14];
 button.clipsToBounds = YES;
 button.layer.cornerRadius = 3;
 [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:button];
 }
 
 - (void)button:(CountdownButton *)sender
 {
 // 选中按钮 必须
 [sender selectButton];
 }
 
 */

@interface CountdownButton : UIButton

- (id)initWithFrame:(CGRect)frame firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle time:(NSInteger)time;

- (void)selectButton;

@end
