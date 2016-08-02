//
//  SBVideoControllView.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/26.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import "SBVideoControllView.h"
#import "SBPlaybackButton.h"
#import "UISlider+Middle.h"

#warning 插入到项目中后删掉
#define COLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
@interface SBVideoControllView ()

@property(strong, nonatomic) UIView *containerV;
@property(strong, nonatomic) SBPlaybackButton *playbackButton;
@property(strong, nonatomic) UILabel *remainTimeLabel;
@property(strong, nonatomic) UILabel *currentTimeLabel;
@property(strong, nonatomic) UISlider *progressView;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSTimer *counttingTimer;
@property(assign, nonatomic) int index;


@end

@implementation SBVideoControllView


- (instancetype)initWithPlayer:(SBVideoPlayer *)player{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SBVideoIsGoingToPlay) name:@"SBVideoIsGoingToPlay" object:nil];
        self.player = player;
        [self initBottomLayout];
    }
    return self;
}

- (void)setPlayer:(SBVideoPlayer *)player{
    _player = player;
    [player addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"current_time" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"current_loaded_time" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _containerV.frame = CGRectMake(0, frame.size.height-35, frame.size.width, 35);
    _playbackButton.frame = CGRectMake(10, 0, 35, 35);
    _currentTimeLabel.frame = CGRectMake(45, 0, 60, 35);
    _remainTimeLabel.frame = CGRectMake(frame.size.width-70, 0, 60, 35);
    _progressView.frame = CGRectMake(_currentTimeLabel.frame.origin.x+_currentTimeLabel.frame.size.width, 0, frame.size.width-_playbackButton.frame.size.width-_currentTimeLabel.frame.size.width-_remainTimeLabel.frame.size.width-20, 35);
    _activityIndicator.center = self.center;
}
- (void)setCounttingTimer:(NSTimer *)counttingTimer{
    if (_counttingTimer!=counttingTimer) {
        [_counttingTimer invalidate];
        _counttingTimer= counttingTimer;
    }
}
- (void)initBottomLayout{
    
    _containerV = [[UIView alloc]initWithFrame:CGRectZero];
    [_containerV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"controll_bg"]]];
    //[_containerV setBackgroundColor:[UIColor clearColor]];
    
    _playbackButton = [[SBPlaybackButton alloc]init];
    [_playbackButton addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerV addSubview:_playbackButton];
    
    //当前时间
    _currentTimeLabel = [[UILabel alloc]init];
    _currentTimeLabel.backgroundColor = [UIColor clearColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:13];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_containerV addSubview:_currentTimeLabel];
    
    //进度条
    _progressView = [[UISlider alloc]init];
    _progressView.maximumValue = 1.0;
    _progressView.minimumTrackTintColor = [UIColor whiteColor];
    _progressView.maximumTrackTintColor = COLOR(131, 131, 131, .5);
    [_progressView setThumbImage:[UIImage imageNamed:@"thumb@2x"] forState:UIControlStateNormal];
    [_progressView addTarget:self action:@selector(progressViewValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [_containerV addSubview:_progressView];
    
    //剩余时间
    _remainTimeLabel = [[UILabel alloc]init];
    _remainTimeLabel.backgroundColor = [UIColor clearColor];
    _remainTimeLabel.font = [UIFont systemFontOfSize:13];
    _remainTimeLabel.textColor = [UIColor whiteColor];
    _remainTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_containerV addSubview:_remainTimeLabel];
    [self addSubview:_containerV];
    
    //菊花
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_activityIndicator startAnimating];
    [self addSubview:_activityIndicator];
    
    
    //计数器
    self.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countting) userInfo:nil repeats:YES];
 
    self.index = 0;
  
}

- (void)SBVideoIsGoingToPlay{
    
    
}

- (void)progressViewValueDidChanged:(UISlider *)slider{
    
    Float64 totalSeconds = CMTimeGetSeconds(_player.playerItem.duration);
    
    CMTime time = CMTimeMakeWithSeconds(totalSeconds * slider.value, _player.playerItem.duration.timescale);
    [self seekToCMTime:time];
}


- (void)seekToCMTime:(CMTime)time
{
    if (_player.state==SBVideoPlayerStatePlaying){
        [_player.player pause];
    }
    
    [_player.player seekToTime:time completionHandler:^(BOOL finished) {
        if (_player.state==SBVideoPlayerStatePlaying && finished){
            [_player play];
            [self starCountting];
        }
    }];
}

- (void)playbackButtonAction:(SBPlaybackButton *)button{
    
    if (_player.state == SBVideoPlayerStateStalled  ) {
        [_player play];
        button.playState = 1;
    }else if (_player.state == SBVideoPlayerStatePlaying) {
        [_player pause];
        button.playState = 2;
        NSLog(@"停");
    }else if(_player.state == SBVideoPlayerStatePause){
        NSLog(@"放");
        [_player play];
        button.playState = 1;
    }
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"current_time"]) {
        
        float new = [[change objectForKey:@"new"]floatValue];
        
        _progressView.value = new/CMTimeGetSeconds(_player.playerItem.duration);
        
        NSString *text = [self timeStringWithTime:CMTimeGetSeconds(_player.playerItem.duration)-new];
        
        _remainTimeLabel.text = [NSString stringWithFormat:@"-%@", text];
        
        _currentTimeLabel.text = [self timeStringWithTime:[[change objectForKey:@"new"]floatValue]];
        
    }
    
    if ([keyPath isEqualToString:@"current_loaded_time"]) {
        float new = [[change objectForKey:@"new"]floatValue];
        [_progressView setMiddleValue:new/CMTimeGetSeconds(_player.playerItem.duration)];
        
    }
    
    if ([keyPath isEqualToString:@"state"]) {

        
        if (_player.state == SBVideoPlayerStatePlaying) {
            [_activityIndicator stopAnimating];
            _playbackButton.playState = 1;
        }
        
        if (_player.state == SBVideoPlayerStatePause) {
            _playbackButton.playState = 2;
        }
        
        if (_player.state == SBVideoPlayerStateStalled) {
            [_activityIndicator startAnimating];
            _playbackButton.playState = 2;
        }
    }
}

#pragma mark tool method
- (NSString *)timeStringWithTime:(float)time{
    if (time == 0){
        return @"00:00";
    }
    Float64 seconds = time;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [formatter setDateFormat:(seconds / 3600 >= 1) ? @"h:mm:ss" : @"mm:ss"];
    
    return [formatter stringFromDate:date];
}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchBeganHandlingWithEvent:event];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (CGRectContainsPoint(_containerV.frame, point)) {
        [self touchBeganHandlingWithEvent:event];
        [self starCountting];
    }

    return [super hitTest:point withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self starCountting];
}

- (void)showBottomControllBarAnimated:(BOOL)animated{
     if (_containerV.alpha>=1) return;
    [self starCountting];
    [UIView animateWithDuration:animated?.4:0 animations:^{
        _containerV.alpha = 1.0;
    }];
    
}

- (void)hideBottomControllBarAnimated:(BOOL)animated{
    if (_containerV.alpha<=0) return;
    [_counttingTimer invalidate];
    [UIView animateWithDuration:animated?1.5:0 animations:^{
        _containerV.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)touchBeganHandlingWithEvent:(UIEvent*)event{
    _index=0;
    [_counttingTimer invalidate];
    [self showBottomControllBarAnimated:YES];
    if (_player.state==SBVideoPlayerStateStalled) {
        //        if (_containerV.alpha>=1) {
        //            [self hideBottomControllBarAnimated:YES];
        //        }else{
        //            [self showBottomControllBarAnimated:YES];
        //        }
        
    }else{
        if (event.type == UIEventTypeTouches) {
            [self playbackButtonAction:_playbackButton];
        }
    }
    
    
}

- (void)starCountting{
    self.counttingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countting) userInfo:nil repeats:YES];
}
- (void)countting{
    _index++;
    if (_index>=4) {
        [self hideBottomControllBarAnimated:YES];
    }
    NSLog(@"rrrrrrrrrrrr  %d", _index);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
