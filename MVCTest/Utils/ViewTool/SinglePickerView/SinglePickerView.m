//
//  SinglePickerView.m
//  fasfasf
//
//  Created by 乐业天空 on 15/11/7.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "SinglePickerView.h"

@interface SinglePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) NSArray *titleArray;

@end

@implementation SinglePickerView

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleArray = array;
        
        // 建立 UIToolbar
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
        toolBar.barTintColor = [UIColor whiteColor];
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-60-10, 7, 60, 30);
        enterBtn.clipsToBounds = YES;
        enterBtn.layer.cornerRadius = 3;
        enterBtn.backgroundColor = [UIColor colorWithRed:63.0/255 green:153.0/255 blue:203.0/255 alpha:1.0];
        enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [enterBtn setTitle:@"确定" forState:UIControlStateNormal];
        [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(cancelPicker:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:enterBtn];
        [self addSubview:toolBar];
        
        // UIPickerView
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, frame.size.height-44)];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.pickerView];
        [self.pickerView selectRow:array.count/2 inComponent:0 animated:YES];
    }
    return self;
}

- (void)showPickerView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!self.superview)
    {
        [window addSubview:self];
    }
    
    self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height , self.bounds.size.width, self.bounds.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height , self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (self.superview)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.titleArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.titleArray[row];
}

// 按下完成按钮的 method
-(void) cancelPicker:(UIButton *)sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    
    if ([self.delegate respondsToSelector:@selector(singlePicker:index:value:)])
    {
        [self.delegate singlePicker:self index:row value:self.titleArray[row]];
    }
    
    [self hidePickerView];
}

@end
