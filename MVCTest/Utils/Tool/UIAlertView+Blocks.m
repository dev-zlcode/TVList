//
//  UIAlertView+Blocks.m
//  Blocks
//
//  Created by 乐业天空 on 16/1/19.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "UIAlertView+Blocks.h"

static void (^__cancelBlock)(UIAlertView *alert);
static void (^__clickedBlock)(UIAlertView *alert, NSUInteger index);

@implementation UIAlertView (Blocks)

+ (UIAlertView *)presentWithTitle: (NSString *)title
                      WithMessage: (NSString *)message
                     cancelButton: (NSString *)cancelString
                     otherButtons: (NSArray *)otherStrings
                         onCancel: (void (^)(UIAlertView *alert))cancelBlock
                  onClickedButton: (void (^)(UIAlertView *alert, NSUInteger index))clickBlock
{
    if (![self Blocks_isEmpty:cancelString])
    {
        __cancelBlock = cancelBlock;
    }

    if (otherStrings.count > 0)
    {
        __clickedBlock = clickBlock;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(![self Blocks_isEmpty:title]?title:nil)
                                                    message:(![self Blocks_isEmpty:message]?message:nil)
                                                   delegate:(id) [self class]
                                          cancelButtonTitle:(![self Blocks_isEmpty:cancelString]?cancelString:nil)
                                          otherButtonTitles:nil];
    for(NSString *other in otherStrings)
    {
        [alert addButtonWithTitle: other];
    }
    [alert show];
    
    return alert;
}

#pragma mark - UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView cancelButtonIndex] == buttonIndex && __cancelBlock)
    {
        __cancelBlock(alertView);
    }
    else if(__clickedBlock)
    {
        if (__cancelBlock)
        {
            __clickedBlock(alertView, buttonIndex-1);
        }
        else
        {
            __clickedBlock(alertView, buttonIndex);
        }
    }
}

#pragma mark - 小工具
+ (BOOL)Blocks_isEmpty:(NSString *)string
{
    if ( (string == nil) || ([string isEqualToString:@""]) )
    {
        return YES;
    }
    
    return NO;
}

@end
