//
//  SBVideoControllView.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/26.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import "SBVideoControllView.h"

@implementation SBVideoControllView


- (instancetype)initWithPlayer:(SBVideoPlayer *)player{
    self = [super init];
    if (self) {
        self.player = player;
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.8];
    }
    return self;
}

- (void)setPlayer:(SBVideoPlayer *)player{
    _player = player;

    
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
