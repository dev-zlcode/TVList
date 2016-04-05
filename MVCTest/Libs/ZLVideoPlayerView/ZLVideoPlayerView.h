//
//  ZLVideoPlayerView.h
//  KKWVideoViewTest
//
//  Created by 张雷 on 16/1/26.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"

@protocol ZLVideoPlayerViewDelegate;
@interface ZLVideoPlayerView : UIView

@property (nonatomic,assign) id<ZLVideoPlayerViewDelegate> delegate;

@property (nonatomic,strong) VMediaPlayer *mMPayer;

@property (nonatomic,strong) UIActivityIndicatorView *activityView; // 指示器
@property (nonatomic,strong) UILabel *speedView;                    // 速度指示器

// 顶部
@property(nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *backButton;            // 返回
@property (nonatomic,strong) UILabel *titleLabel;             // 标题

// 底部
@property(nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *playButton;            // 播放
@property (nonatomic,strong) UILabel *currentSpeedLabel;      // 当前进度
@property (nonatomic,strong) UISlider *speedSlider;           // 精度
@property (nonatomic,strong) UILabel *maxSpeedLabel;          // 最大进度
@property (nonatomic,strong) UIButton *fullButton;            // 全屏

// 左部
@property(nonatomic,strong) UIView *leftView;

// 右部
@property(nonatomic,strong) UIView *rightView;

@property (nonatomic,assign) BOOL isShowTip;
@property (nonatomic,assign) BOOL isFull;

/*
 @para frame       播放器大小
 @para PlayUrl     播放的地址
 @para VideoTitle  标题
 @para view        播放器所在的视图
 */

- (id) initWithFrame:(CGRect)frame
         WithPlayUrl:(NSString *)PlayUrl
           withTitle:(NSString *)VideoTitle
                view:(UIView *)view;

// 播放
- (void)setDataSource:(NSURL *)mediaURL;

// 全屏
- (void) fullView:(BOOL)isFull animation:(BOOL)animation;

// 在不需要是一定要清楚播放器
- (void) clear;

@end

@protocol ZLVideoPlayerViewDelegate <NSObject>

// 返回按钮被点击是调用
- (void) zLVideoPlayerViewBack:(ZLVideoPlayerView *)videoPlayerView;

@end