//
//  UIActionSheet+Blocks.m
//  Blocks
//
//  Created by 张雷 on 16/1/19.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "UIActionSheet+Blocks.h"

static void (^__cancelBlock)(UIActionSheet *sheet);
static void (^__destroyBlock)(UIActionSheet *sheet);
static void (^__clickedBlock)(UIActionSheet *sheet, NSUInteger index);

@implementation UIActionSheet (Blocks)

+ (UIActionSheet *)presentOnView:(UIView *)view
                       withTitle:(NSString *)title
                    cancelButton:(NSString *)cancelString
                    otherButtons:(NSArray *)otherStrings
                        onCancel:(void (^)(UIActionSheet *sheet))cancelBlock
                 onClickedButton:(void (^)(UIActionSheet *sheet, NSUInteger index))clickBlock
{
    return [self presentOnView:view
                     withTitle:title
                  cancelButton:cancelString
             destructiveButton:nil
                  otherButtons:otherStrings
                      onCancel:cancelBlock
                 onDestructive:nil
               onClickedButton:clickBlock];
}

+ (UIActionSheet *)presentOnView: (UIView *)view
                       withTitle: (NSString *)title
                    cancelButton: (NSString *)cancelString
               destructiveButton: (NSString *)destructiveString
                    otherButtons: (NSArray *)otherStrings
                        onCancel: (void (^)(UIActionSheet *sheet))cancelBlock
                   onDestructive: (void (^)(UIActionSheet *sheet))destroyBlock
                 onClickedButton: (void (^)(UIActionSheet *sheet, NSUInteger index))clickBlock
{
    if (![self Blocks_isEmpty:cancelString])
    {
        __cancelBlock = cancelBlock;
    }
    
    if (otherStrings.count > 0)
    {
        __clickedBlock = clickBlock;
    }
    
    if (![self Blocks_isEmpty:destructiveString])
    {
        __destroyBlock = destroyBlock;
    }

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:(![self Blocks_isEmpty:title]?title:nil)
                                                       delegate:(id) [self class]
                                              cancelButtonTitle:(![self Blocks_isEmpty:cancelString])?cancelString:nil
                                         destructiveButtonTitle:(![self Blocks_isEmpty:destructiveString])?destructiveString:nil
                                              otherButtonTitles:nil];
    
    for(NSString *other in otherStrings)
    {
        [sheet addButtonWithTitle: other];
    }
    
    [sheet showInView: view];
 	 	
    return sheet;
}

#pragma mark - Private Static delegate
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet destructiveButtonIndex] == buttonIndex && __destroyBlock)
    {
        __destroyBlock(actionSheet);
    }
    else if([actionSheet cancelButtonIndex] == buttonIndex && __cancelBlock)
    {
        __cancelBlock(actionSheet);
    }
    else if(__clickedBlock)
    {
        if (__cancelBlock && __destroyBlock)
        {
            __clickedBlock(actionSheet, buttonIndex-2);
        }
        else if (__cancelBlock)
        {
            __clickedBlock(actionSheet, buttonIndex-1);
        }
        else if (__destroyBlock)
        {
            __clickedBlock(actionSheet, buttonIndex-1);
        }
        else
        {
            __clickedBlock(actionSheet, buttonIndex);
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
