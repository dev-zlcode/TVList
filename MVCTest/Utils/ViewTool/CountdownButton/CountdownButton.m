//
//  CountdownButton.m
//  Test
//
//  Created by 乐业天空 on 15/11/21.
//  Copyright © 2015年 myjobsky. All rights reserved.
//

#import "CountdownButton.h"

@interface CountdownButton()
{
    NSTimer *_timer;
    NSInteger num;
}

@property (nonatomic,strong) NSString *firstTitle;
@property (nonatomic,strong) NSString *secondTitle;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,strong) UIColor *bgColor;

@end
@implementation CountdownButton

- (id)initWithFrame:(CGRect)frame firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle time:(NSInteger)time
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.firstTitle = firstTitle;
        self.secondTitle = secondTitle;
        self.time = time;
        
        [self setTitle:self.firstTitle forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - 选中按钮
- (void)selectButton
{
    self.enabled = NO;
    num = self.time;
    self.bgColor = self.backgroundColor;
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [self setTitle:[NSString stringWithFormat:@"%@%@",@(self.time),self.secondTitle] forState:UIControlStateNormal];
    
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 定时器
-(void)timer:(NSTimer *)sender
{
    if (num > 0)
    {
        [self setTitle:[NSString stringWithFormat:@"%@%@",@(--num),self.secondTitle] forState:UIControlStateNormal];
    }
    else
    {
        self.enabled = YES;
        [self setBackgroundColor:self.bgColor];
        [self setTitle:self.firstTitle forState:UIControlStateNormal];
        [_timer invalidate];
    }
}

@end
