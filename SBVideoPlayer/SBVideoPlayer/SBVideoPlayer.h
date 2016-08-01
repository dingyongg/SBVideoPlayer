//
//  SBVideoPlayer.h
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/13.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    SBVideoPlayerStatePlaying,
    SBVideoPlayerStatePause,
 
} SBVideoPlayerState;

@interface SBVideoPlayer : UIView

- (instancetype)initWithURL:(NSURL *)URL;

@property(strong, nonatomic) NSURL *URL;

@property (strong, nonatomic) AVPlayer *player;

@property (nonatomic, assign, readonly) SBVideoPlayerState state;


@property (nonatomic, assign) float current_time;

@property (nonatomic, assign) float current_loaded_time;

- (void)play;
- (void)pause;

@end
