//
//  SBVideoPlayer.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/13.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import "SBVideoPlayer.h"
#import "SBVideoControllView.h"

@interface SBVideoPlayer ()
@property (strong ,nonatomic) UIView* containerV;
@property (strong, nonatomic) SBVideoControllView *controllView;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVAsset *asset;


@end

@implementation SBVideoPlayer

#pragma mark initialization

- (instancetype)initWithURL:(NSURL *)URL{
    self = [super init];
    if (self) {
        [self creatContainerView];
        self.URL = URL;
        [self creatController];
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enablePlay) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unablePlay) name:AVPlayerItemPlaybackStalledNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}


#pragma mark setMethod

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _playerLayer.frame = self.bounds;
    _containerV.frame = self.bounds;
    _controllView.frame = self.bounds;
}

- (void)setURL:(NSURL *)URL{
    _URL = URL;
    //self.asset = [AVAsset assetWithURL:URL];
    
    self.playerItem  = [AVPlayerItem playerItemWithURL:URL];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self play];
    
    __weak SBVideoPlayer *weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.current_time =  CMTimeGetSeconds(time);
        NSLog(@"%f", CMTimeGetSeconds(time));
    }];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [_containerV.layer addSublayer:_playerLayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    _playerItem = playerItem;
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
}


//- (void)setPlayer:(AVPlayer *)player{
//    if (!_player) _player = player;
//    
//}
//- (void)setPlayerItem:(AVPlayerItem *)playerItem{
//    if (!_playerItem) _playerItem = playerItem;
//}
//- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer{
//    if (!_playerLayer) _playerLayer = playerLayer;
//}


- (void)creatContainerView{
    _containerV = [[UIView alloc]initWithFrame:CGRectZero];
    _containerV.backgroundColor = [UIColor clearColor];
    [self addSubview:_containerV];
}

- (void)creatController{
    _controllView = [[SBVideoControllView alloc]initWithPlayer:self];
    [self addSubview:_controllView];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status= [[change objectForKey:@"new"]intValue];
        
        if (status==AVPlayerStatusUnknown) {
            NSLog(@"AVPlayerStatusUnknown");
        }
        if (status==AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SBVideoIsGoingToPlay" object:object userInfo:nil];
        }
        if (status==AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray*array = _playerItem.loadedTimeRanges;
        
        NSLog(@"array = %@", array);
        
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        
        float startSeconds =CMTimeGetSeconds(timeRange.start);
        
        float durationSeconds =CMTimeGetSeconds(timeRange.duration);
        
        //缓冲总长度
        
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        
        NSLog(@"共缓存：%.2f",totalBuffer);
        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        
        BOOL status = [[change objectForKey:@"playbackLikelyToKeepUp"] intValue];
        if (status && _state==SBVideoPlayerStatePause){
            NSLog(@"playbackLikelyToKeepUp");
            //[self play];
        }

    }
}

- (void)enablePlay{
    NSLog(@"可以播放了");
}

- (void)unablePlay{
    
    _state = SBVideoPlayerStatePause;
    
    NSLog(@"不可播放了");
}

- (void)playToEnd{
    [_playerItem seekToTime:kCMTimeZero];
    [self pause];
}


- (void)play{
    [_player play];
    _state = SBVideoPlayerStatePlaying;
    
    
}
- (void)pause{
    [_player pause];
    _state = SBVideoPlayerStatePause;
}


- (void)dealloc{
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
