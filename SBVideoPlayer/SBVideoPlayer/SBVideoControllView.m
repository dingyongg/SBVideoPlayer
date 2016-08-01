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

@property(strong ,nonatomic) UIView *containerV;
@property(strong, nonatomic) SBPlaybackButton *playbackButton;
@property(strong, nonatomic) UILabel *remainTimeLabel;
@property(strong, nonatomic) UILabel *currentTimeLabel;
@property(strong, nonatomic) UISlider *progressView;

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
    
    [player addObserver:self forKeyPath:@"current_time" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"current_loaded_time" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _containerV.frame = CGRectMake(0, frame.size.height-35, frame.size.width, 35);
    _playbackButton.frame = CGRectMake(0, 0, 35, 35);
    _currentTimeLabel.frame = CGRectMake(35, 0, 60, 35);
    _remainTimeLabel.frame = CGRectMake(frame.size.width-60, 0, 60, 35);
    _progressView.frame = CGRectMake(_currentTimeLabel.frame.origin.x+_currentTimeLabel.frame.size.width, 0, frame.size.width-_playbackButton.frame.size.width-_currentTimeLabel.frame.size.width-_remainTimeLabel.frame.size.width, 35);
}

- (void)initBottomLayout{
    
    _containerV = [[UIView alloc]initWithFrame:CGRectZero];
    [_containerV setBackgroundColor:[UIColor clearColor]];
    
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
    [_containerV addSubview:_progressView];
    
    //剩余时间
    _remainTimeLabel = [[UILabel alloc]init];
    _remainTimeLabel.backgroundColor = [UIColor clearColor];
    _remainTimeLabel.font = [UIFont systemFontOfSize:13];
    _remainTimeLabel.textColor = [UIColor whiteColor];
    _remainTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_containerV addSubview:_remainTimeLabel];
    
    [self addSubview:_containerV];
}

- (void)SBVideoIsGoingToPlay{
    
    
    
    
}

- (void)playbackButtonAction:(SBPlaybackButton *)button{
    
    if (_player.state == SBVideoPlayerStatePlaying) {
        [_player pause];
        button.playState = 1;
        NSLog(@"停");
    }else{
        NSLog(@"放");
        [_player play];
        button.playState = 2;
    }
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"current_time"]) {
        
        float current = [[change objectForKey:@"new"]floatValue];
        _progressView.value = current/CMTimeGetSeconds(_player.playerItem.duration);
        NSString *text = [self timeStringWithTime:CMTimeGetSeconds(_player.playerItem.duration)-current];
        
        _remainTimeLabel.text = [NSString stringWithFormat:@"-%@", text];

        _currentTimeLabel.text = [self timeStringWithTime:[[change objectForKey:@"new"]floatValue]];
        
    }
    
    if ([keyPath isEqualToString:@"current_loaded_time"]) {
        float current = [[change objectForKey:@"new"]floatValue];
        [_progressView setMiddleValue:current/CMTimeGetSeconds(_player.playerItem.duration)];
    }
    
 
}

#pragma mark tool method
- (NSString *)timeStringWithTime:(float)time{
    if (time == 0)
    {
        return @"";
    }
    Float64 seconds = time;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [formatter setDateFormat:(seconds / 3600 >= 1) ? @"h:mm:ss" : @"mm:ss"];
    
    return [formatter stringFromDate:date];
}
-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (event.type == UIEventTypeTouches) {
        [self playbackButtonAction:_playbackButton];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
