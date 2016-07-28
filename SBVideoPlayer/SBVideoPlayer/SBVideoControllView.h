//
//  SBVideoControllView.h
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/26.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBVideoPlayer.h"


@interface SBVideoControllView : UIView

- (instancetype)initWithPlayer:(SBVideoPlayer *)player;

@property(nonatomic, weak) SBVideoPlayer *player;

@end
