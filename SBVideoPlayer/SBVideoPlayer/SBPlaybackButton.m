//
//  SBPlaybackButton.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/8/1.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import "SBPlaybackButton.h"

@implementation SBPlaybackButton

- (instancetype)init{
    self = [super init];
    if (self) {
        self.playState = 2;
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setPlayState:(int)playState{
    if (playState == 1) { //暂停
        [self setImage:[UIImage imageNamed:@"moviePause@2x"] forState:UIControlStateNormal];
         //[self setBackgroundImage:[UIImage imageNamed:@"moviePause@2x"] forState:UIControlStateNormal];
    }else if (playState== 2){ //播放
        [self setImage:[UIImage imageNamed:@"moviePlay@2x"] forState:UIControlStateNormal];
        // [self setBackgroundImage:[UIImage imageNamed:@"moviePlay@2x"] forState:UIControlStateNormal];
    }
    _playState = playState;
}

- (void)tapAction{
    NSLog(@"tap");
    if (_playState == 1) { //暂停
        self.playState = 2;
    }else if (_playState== 2){ //播放
        self.playState = 1;
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
