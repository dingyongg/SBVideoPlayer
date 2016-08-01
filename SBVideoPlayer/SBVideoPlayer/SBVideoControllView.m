//
//  SBVideoControllView.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/26.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import "SBVideoControllView.h"
#import "SBPlaybackButton.h"


@interface SBVideoControllView ()

@property(strong ,nonatomic) UIView *containerV;
@property(strong, nonatomic) SBPlaybackButton *playbackButton;

@end

@implementation SBVideoControllView


- (instancetype)initWithPlayer:(SBVideoPlayer *)player{
    self = [super init];
    if (self) {
        self.player = player;
        [self initBottomLayout];

    }
    return self;
}

- (void)setPlayer:(SBVideoPlayer *)player{
    _player = player;
   
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _containerV.frame = CGRectMake(0, frame.size.height-35, frame.size.width, 35);
    _playbackButton.frame = CGRectMake(0, 0, 35, 35);
}

- (void)initBottomLayout{
    
    _containerV = [[UIView alloc]initWithFrame:CGRectZero];
    [_containerV setBackgroundColor:[UIColor clearColor]];
    _containerV.layer.borderColor = [UIColor redColor].CGColor;
    _containerV.layer.borderWidth = 1;
    _containerV.layer.masksToBounds = YES;
    
    _playbackButton = [[SBPlaybackButton alloc]init];
    [_playbackButton addTarget:self action:@selector(playbackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerV addSubview:_playbackButton];
    
    [self addSubview:_containerV];
}

- (void)playbackButtonAction{
    
    NSLog(@"tap");
    
}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (event.type == UIEventTypeTouches) {
        
        if (_player.state == SBVideoPlayerStatePlaying) {
            [_player pause];
            NSLog(@"停");
        }else{
            NSLog(@"放");
            [_player play];
        }
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
