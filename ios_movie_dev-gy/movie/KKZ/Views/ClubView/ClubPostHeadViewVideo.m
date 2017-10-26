//
//  ClubPostHeadViewVideo.m
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostHeadViewVideo.h"
#import "KKZUtility.h"
#import "KKZVideoPlayerView.h"
#import "KKZFullViewController.h"
#import "UIImageView+WebCache.h"
#import "KKZVideoMaskView.h"

#define ClubPostHeadViewVideoHeight (kCommonScreenWidth * 3 / 4)

@interface ClubPostHeadViewVideo ()<CYVideoPlayerDelegate>

/**
 *  视频遮罩视图
 */
@property (nonatomic, strong) KKZVideoMaskView *videoMaskView;

/**
 *  电影播放器
 */
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

/**
 *  播放视频的URL
 */
@property (nonatomic, strong) NSString *contentUrl;

/**
 *  视频播放器
 */
@property (nonatomic, strong) KKZVideoPlayerView * videoPlayerView;

/**
 *  全屏控制器
 */
@property (nonatomic,strong) KKZFullViewController *fullViewController;

/**
 *  全屏尺寸
 */
@property (nonatomic,assign) CGRect fullScreenFrame;

/**
 *  正常视频尺寸
 */
@property (nonatomic,assign) CGRect normalScreenFrame;

@end

@implementation ClubPostHeadViewVideo

-(instancetype)initWithFrame:(CGRect)frame
                withVideoUrl:(NSString *)videoUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.contentUrl = videoUrl;
        //加载视频播放器
        [self loadMoviePlayer];
        //加载遮罩视图
        [self loadMaskView];
        //加载用户信息
        [self addUserInfoView];
    }
    return self;
}

- (void)loadMoviePlayer {
    
    //视频播放器
    [self addSubview:self.videoPlayerView];
    self.videoPlayerView.playURL = [NSURL URLWithString:self.contentUrl];
}

- (void)loadMaskView {
    
    //加载遮罩视图
    [self.videoPlayerView addSubview:self.videoMaskView];
}

- (void)startPlayerVideo {
    [self.videoPlayerView play];
}

- (void)pausePlayerVideo {
    [self.videoPlayerView pause];
}

- (void)stopPlayerVideo {
    [self.videoPlayerView stop];
}

- (void)playerPlayTime {
    self.videoMaskView.videoTimeLabel.text = [NSString stringWithFormat:@"时长 : %@",[self.videoPlayerView durationTime]];
}

- (void)clickScreenTouchEnd {
    if (self.videoMaskView.hidden) {
        [self playerPlayTime];
    }
    self.videoMaskView.hidden = !self.videoMaskView.hidden;
}

- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
          shouldFullScreen:(BOOL)isFull
{
    if (isFull) {

        //全屏控制器
        UIViewController *controller = [KKZUtility getRootNavagationLastTopController];
        self.fullViewController = [[KKZFullViewController alloc] init];
        self.fullViewController.view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5f animations:^{
            self.fullViewController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        self.fullViewController.view.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        [controller.view addSubview:self.fullViewController.view];
        [controller addChildViewController:self.fullViewController];
        
        //添加视频显示视图
        [self.videoPlayerView removeFromSuperview];
        self.videoPlayerView.frame = CGRectMake(0, 0,kCommonScreenHeight,kCommonScreenWidth);
        self.videoMaskView.frame = self.videoPlayerView.frame;
        [self.fullViewController.view addSubview:self.videoPlayerView];
    }else {

        //全屏控制器旋转
        self.fullViewController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView animateWithDuration:0.5f animations:^{
            self.fullViewController.view.transform = CGAffineTransformMakeRotation(0);
            self.fullViewController.view.frame = CGRectMake(0,self.tablePointY,kCommonScreenWidth, CGRectGetHeight(self.normalScreenFrame));
            self.videoPlayerView.frame = self.fullViewController.view.bounds;
        } completion:^(BOOL finished) {
            [self.fullViewController removeFromParentViewController];
            [self.fullViewController.view removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            self.videoMaskView.frame = self.videoPlayerView.frame;
            [self addSubview:self.videoPlayerView];
        }];
    }
}

- (void)setVideoCoverPath:(NSString *)videoCoverPath {
    _videoCoverPath = videoCoverPath;
    [self.videoPlayerView.imageView sd_setImageWithURL:[NSURL URLWithString:_videoCoverPath]];
}

- (KKZVideoPlayerView *)videoPlayerView {
    if (!_videoPlayerView) {
        _videoPlayerView = [[KKZVideoPlayerView alloc] initWithFrame:self.normalScreenFrame];
//        NSLog(@"videoPlayerView===%@",NSStringFromCGRect(_videoPlayerView.frame));
        _videoPlayerView.delegate = self;
        _videoPlayerView.backgroundColor = [UIColor blackColor];
    }
    return _videoPlayerView;
}

- (KKZVideoMaskView *)videoMaskView {
    if (!_videoMaskView) {
        _videoMaskView = [[KKZVideoMaskView alloc] initWithFrame:_videoPlayerView.bounds];
        _videoMaskView.userInteractionEnabled = NO;
    }
    return _videoMaskView;
}

- (CGRect)fullScreenFrame {
    return CGRectMake(0, 0, kCommonScreenHeight, kCommonScreenWidth);
}

- (CGRect)normalScreenFrame {
    CGFloat height = kCommonScreenWidth * 3 / 4;
    return CGRectMake(0, 0,kCommonScreenWidth, height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlayerVideo];
}

/**
 *  加载用户信息
 */
-(void)addUserInfoView
{
    self.videoPostInfoView = [[VideoPostInfoView alloc] initWithFrame:CGRectMake(0,ClubPostHeadViewVideoHeight, screentWith, 1)];
    [self addSubview:self.videoPostInfoView];
}

-(void)uploadData{
    self.videoPostInfoView.clubPost = self.clubPost;
    [self.videoPostInfoView upLoadData];
    
}

@end
