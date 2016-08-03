//
//  ViewController.m
//  SBVideoPlayer
//
//  Created by bigbomac02 on 16/7/13.
//  Copyright © 2016年 bigbomac02. All rights reserved.
//

#define video_url_str @"https://www.starbuyer.com//upload/2016/05/27/1464330352.mp4"

#import "ViewController.h"

#import "SBVideoPlayer.h"



@interface ViewController (){
    SBVideoPlayer *videoPlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SBVideoIsGoingToPlay) name:@"SBVideoIsGoingToPlay" object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"放");
    
    if (!videoPlayer) {
        videoPlayer = [[SBVideoPlayer alloc]initWithURL:[NSURL URLWithString:video_url_str]];
        videoPlayer.backgroundColor = [UIColor blackColor];
        videoPlayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width);
        [self.view addSubview:videoPlayer];
    }else{
        
        [videoPlayer play];
    }
}


- (void)SBVideoIsGoingToPlay{

    NSLog(@"SBVideoIsGoingToPlay");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
