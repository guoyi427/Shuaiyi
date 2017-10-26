//
//  ClubPostHeadViewAudio.m
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPost.h"
#import "ClubPostHeadViewAudio.h"
#import "ClubPostProgressView.h"
#import "ImageEngineNew.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "NSStringExtra.h"
#import "UIColor+Hex.h"
#import "NSStringExtra.h"

#define ClubPostHeadViewAudioHeight 165

static const CGFloat PostProgressHeight = 40.0f;

@interface ClubPostHeadViewAudio () <AVAudioPlayerDelegate>

/**
 *  音频播放器
 */
@property (nonatomic, strong) AVAudioPlayer *player;

/**
 *  播放背景
 */
@property (nonatomic, strong) UIImageView *audioPlayBgView;

/**
 *  添加背景蒙版
 */
@property (nonatomic, strong) UIView *audioPlayCover;

/**
 *  播放图片
 */
@property (nonatomic, strong) UIImageView *playImageView;

/**
 *  进度条
 */
@property (nonatomic, strong) ClubPostProgressView *clubPostProgressView;

/**
 *  播放视频的URL
 */
@property (nonatomic, strong) NSString *contentUrl;

@end

@implementation ClubPostHeadViewAudio

- (instancetype)initWithFrame:(CGRect)frame
                 withAudioUrl:(NSString *)audioUrl {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentUrl = audioUrl;

        //增加单击手势
        [self addTapGesture];

        //播放音频数据
        [self playAudioWithUrl:self.contentUrl];

        //添加黑色蒙版
        [self addSubview:self.audioPlayCover];

        //加载用户信息
        [self addUserInfoView];

        //增加通知
        [self addNotification];
    }
    return self;
}

- (void)addNotification {
    //增加进入后台之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:@"AppDidEnterBackground"
                                               object:nil];
}

- (void)enterBackground {
    if (self.player.playing) {
        [self tapGesture];
    }
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapGesture)];
    [self addGestureRecognizer:tap];
}

- (void)tapGesture {
    if (self.player.playing) {
        self.playImageView.hidden = NO;
        self.clubPostProgressView.hidden = YES;
        [self.player pause];
        [self.clubPostProgressView.pauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        self.playImageView.hidden = YES;
        self.clubPostProgressView.hidden = NO;
        [self.player play];
        [self.clubPostProgressView.pauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)playAudioWithUrl:(NSString *)urlStr {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *audioData = [NSData dataWithContentsOfURL:url];
        //将数据保存到本地指定位置
        NSString *filePath = [NSString stringWithFormat:@"%@%@.mp3", NSTemporaryDirectory(), [urlStr MD5String]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            [audioData writeToFile:filePath
                        atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            //添加播放器视图
            [self addPlayerView];

            //初始化音频播放器
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            self.player = [KKZUtility startPlayAudio:fileURL];
            self.player.delegate = self;
            self.clubPostProgressView.player = self.player;
        });
    });
}

- (void)addPlayerView {

    //加载音频播放背景
    [self addSubview:self.audioPlayBgView];

    //添加进度视图
    [self addSubview:self.clubPostProgressView];

    //添加暂停视图
    [self addSubview:self.playImageView];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playImageView.hidden = NO;
    self.clubPostProgressView.hidden = YES;
    [self.player pause];
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        UIImage *pauseImg = [UIImage imageNamed:@"club_PlayPause"];
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - pauseImg.size.width) / 2.0f, (ClubPostHeadViewAudioHeight - pauseImg.size.height) / 2.0f, pauseImg.size.width, pauseImg.size.height)];
        _playImageView.image = pauseImg;
        [self addSubview:_playImageView];
    }
    return _playImageView;
}

- (ClubPostProgressView *)clubPostProgressView {
    if (!_clubPostProgressView) {
        __weak typeof(self) weakSelf = self;
        _clubPostProgressView = [[ClubPostProgressView alloc] initWithFrame:CGRectMake(0, ClubPostHeadViewAudioHeight - PostProgressHeight, self.frame.size.width, PostProgressHeight)];
        _clubPostProgressView.hidden = YES;
        _clubPostProgressView.audioPlayerPause = ^(BOOL isPause) {
            if (isPause) {
                weakSelf.playImageView.hidden = NO;
                [weakSelf.player pause];
            } else {
                weakSelf.playImageView.hidden = YES;
                [weakSelf.player play];
            }
        };
    }
    return _clubPostProgressView;
}

- (void)dealloc {
    [self.player stop];
    [_clubPostProgressView removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  加载用户信息
 */
- (void)addUserInfoView {
    self.videoPostInfoView = [[VideoPostInfoView alloc] initWithFrame:CGRectMake(0, ClubPostHeadViewAudioHeight, screentWith, 1)];
    [self addSubview:self.videoPostInfoView];
}

- (void)uploadData {
    self.videoPostInfoView.clubPost = self.clubPost;
   
    self.postImgPath = self.clubPost.author.head;
    NSString *url = [NSString stringWithFormat:@"typeonepost%@", self.clubPost.author.head];
    UIImage *newImg = [[ImageEngineNew sharedImageEngineNew] getImageFromDiskForURL:[url MD5String] andSize:ImageSizeOrign];
    if (newImg) {
        self.audioPlayBgView.image = newImg;
    } else {
        NSThread *myThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(newImage)
                                                       object:nil];

        [myThread start];
    }

    [self.videoPostInfoView upLoadData];
}

/**
 *  添加播放背景
 */
- (UIImageView *)audioPlayBgView {
    if (!_audioPlayBgView) {
        _audioPlayBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, ClubPostHeadViewAudioHeight)];
        _audioPlayBgView.contentMode = UIViewContentModeScaleAspectFill;
        _audioPlayBgView.layer.masksToBounds = YES;

        UIView *blackCoverV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, ClubPostHeadViewAudioHeight)];
        [blackCoverV setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.3]];

        [_audioPlayBgView addSubview:blackCoverV];
    }
    return _audioPlayBgView;
}

- (void)newImage {

    //设置背景图片

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.postImgPath]];

    UIImage *img = [UIImage imageWithData:data];

    CGSize finalSize = CGSizeMake(screentWith, ClubPostHeadViewAudioHeight);

    UIImage *newImg = [KKZUtility resibleImage:img toSize:finalSize];

    UIImage *blureImg = [self blureImage:newImg withInputRadius:1.0f];

    self.audioPlayBgView.image = blureImg;

    NSString *url = [NSString stringWithFormat:@"typeonepost%@", self.postImgPath];

    [[ImageEngineNew sharedImageEngineNew] saveImage:blureImg forURL:[url MD5String] andSize:ImageSizeOrign sync:NO fromCache:YES];

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.audioPlayBgView.image = blureImg;
    });
}

- (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGSize finalSize = CGSizeMake(screentWith, ClubPostHeadViewAudioHeight);

    CGFloat width = finalSize.width;
    CGFloat height = finalSize.height;

    CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(0, 0, width, height)];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

- (UIView *)audioPlayCover {
    if (!_audioPlayCover) {
        _audioPlayCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, ClubPostHeadViewAudioHeight)];
        [_audioPlayCover setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.25]];
    }

    return _audioPlayCover;
}
@end
