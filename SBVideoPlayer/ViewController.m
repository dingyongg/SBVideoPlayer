//
//  ViewController.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/13.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#define video_url_str @"http://test.starbuyer.com/upload/2016/06/29/1467193552.mp4"

#import "ViewController.h"

#import "SBVideoPlayer.h"



@interface ViewController (){
    SBVideoPlayer *videoPlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!videoPlayer) {
        videoPlayer = [[SBVideoPlayer alloc]initWithURL:[NSURL URLWithString:video_url_str]];
        videoPlayer.backgroundColor = [UIColor blackColor];
        videoPlayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width);
        [self.view addSubview:videoPlayer];
    }else{
        
        [videoPlayer.player play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
