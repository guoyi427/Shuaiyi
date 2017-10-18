//
//  SplashViewController+Video.m
//  CIASMovie
//
//  Created by avatar on 2017/6/29.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "SplashViewController+Video.h"
#import <objc/runtime.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIButton+Block.h"


@implementation SplashViewController (Video)


- (void)playVideoWithPath:(NSString *)urlPath {
    
    
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    playerView.backgroundColor = [UIColor blackColor];
    
    NSURL *url = [NSURL URLWithString:urlPath];
    
    AVAsset *movieSet = [AVAsset assetWithURL:url];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:movieSet];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    layer.frame = playerView.frame;
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [[UIApplication sharedApplication].keyWindow addSubview:playerView];
    
    [playerView.layer addSublayer:layer];
    
    [player play];
    
    UIButton *jump = [UIButton buttonWithType:UIButtonTypeCustom];
    jump.frame = CGRectMake(kCommonScreenWidth - 55 - 15, 27, 55, 28);
    jump.layer.cornerRadius = 14;
    jump.layer.masksToBounds = YES;
    jump.layer.borderColor = [UIColor whiteColor].CGColor;
    jump.layer.borderWidth = 1;
    [jump setTitle:@"跳过" forState:UIControlStateNormal];
    [jump.titleLabel setFont: [UIFont systemFontOfSize:12]];
    [playerView addSubview:jump];
    
    __weak typeof(self)weakSelf = self;
    [jump handleWithBlock:^(UIButton *button) {
        
        [weakSelf dismissVideoView];
    }];
    
    
    objc_setAssociatedObject(self, @selector(playerItemDidReachEnd:), playerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @selector(dismissVideoView), player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerItemDidReachEnd:)
     
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
     
                                               object:item];
    
}

- (void)dismissVideoView {
    
    UIView *view = objc_getAssociatedObject(self, @selector(playerItemDidReachEnd:));
    
    AVPlayer *player = objc_getAssociatedObject(self, _cmd);
    
    if (player && view) {
        
        [player pause];
        
        [UIView animateWithDuration:1.0 animations:^
         {
             view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
             view.alpha = 0.0f;
         } completion:^(BOOL finished) {
             
             [view removeFromSuperview];
             
             if (self.dismissBlock) {
                 self.dismissBlock();
             }
             
         }];
    }
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    UIView *view = objc_getAssociatedObject(self, _cmd);
    
    if (view) {
        
        [UIView animateWithDuration:1.0 animations:^ {
             view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
             view.alpha = 0.0f;
         } completion:^(BOOL finished) {
             [view removeFromSuperview];
             if (self.dismissBlock) {
                 self.dismissBlock();
             }
         }];
    }
}



@end
