//
//  ZLVideoPlayerView.m
//  KKWVideoViewTest
//
//  Created by 张雷 on 16/1/26.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "ZLVideoPlayerView.h"

#define TopViewHeight       44    // 顶部视图宽
#define BottomViewHeight    44    // 底部视图宽
#define LeftViewHeight      44    // 左部视图宽
#define RightViewHeight     44    // 右部视图宽

#define Duration            0.5   // 动画时间

#define Width               ((!self.isFull)?self.frame.size.width:self.frame.size.height)
#define Height              ((!self.isFull)?self.frame.size.height:self.frame.size.width)

@interface ZLVideoPlayerView ()<VMediaPlayerDelegate>
{
    NSTimer *_speedTimer;   // 播放进度定时器
}
@property (nonatomic,assign) CGRect initRect;       // 初始化时的尺寸
@property (nonatomic,weak) UIView *initSuperView;   // 初始化时父视图
@property (nonatomic,strong) NSString *titleString; // 标题
@property (nonatomic,strong) NSString *urlString;   // 链接
@property (nonatomic,assign) BOOL isBuffing;        // 缓冲中
@property (nonatomic,assign) BOOL isLoading;        // 准备中(还没有开始播放的阶段)
@end
@implementation ZLVideoPlayerView

- (id) initWithFrame:(CGRect)frame WithPlayUrl:(NSString *)PlayUrl withTitle:(NSString *)VideoTitle view:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        self.initRect = frame;
        self.initSuperView = view;
        self.titleString = VideoTitle;
        self.urlString = PlayUrl;
        
        // 点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
        [self initView];
        [self showTip:YES animation:YES];
        
        // 播放器
        self.mMPayer = [VMediaPlayer sharedInstance];
        [self.mMPayer setupPlayerWithCarrierView:self withDelegate:self];
        [self.mMPayer setVideoFillMode:VMVideoFillModeFit];
        
        if ((![PlayUrl isEqualToString:@""]) && (PlayUrl != nil))
        {
            [self setDataSource:[NSURL URLWithString:self.urlString]];
        }
        
        // 注册通知
        [self setupObservers];
    }
    return self;
}

// 播放
- (void)setDataSource:(NSURL *)mediaURL
{
    [self.mMPayer reset];
    [self.mMPayer setDataSource:mediaURL];
    [self.mMPayer prepareAsync];
    [self showActivityView:@"加载中..."];
    self.isLoading = YES;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
     NSLog(@"%s",__FUNCTION__);
    
    [self initView];
}

- (void) clear
{
    [_speedTimer invalidate];
    _speedTimer = nil;
    NSLog(@"%s",__FUNCTION__);
}

- (void) dealloc
{
    // 一定要充值否则出错
    [self.mMPayer reset];
    [self.mMPayer unSetupPlayer];
    
    NSLog(@"%s",__FUNCTION__);
}

- (void) initView
{
    // 顶部
    [self initTopView];
    // 底部
    [self initBottomView];
    // 左部
    // [self initLeftView];
    // 右部
    // [self rightView];
    
    // 指示器
    if (!self.activityView)
    {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                             UIActivityIndicatorViewStyleWhite];
        self.activityView.hidden = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 80, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.activityView addSubview:label];
    }
    self.activityView.frame = CGRectMake((Width-80)/2.0, (Height-65)/2.0, 80, 65);
    [self addSubview:self.activityView];
    
    // 速度指示器
    if (!self.speedView)
    {
        self.speedView = [[UILabel alloc] init];
        self.speedView.textAlignment = NSTextAlignmentCenter;
        self.speedView.font = [UIFont systemFontOfSize:12];
        self.speedView.textColor = [UIColor whiteColor];
    }
    self.speedView.frame = CGRectMake(Width-100, TopViewHeight, 100, 20);
    [self addSubview:self.speedView];
}

- (void)initTopView
{
    // 顶部
    if (!self.topView)
    {
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.5];
        self.topView.frame = CGRectMake(0, -TopViewHeight, Width, TopViewHeight);
    }
    [self addSubview:self.topView];
    
    // 返回
    if (!self.backButton)
    {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setImage:[UIImage imageNamed:@"wsmv_leftarrow.png"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.backButton.frame = CGRectMake(0, 0, TopViewHeight, TopViewHeight);
    [self.topView addSubview:self.backButton];
   
    // 标题
    // 最大进度
    if (!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = self.titleString;
    }
    self.titleLabel.frame = CGRectMake(TopViewHeight, 0, Width-TopViewHeight, TopViewHeight);
    [self.topView addSubview:self.titleLabel];
}

- (void)initBottomView
{
    // 底部
    if (!self.bottomView)
    {
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.5];
        self.bottomView.frame = CGRectMake(0, Height, Width, BottomViewHeight);
    }
    [self addSubview:self.bottomView];
    
    // 播放
    if (!self.playButton)
    {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setImage:[UIImage imageNamed:@"wsmv_play_btn.png"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"wsmv_pause_btn.png"] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.playButton.frame = CGRectMake(0, 0, BottomViewHeight, BottomViewHeight);
    [self.bottomView addSubview:self.playButton];
    
    // 当前进度
    if (!self.currentSpeedLabel)
    {
        self.currentSpeedLabel = [[UILabel alloc] init];
        self.currentSpeedLabel.text = @"00:00:00";
        self.currentSpeedLabel.textColor = [UIColor whiteColor];
        self.currentSpeedLabel.font = [UIFont systemFontOfSize:9];
        self.currentSpeedLabel.textAlignment = NSTextAlignmentRight;
    }
    self.currentSpeedLabel.frame = CGRectMake(BottomViewHeight, 0, BottomViewHeight, BottomViewHeight);
    [self.bottomView addSubview:self.currentSpeedLabel];
    
    // 进度
    if (!self.speedSlider)
    {
        self.speedSlider = [[UISlider alloc] init];
        self.speedSlider.minimumValue = 0;
        self.speedSlider.maximumValue = 1.0;
        self.speedSlider.minimumTrackTintColor = [UIColor greenColor];
        self.speedSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        [self.speedSlider setThumbImage:[UIImage imageNamed:@"wsmv_slider_thumb.png"] forState:UIControlStateNormal];
        [self.speedSlider addTarget:self action:@selector(speedSliderBegin:) forControlEvents:UIControlEventTouchDown];
        [self.speedSlider addTarget:self action:@selector(speedSliderChange:) forControlEvents:UIControlEventValueChanged];
        [self.speedSlider addTarget:self action:@selector(speedSliderCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.speedSlider.frame = CGRectMake(BottomViewHeight*2, 0, Width-BottomViewHeight*4, BottomViewHeight);
    [self.bottomView addSubview:self.speedSlider];
    
    // 最大进度
    if (!self.maxSpeedLabel)
    {
        self.maxSpeedLabel = [[UILabel alloc] init];
        self.maxSpeedLabel.text = @"00:00:00";
        self.maxSpeedLabel.textColor = [UIColor whiteColor];
        self.maxSpeedLabel.font = [UIFont systemFontOfSize:9];
        self.maxSpeedLabel.textAlignment = NSTextAlignmentLeft;
    }
    self.maxSpeedLabel.frame = CGRectMake(Width-BottomViewHeight*2, 0, BottomViewHeight, BottomViewHeight);
    [self.bottomView addSubview:self.maxSpeedLabel];
    
    // 全屏
    if (!self.fullButton)
    {
        self.fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fullButton setImage:[UIImage imageNamed:@"wsmv_fullscreen.png"] forState:UIControlStateNormal];
        [self.fullButton setImage:[UIImage imageNamed:@"wsmv_full_exit.png"] forState:UIControlStateSelected];
        [self.fullButton addTarget:self action:@selector(fullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.fullButton.frame = CGRectMake(Width-BottomViewHeight, 0, BottomViewHeight, BottomViewHeight);
    [self.bottomView addSubview:self.fullButton];
}

- (void)initLeftView
{
    // 左边
    if (!self.leftView)
    {
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.5];
        self.leftView.frame = CGRectMake(-LeftViewHeight, TopViewHeight, LeftViewHeight, Height-TopViewHeight-BottomViewHeight);
    }
    [self addSubview:self.leftView];
}

- (void)initRightView
{
    // 右边
    if (!self.rightView)
    {
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.5];
        self.rightView.frame = CGRectMake(Width, TopViewHeight, RightViewHeight, Height-TopViewHeight-BottomViewHeight);
    }
    [self addSubview:self.rightView];
}

#pragma mark - VMediaPlayerDelegate
// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start]
// 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    self.isLoading = NO;
    [self start];
    
    if (!_speedTimer)
    {
        _speedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(speedTimerClick)
                                                     userInfo:nil
                                                      repeats:YES];
    }
}
// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后
// 操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [self reset];
}
// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参
// 数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
}

// 缓冲
- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    NSLog(@"缓冲开始");
    
    [self pause];
    self.isBuffing = player.isBuffering;
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    [self pause];
    [self showActivityView:[NSString stringWithFormat:@"缓冲 %d%%",
                            [((NSNumber *)arg) intValue]]];
    self.isBuffing = player.isBuffering;
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    NSLog(@"缓冲结束");
    
    [self start];
    self.isBuffing = player.isBuffering;
}

// 加载速率
- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    // 缓冲中显示速度指示器
    if (self.isBuffing)
    {
        [self showSpeedView:[NSString stringWithFormat:@"%dKB/s",[arg intValue]]];
    }
    else
    {
        [self hideSpeedView];
    }
}

// 缓存
- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    // 设置缓冲大小, 默认是1024KB(1*1024*1024).
    [player setBufferSize:512*1024];
    [player setVideoQuality:VMVideoQualityHigh];
    
    // 是否用缓存
    player.useCache = YES;
    [player setCacheDirectory:[self getCacheRootDirectory]];
}

// 读取缓存
- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg;
{
    NSLog(@"读取缓存开始");
}
- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg;
{
    NSLog(@"读取缓存中");
}
- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg;
{
    NSLog(@"读取缓存速度");
}
- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg;
{
    NSLog(@"读取缓存结束");
}

#pragma mark - 自定义方法
- (void)showTip:(BOOL)sender animation:(BOOL)animation
{
    self.isShowTip = sender;
    // 显示
    if (sender == YES)
    {
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            
            self.topView.frame = CGRectMake(0, 0, Width, TopViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            self.bottomView.frame = CGRectMake(0, Height-BottomViewHeight, Width, BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.leftView.frame = CGRectMake(0, TopViewHeight, LeftViewHeight, Height-TopViewHeight-BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            self.rightView.frame = CGRectMake(Width-RightViewHeight, TopViewHeight, RightViewHeight, Height-TopViewHeight-BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    // 不显示
    else
    {
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            self.topView.frame = CGRectMake(0, -TopViewHeight, Width, TopViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            self.bottomView.frame = CGRectMake(0, Height, Width, BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            self.leftView.frame = CGRectMake(-LeftViewHeight, TopViewHeight, LeftViewHeight, Height-TopViewHeight-BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animation?Duration:0 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.rightView.frame = CGRectMake(Width, TopViewHeight, RightViewHeight, Height-TopViewHeight-BottomViewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
}

// 全屏
- (void) fullView:(BOOL)isFull animation:(BOOL)animation
{
    self.isFull = isFull;
    self.fullButton.selected = isFull;

    if (!isFull)
    {
        // 初始屏幕
        [UIView animateWithDuration:animation?Duration:0 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
            self.transform = CGAffineTransformIdentity;
            self.frame = self.initRect;
            [self.initSuperView addSubview:self];
            [self showTip:self.isShowTip animation:YES];
            self.backButton.hidden = YES;
        }];
    }
    else
    {
        // 全屏
        [UIView animateWithDuration:animation?Duration:0 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
            self.center = window.center;
            [window addSubview:self];
            [self showTip:self.isShowTip animation:YES];
            self.backButton.hidden = NO;
        }];
    }
    
    [self setNeedsDisplay];
}

// 显示指示器
- (void) showActivityView:(NSString *)title
{
    for (UIView *v in self.activityView.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            ((UILabel *)v).text = title;
        }
    }
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

// 隐藏指示器
- (void) hideActivityView
{
    for (UIView *v in self.activityView.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            ((UILabel *)v).text = @"";
        }
    }
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
}

// 显示速度指示器
- (void) showSpeedView:(NSString *)title
{
    self.speedView.text = title;
    self.speedView.hidden = NO;
}

// 隐藏速度指示器
- (void) hideSpeedView
{
    self.speedView.text = @"";
    self.activityView.hidden = YES;
}

// 播放
- (void) start
{
    self.playButton.selected = YES;
    [self.mMPayer start];
    [self hideActivityView];
    self.isBuffing = NO;
    
    // 播放时不要锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

// 停止播放
- (void) pause
{
    self.playButton.selected = NO;
    [self.mMPayer pause];
    [self hideActivityView];
    
    // 暂停时可以锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

// 重新播放
- (void) reset
{
//    [self.mMPayer reset];
    [self.mMPayer seekTo:0];
}

// 获取目录
- (NSString *)getCacheRootDirectory
{
    NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cache;
}

// 格式化时间
- (NSString *)timeToHumanString:(unsigned long)ms
{
    unsigned long seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = ms / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
    nsRet = [[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding];
    
    return nsRet;
}

// 注册通知
- (void)setupObservers
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:[UIApplication sharedApplication]];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:[UIApplication sharedApplication]];
}

#pragma mark - 通知
// 进入前台
- (void)applicationDidEnterForeground:(NSNotification *)notification
{
//    [self.mMPayer setVideoShown:YES];
    if (![self.mMPayer isPlaying])
    {
        [self start];
    }
}
// 进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
//    [self.mMPayer setVideoShown:NO];
    if ([self.mMPayer isPlaying])
    {
        [self pause];
    }
}

#pragma mark - 重写
- (void) setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    
    if (isLoading)
    {
        self.playButton.enabled = NO;
        self.speedSlider.enabled = NO;
    }
    else
    {
        self.playButton.enabled = YES;
        self.speedSlider.enabled = YES;
    }
}

- (void) setIsBuffing:(BOOL)isBuffing
{
    _isBuffing = isBuffing;
    
    if (isBuffing)
    {
        self.playButton.enabled = NO;
    }
    else
    {
        self.playButton.enabled = YES;
    }
}

#pragma mark - 一般响应
// 点击事件
- (void) tapGesture:(UITapGestureRecognizer *)sender
{
    self.isShowTip = !self.isShowTip;
    [self showTip:self.isShowTip animation:YES];
}

// 全屏
- (void) fullButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self fullView:sender.selected animation:YES];
}

// 返回
- (void) backButtonClick:(UIButton *)sender
{
    if (self.isFull)
    {
        [self fullView:NO animation:YES];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zLVideoPlayerViewBack:)])
        {
            [self.delegate zLVideoPlayerViewBack:self];
        }
    }
}

// 播放
- (void) playButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [self start];
    }
    else
    {
        [self pause];
    }
}

// 播放进度 开始
- (void) speedSliderBegin:(UISlider *)sender
{
    [self pause];
}

// 播放进度 变化
- (void) speedSliderChange:(UISlider *)sender
{
    long seek = sender.value * self.mMPayer.getDuration;
    [self.mMPayer seekTo:seek];
}

// 播放进度 取消
- (void) speedSliderCancel:(UISlider *)sender
{
    [self start];
}

// 进度定时器
- (void) speedTimerClick
{
    self.speedSlider.value = (float)self.mMPayer.getCurrentPosition/self.mMPayer.getDuration;
    self.currentSpeedLabel.text = [self timeToHumanString:self.mMPayer.getCurrentPosition];
    self.maxSpeedLabel.text = [self timeToHumanString:self.mMPayer.getDuration];
    
    NSLog(@"fsadfsdf");
}

@end
