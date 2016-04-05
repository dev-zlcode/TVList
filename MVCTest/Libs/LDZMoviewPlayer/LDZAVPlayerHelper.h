//
//  LDZAVPlayerHelper.h
//  LDZMoviewPlayer_Xib
//
//  Created by rongxun02 on 15/12/10.
//  Copyright © 2015年 DongZe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LDZAVPlayerHelper : NSObject

- (AVPlayer *)getAVPlayer;
- (void)initAVPlayerWithAVPlayerItem:(AVPlayerItem *)item;
- (void)setAVPlayerVolume:(float)volume;
@end
