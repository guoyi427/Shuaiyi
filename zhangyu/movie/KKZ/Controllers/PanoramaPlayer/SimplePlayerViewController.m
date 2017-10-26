//
//  播放全景视频的页面
//
//  Created by KKZ on 15/10/8.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SimplePlayerViewController.h"

#import "NetworkStatus.h"
#import "RIButtonItem.h"
#import "SimplePlayerVideo.h"
#import "UIAlertView+Blocks.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>


@interface SimplePlayerViewController () <PFAssetObserver, PFAssetTimeMonitor, UIActionSheetDelegate> {

    PFView *pfView;
    id<PFAsset> pfAsset;

    NSTimer *slidertimer;
    int currentview;

    UIButton *playbutton;
    UIButton *stopbutton;
    UIButton *navbutton;
    UIButton *viewbutton;
    UISlider *slider;
    UISlider *voiceSlider;
    UIButton *typebutton;
    UIButton *localbutton;

    bool islocal;

    UIActivityIndicatorView *seekindicator;
    UIView *seekindicatorView;
    UIImage *pauseImage;
    UIButton *changScreenFrameBtn;

    UIView *topStatusBar;
    UIView *botomStatusBar;

    BOOL isChangeVideoUrl;
    BOOL isStartFromLabtext;

    UILabel *voiceLenghLab;
    UIView *bottomBgView;
    UIButton *speakBtn;
    UIImageView *spreadImgV;
    UILabel *movieTitleLab;
    UIView *resolutionSheet;

    NSInteger selectedBtnTag;
    UIView *voiceSliderBg;
    UIImageView *voiceIconImgV;
    UIView *botomStatusBarVertical;

    UIButton *changScreenFrameBtnVertical, *playbuttonVertical;
    UILabel *voiceLenghLabVertical;
    UIImageView *downShadow;
    UISlider *sliderVertical;

    BOOL isFullScreen;
    UILabel *voiceTotalLenghLab;
    CGFloat videoPlayLength;
    UIView *noticeText;

    float lastPlayTime; // 上1秒播放器播放的时间
    NSDate *startBufferTime; // 开始缓冲的时间

    NSTimer *speedTimer;

    NSTimer *resetBarStatusTimer;

    BOOL showNoticeText;
    BOOL isNetworkReachable;
    UIView *noNetReachView;
    UILabel *labNonet;
}

- (void)onStatusMessage:(PFAsset *)asset message:(enum PFASSETMESSAGE)m;
- (void)onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time;

@end

@implementation SimplePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    slider.value = 0;
    slider.enabled = false;

    sliderVertical.value = 0;
    sliderVertical.enabled = false;

    slidertimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(onPlaybackTime:)
                                                 userInfo:nil
                                                  repeats:YES];

    speedTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(checkPlayStatus)
                                                userInfo:nil
                                                 repeats:YES];

    seekindicatorView = [[UIView alloc] initWithFrame:CGRectMake((screentWith - 240) * 0.5, (screentHeight - 120) * 0.5, 240, 120)];

    //设置背景色
    seekindicatorView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.3];

    //设置背景为圆角矩形
    seekindicatorView.layer.cornerRadius = 6;
    seekindicatorView.layer.masksToBounds = YES;
    seekindicatorView.transform = CGAffineTransformMakeRotation(0.5 * M_PI);

    seekindicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((240 - 50) * 0.5, 20, 50, 50)];

    [seekindicatorView addSubview:seekindicator];

    UILabel *seekindicatorLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 240, 50)];
    seekindicatorLab.text = @"正在缓冲...";
    seekindicatorLab.textColor = [UIColor whiteColor];
    seekindicatorLab.font = [UIFont systemFontOfSize:20];
    seekindicatorLab.textAlignment = NSTextAlignmentCenter;
    [seekindicatorLab setBackgroundColor:[UIColor clearColor]];

    [seekindicatorView addSubview:seekindicatorLab];

    [self.view addSubview:seekindicatorView];

    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    seekindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [seekindicator startAnimating];

    seekindicatorView.hidden = TRUE;

    currentview = 0;

    self.view.frame = CGRectMake(0, self.contentPositionY, screentWith, 181 * (screentWith / 320));

    topStatusBar = [[UIView alloc] initWithFrame:CGRectMake(screentWith - 0.5 * screentHeight - 22, 0.5 * screentHeight - 22, screentHeight, 44)];
    [topStatusBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    topStatusBar.hidden = YES;
    topStatusBar.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
    [self.view addSubview:topStatusBar];

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [topStatusBar addSubview:backBtn];

    movieTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 270, 44)];
    movieTitleLab.text = self.videoName;
    movieTitleLab.textColor = [UIColor whiteColor];
    movieTitleLab.font = [UIFont systemFontOfSize:16];
    [movieTitleLab setBackgroundColor:[UIColor clearColor]];
    [topStatusBar addSubview:movieTitleLab];

    localbutton = [[UIButton alloc] initWithFrame:CGRectMake(screentHeight - 80, 0, 80, 44)];
    [localbutton setBackgroundColor:[UIColor clearColor]];
    localbutton.titleLabel.textAlignment = NSTextAlignmentRight;
    localbutton.titleLabel.font = [UIFont systemFontOfSize:16];
    [localbutton setTitle:@"" forState:UIControlStateNormal];
    [localbutton addTarget:self action:@selector(localclicked) forControlEvents:UIControlEventTouchUpInside];
    [topStatusBar addSubview:localbutton];

    spreadImgV = [[UIImageView alloc] initWithFrame:CGRectMake(65, (50 - 10) * 0.5, 5, 5)];
    UIImage *img = [UIImage imageNamed:@"spreadIcon"];
    spreadImgV.image = img;
    [localbutton addSubview:spreadImgV];
    spreadImgV.userInteractionEnabled = YES;

    botomStatusBar = [[UIView alloc] initWithFrame:CGRectMake(-0.5 * screentHeight - 30 + 60, 0.5 * screentHeight - 30, screentHeight, 60)];
    [self.view addSubview:botomStatusBar];

    botomStatusBar.hidden = YES;
    botomStatusBar.transform = CGAffineTransformMakeRotation(0.5 * M_PI);

    bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screentHeight, 50)];
    [bottomBgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [botomStatusBar addSubview:bottomBgView];

    playbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [playbutton setBackgroundColor:[UIColor clearColor]];
    [playbutton setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [playbutton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:playbutton];

    voiceLenghLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 70, 50)];
    [voiceLenghLab setBackgroundColor:[UIColor clearColor]];
    voiceLenghLab.textColor = [UIColor r:200 g:200 b:200];
    voiceLenghLab.textAlignment = NSTextAlignmentRight;
    voiceLenghLab.text = @"00:00:00";
    voiceLenghLab.font = [UIFont systemFontOfSize:14];
    [bottomBgView addSubview:voiceLenghLab];

    voiceTotalLenghLab = [[UILabel alloc] initWithFrame:CGRectMake(50 + 70, 0, 70, 50)];
    [voiceTotalLenghLab setBackgroundColor:[UIColor clearColor]];
    voiceTotalLenghLab.textColor = [UIColor r:147 g:147 b:147];
    voiceTotalLenghLab.font = [UIFont systemFontOfSize:14];
    voiceTotalLenghLab.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:voiceTotalLenghLab];
    voiceTotalLenghLab.hidden = YES;

    changScreenFrameBtn = [[UIButton alloc] initWithFrame:CGRectMake(botomStatusBar.frame.size.width - 50, 0, 50, 50)];
    [changScreenFrameBtn setBackgroundColor:[UIColor clearColor]];
    [changScreenFrameBtn setImage:[UIImage imageNamed:@"screenIcon"] forState:UIControlStateNormal];
    [changScreenFrameBtn addTarget:self action:@selector(changFrameReturn:) forControlEvents:UIControlEventTouchUpInside];

    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 4, screentHeight, 10)];
    slider.minimumValue = 0; //指定可变最小值
    slider.maximumValue = 100; //指定可变最大值
    slider.value = 0; //指定初始值

    [slider setMinimumTrackTintColor:[UIColor r:55 g:196 b:0]];
    [slider setMaximumTrackTintColor:[UIColor r:86 g:86 b:86]];
    [slider setThumbImage:[UIImage imageNamed:@"sliderImg"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventValueChanged]; //设置响应事件
    [botomStatusBar addSubview:slider];
    slider.hidden = YES;

    voiceSliderBg = [[UIView alloc] initWithFrame:CGRectMake(60 + 20, 0, screentWith - 44 - 60 - 60, 42)];
    [voiceSliderBg setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    voiceSliderBg.layer.cornerRadius = 3;
    voiceSliderBg.hidden = YES;
    [self.view addSubview:voiceSliderBg];

    voiceSlider = [[UISlider alloc] initWithFrame:CGRectMake(31 + 5, 11, voiceSliderBg.frame.size.width - 42 - 5, 20)]; //y是上面的距离
    voiceSlider.minimumValue = 0; //指定可变最小值
    voiceSlider.maximumValue = 1; //指定可变最大值
    voiceSlider.value = [[MPMusicPlayerController applicationMusicPlayer] volume];

    [voiceSlider setMinimumTrackTintColor:[UIColor r:0 g:140 b:255]];
    [voiceSlider setMaximumTrackTintColor:[UIColor r:86 g:86 b:86]];
    [voiceSlider setThumbImage:[UIImage imageNamed:@"sliderVolumn"] forState:UIControlStateNormal];
    [voiceSlider addTarget:self action:@selector(voiceSliderChange:) forControlEvents:UIControlEventValueChanged]; //设置响应事件
    [voiceSliderBg addSubview:voiceSlider];

    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(-1000, -1000, 280, 30);
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:NO];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];

    voiceIconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
    [voiceIconImgV setBackgroundColor:[UIColor clearColor]];
    voiceIconImgV.contentMode = UIViewContentModeScaleToFill;
    if (voiceSlider.value == 0) {
        voiceIconImgV.image = [UIImage imageNamed:@"novoiceIcon"];
    } else
        voiceIconImgV.image = [UIImage imageNamed:@"voiceIcon"];
    voiceIconImgV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);

    CGRect fImg = voiceIconImgV.frame;
    fImg.origin.x = 15;
    fImg.origin.y = 11;
    voiceIconImgV.frame = fImg;
    [voiceSliderBg addSubview:voiceIconImgV];

    speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speakBtn.frame = CGRectMake((bottomBgView.frame.size.width - 119) * 0.5, 8, 119, 34);
    speakBtn.layer.cornerRadius = 3;
    [speakBtn setTitle:@"发言" forState:UIControlStateNormal];
    [speakBtn addTarget:self action:@selector(changFrameReturn:) forControlEvents:UIControlEventTouchUpInside];
    [speakBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    speakBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    speakBtn.backgroundColor = [UIColor r:0 g:140 b:255];

    pauseImage = [UIImage imageNamed:@"pausescreen.png"];

    islocal = NO;

    selectedBtnTag = self.defaultVideoIndex;

    botomStatusBarVertical = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    botomStatusBarVertical.hidden = NO;
    [self.view addSubview:botomStatusBarVertical];

    downShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, botomStatusBarVertical.frame.size.width, 40)];
    downShadow.backgroundColor = [UIColor clearColor];
    downShadow.contentMode = UIViewContentModeScaleAspectFill;
    downShadow.clipsToBounds = YES;
    downShadow.image = [UIImage imageNamed:@"down_shadow_img"];
    [botomStatusBarVertical addSubview:downShadow];

    sliderVertical = [[UISlider alloc] initWithFrame:CGRectMake(40, 10, botomStatusBar.frame.size.width - 40 * 2, 10)];
    sliderVertical.minimumValue = 0; //指定可变最小值
    sliderVertical.maximumValue = 100; //指定可变最大值
    sliderVertical.value = 0; //指定初始值
    [sliderVertical setMinimumTrackTintColor:[UIColor r:55 g:196 b:0]];
    [sliderVertical setMaximumTrackTintColor:[UIColor r:86 g:86 b:86]];
    [sliderVertical setThumbImage:[UIImage imageNamed:@"sliderImg"] forState:UIControlStateNormal];
    [sliderVertical addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventValueChanged]; //设置响应事件
    [botomStatusBarVertical addSubview:sliderVertical];

    playbuttonVertical = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [playbuttonVertical setBackgroundColor:[UIColor clearColor]];
    [playbuttonVertical setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [playbuttonVertical addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [botomStatusBarVertical addSubview:playbuttonVertical];

    voiceLenghLabVertical = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 120, 20)];
    [voiceLenghLabVertical setBackgroundColor:[UIColor clearColor]];
    voiceLenghLabVertical.textColor = [UIColor r:147 g:147 b:147];
    voiceLenghLabVertical.font = [UIFont systemFontOfSize:12];
    [botomStatusBarVertical addSubview:voiceLenghLabVertical];

    changScreenFrameBtnVertical = [[UIButton alloc] initWithFrame:CGRectMake(botomStatusBar.frame.size.width - 40, 0, 40, 40)];
    [changScreenFrameBtnVertical setBackgroundColor:[UIColor clearColor]];
    [changScreenFrameBtnVertical setImage:[UIImage imageNamed:@"fullScreenIcon"] forState:UIControlStateNormal];
    [changScreenFrameBtnVertical addTarget:self action:@selector(changFrame) forControlEvents:UIControlEventTouchUpInside];
    changScreenFrameBtnVertical.hidden = YES;

    [self changFrame];

    noticeText = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentHeight, 48)];
    [noticeText setBackgroundColor:[UIColor r:0 g:140 b:255]];
    noticeText.alpha = 0.9;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 15, 15)];
    imgV.contentMode = UIViewContentModeScaleToFill; //UIViewContentModeScaleAspectFill

    [imgV setImage:[UIImage imageNamed:@"notice"]];
    [noticeText addSubview:imgV];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, screentHeight - 48 * 2, 48)];
    [noticeText addSubview:lab];
    [lab setBackgroundColor:[UIColor clearColor]];
    lab.textColor = [UIColor whiteColor];
    lab.text = @"当前网络不稳定，建议切换至标清";
    lab.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:noticeText];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screentHeight - 48, 0, 48, 48)];
    [btn setImage:[UIImage imageNamed:@"fix"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(noticeTextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [noticeText addSubview:btn];

    noticeText.hidden = YES;

    noticeText.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    CGRect f = noticeText.frame;
    f.origin.x = screentWith - 48;
    f.origin.y = 0;
    noticeText.frame = f;

    [self performSelector:@selector(resetStatusBar) withObject:nil afterDelay:15.0];

    showNoticeText = YES;

    isNetworkReachable = YES;

    noNetReachView = [[UIView alloc] initWithFrame:CGRectMake((screentHeight - 250) * 0.5, (screentWith - 100) * 0.5, 250, 100)];
    noNetReachView.layer.cornerRadius = 3;
    [noNetReachView setBackgroundColor:[UIColor whiteColor]];

    labNonet = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250 - 10, 60)];
    labNonet.textColor = [UIColor grayColor];
    labNonet.textAlignment = NSTextAlignmentCenter;
    labNonet.font = [UIFont systemFontOfSize:15];
    labNonet.numberOfLines = 0;
    [noNetReachView addSubview:labNonet];

    labNonet.text = @"网络出了点问题";

    UIView *lineNonet = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 250, 0.6)];
    [lineNonet setBackgroundColor:[UIColor grayColor]];
    [noNetReachView addSubview:lineNonet];

    UIButton *btnNonet = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 250, 40)];
    [noNetReachView addSubview:btnNonet];
    btnNonet.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btnNonet setTitle:@"确定" forState:UIControlStateNormal];
    [btnNonet setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];
    [btnNonet addTarget:self action:@selector(noNetalertBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    noNetReachView.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
    [self.view addSubview:noNetReachView];

    f = noNetReachView.frame;
    f.origin.x = (screentWith - 100) * 0.5;
    f.origin.y = (screentHeight - 250) * 0.5;
    noNetReachView.frame = f;

    noNetReachView.hidden = YES;
}

- (void)noNetalertBtnClicked {
    noNetReachView.hidden = YES;
}

- (void)outputDeviceChanged:(NSNotification *)aNotification {
    if ([pfAsset getStatus] == PF_ASSET_PLAYING &&
        [aNotification.userInfo[@"AVAudioSessionRouteChangeReasonKey"] isEqual:@2]) {
        [self startPlay];
    }
}

- (void)noticeTextBtnClicked {
    noticeText.hidden = YES;
}

- (void)updata {
    movieTitleLab.text = self.videoName;
    selectedBtnTag = self.defaultVideoIndex;

    [localbutton setTitle:self.defaultVideoQuality forState:UIControlStateNormal];

    if (self.isLive) {
        voiceTotalLenghLab.hidden = NO;
        voiceTotalLenghLab.text = [NSString stringWithFormat:@"/%@", [self timeFormatted:self.videoLength]];
        slider.hidden = NO;
    } else {
        voiceTotalLenghLab.hidden = YES;
        slider.hidden = YES;
    }
}

- (void)typeclicked:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                     initWithTitle:@"本地/在线？"
                          delegate:self
                 cancelButtonTitle:@"取消"
            destructiveButtonTitle:nil
                 otherButtonTitles:@"本地", @"在线", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)localclicked {
    spreadImgV.transform = CGAffineTransformMakeRotation(M_PI);
    [localbutton setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];
    if (resolutionSheet.superview) {
        return;
    }

    if (isFullScreen) {
        resolutionSheet = [[UIView alloc] initWithFrame:CGRectMake((screentHeight - 80) * 0.5, (screentWith - 80) * 0.5, 80, 44 * 4)];
    } else {
        resolutionSheet = [[UIView alloc] initWithFrame:CGRectMake((screentHeight - 80) * 0.5, (screentWith - 80) * 0.5, 44 * 4, 80)];
    }
    [resolutionSheet setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];

    for (int i = 0; i < self.videoList.count; i++) {
        SimplePlayerVideo *video = self.videoList[i];
        [self creatBtnBySolutionName:video.videoQuality andIndex:i];
    }

    resolutionSheet.transform = CGAffineTransformMakeRotation(M_PI * 0.5);

    CGRect f = resolutionSheet.frame;
    f.origin.y = screentHeight - 80;
    f.origin.x = screentWith - self.videoList.count * 44 - 44;
    f.size.width = self.videoList.count * 44;
    resolutionSheet.frame = f;

    [self.view addSubview:resolutionSheet];
}

- (void)actionSheetClickedButton:(UIButton *)btn {
    if (selectedBtnTag != btn.tag) {
        selectedBtnTag = btn.tag;

        videoPlayLength = slider.value;

        DLog(@"videoPlayLength = voiceLenghLab.text.floatValue ==== %f", videoPlayLength);
        [self stop];

        SimplePlayerVideo *current = self.videoList[btn.tag];

        [localbutton setTitle:current.videoQuality forState:UIControlStateNormal];
        self.videoLength = current.videoLength;
        voiceTotalLenghLab.text = [NSString stringWithFormat:@"/%@", [self timeFormatted:self.videoLength]];

        self.videoUrl = current.videoPath;

        [self playY];
    }
    [resolutionSheet removeFromSuperview];
    [localbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    spreadImgV.transform = CGAffineTransformMakeRotation(0);
}

- (void)stop {
    [pfView halt];

    // delete asset and view
    [self deleteAsset];
    [self deleteView];

    [playbutton setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [playbuttonVertical setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
}

- (void)stopBackgroundYN {
    videoPlayLength = slider.value;
    [pfView halt];

    // delete asset and view
    [self deleteAsset];
    [self deleteView];

    [playbutton setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [playbuttonVertical setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
}

- (void)startPlayActiveYN {
    if ([[NetworkUtil me] reachable]) {
        if (![[NetworkUtil me] isWIFI]) {
            [self playY];
        } else {

            labNonet.text = @"已断开无线网络，使用移动网络将可能产生流量费用";
            noNetReachView.hidden = NO;
            seekindicatorView.hidden = YES;
        }
    }
}

- (void)deleteAsset {
    if (pfAsset == nil)
        return;

    // disconnect the asset from the view
    [pfAsset setTimeMonitor:nil];
    [pfView displayAsset:nil];
    // stop and destroy the asset
    [pfAsset stop];
    pfAsset = nil;
}

- (void)deleteView {
    // stop rendering the view
    [pfView halt];

    // remove and destroy view
    [pfView removeFromSuperview];
    pfView = nil;
}

//添加一个手势
- (void)sliderUp:(UIButton *)sender {
    if (pfAsset != nil) {
        if (isFullScreen) {
            [pfAsset setTimeRange:CMTimeMakeWithSeconds(slider.value, 1000) duration:kCMTimePositiveInfinity onKeyFrame:NO];
        } else {
            [pfAsset setTimeRange:CMTimeMakeWithSeconds(sliderVertical.value, 1000) duration:kCMTimePositiveInfinity onKeyFrame:NO];
        }
    }
}

- (void)sliderDown:(id)sender {
}

- (void)onPlaybackTime:(NSTimer *)timer {
    // retrieve the playback time from an asset and update the slider
    if (pfAsset == nil)
        return;
    if ([pfAsset getStatus] != PF_ASSET_SEEKING) {
        CMTime t = [pfAsset getPlaybackTime];
        int totalSeconds = CMTimeGetSeconds(t) / 1;
        slider.value = CMTimeGetSeconds(t);
        voiceLenghLab.text = [self timeFormatted:totalSeconds];
    }
}

- (void)onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time {
}

- (void)onStatusMessage:(id<PFAsset>)asset message:(enum PFASSETMESSAGE)m {
    switch (m) {
        case PF_ASSET_SEEKING:
            DLog(@"Seeking");

            seekindicatorView.hidden = FALSE;
            break;

        case PF_ASSET_PLAYING:
            DLog(@"Playing");

            seekindicatorView.hidden = TRUE;
            CMTime t = [asset getDuration];

            DLog(@"CMTimeGetSeconds(t) === %f", CMTimeGetSeconds(t));

            if (isnan(CMTimeGetSeconds(t))) {
                slider.maximumValue = 0;
            } else {
                slider.maximumValue = CMTimeGetSeconds(t);
            }
            slider.minimumValue = 0.0;
            slider.enabled = true;
            [playbutton setImage:[UIImage imageNamed:@"pauseIcon"] forState:UIControlStateNormal];
            [playbuttonVertical setImage:[UIImage imageNamed:@"pauseIcon"] forState:UIControlStateNormal];

            if (isStartFromLabtext) {
                isStartFromLabtext = NO;
                [pfAsset setTimeRange:CMTimeMakeWithSeconds(videoPlayLength, 1000) duration:kCMTimePositiveInfinity onKeyFrame:NO];
                slider.value = videoPlayLength;
                slider.enabled = true;

                seekindicatorView.hidden = TRUE;
            }

            break;

        case PF_ASSET_PAUSED:
            DLog(@"Paused");

            seekindicatorView.hidden = YES;
            [playbutton setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
            [playbuttonVertical setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
            break;

        case PF_ASSET_COMPLETE:
            DLog(@"Complete");

            [self cancelViewController];
            break;

        case PF_ASSET_STOPPED:

            seekindicatorView.hidden = YES;
            if (isChangeVideoUrl) {
                isChangeVideoUrl = NO;
                return;
            }

            DLog(@"Stopped");
            [self stop];

            slider.value = 0;
            slider.enabled = false;

            break;

        default:
            break;
    }
}

- (void)stopButton:(UISlider *)sender {
    [self stop];
}

- (void)startPlay {
    if (![[NetworkUtil me] reachable]) {
        return;
    }
    if (pfAsset != nil) {
        [pfAsset pause];
        return;
    }

    // create a Panframe view
    [self createView];

    // create some hotspots
    [self createHotspots];

    if ([self.videoUrl isEqualToString:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择视频" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }

    // create a Panframe asset
    if (islocal) {
        [self createAssetWithUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.videoUrl ofType:@"mp4"]]];
    } else {

        [self createAssetWithUrl:[NSURL URLWithString:self.videoUrl]];
    }
}

- (void)createAssetWithUrl:(NSURL *)url {
    //    touchslider = false;

    // load an PFAsset from an url
    pfAsset = (id<PFAsset>) [PFObjectFactory assetFromUrl:url observer:(PFAssetObserver *) self];
    [pfAsset setTimeMonitor:self];

    // connect the asset to the view
    [pfView displayAsset:(PFAsset *) pfAsset];
}

- (void)createHotspots {
    // create some sample hotspots on the view and register a callback
}

- (void)createView {
    // initialize an PFView
    pfView = [PFObjectFactory viewWithFrame:[self.view bounds]];
    pfView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    // set the appropriate navigation mode PFView
    [pfView setNavigationMode:self.currentMode];

    // add the view to the current stack of views
    [self.view addSubview:pfView];
    [self.view sendSubviewToBack:pfView];

    [pfView setViewMode:self.currentMode andAspect:16.0 / 9.0];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;

    [pfView addGestureRecognizer:tap];
    [pfView run];
}

- (void)reloadView {
    CGRect f = changScreenFrameBtn.frame;
    f.origin.x = bottomBgView.frame.size.width - changScreenFrameBtn.frame.size.width;
    changScreenFrameBtn.frame = f;
    f = speakBtn.frame;
    f.origin.x = (bottomBgView.frame.size.width - 119) * 0.5;
    speakBtn.frame = f;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self resetViewParameters];
}

- (void)resetViewParameters {
    [pfView setFieldOfView:75.0f];

    // register the interface orientation with the PFView
    [pfView setInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    switch (self.interfaceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            // Wider FOV which for portrait modes (matter of taste)
            [pfView setFieldOfView:90.0f];
            break;

        default:
            break;
    }
}

- (void)singleTap:(UIGestureRecognizer *)gesture {
    [resetBarStatusTimer invalidate];
    [self resetStatusBar];

    DLog(@"!topStatusBar.hidden  =====  %d", !topStatusBar.hidden);

    if (!topStatusBar.hidden) {
        resetBarStatusTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                               target:self
                                                             selector:@selector(resetStatusBarByAutomatic)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)resetStatusBar {
    if (isFullScreen && pfView && self.videoUrl.length) {
        topStatusBar.hidden = !topStatusBar.hidden;
        botomStatusBar.hidden = !botomStatusBar.hidden;
        voiceSliderBg.hidden = !voiceSliderBg.hidden;
        [resolutionSheet removeFromSuperview];
        spreadImgV.transform = CGAffineTransformMakeRotation(0);
        localbutton.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)resetStatusBarByAutomatic {
    if (isFullScreen && !topStatusBar.hidden && pfView && self.videoUrl.length) {
        topStatusBar.hidden = !topStatusBar.hidden;
        botomStatusBar.hidden = !botomStatusBar.hidden;
        voiceSliderBg.hidden = !voiceSliderBg.hidden;
        [resolutionSheet removeFromSuperview];
        spreadImgV.transform = CGAffineTransformMakeRotation(0);
        localbutton.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)voiceSliderChange:(UISlider *)sender {
    if (voiceSlider != nil) {
        [self volumeAdd:voiceSlider.value];
    }
    if (voiceSlider.value == 0) {
        voiceIconImgV.image = [UIImage imageNamed:@"novoiceIcon"];
    } else {
        voiceIconImgV.image = [UIImage imageNamed:@"voiceIcon"];
    }
}

- (void)changFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changFrameBtnClicked)]) {
        isFullScreen = YES;
        botomStatusBarVertical.hidden = YES;
        botomStatusBar.hidden = NO;
        voiceSliderBg.hidden = NO;
        topStatusBar.hidden = NO;
        [self.delegate changFrameBtnClicked];
    }
}

- (void)changFrameReturn:(UIButton *)btn {

    if (self.delegate && [self.delegate respondsToSelector:@selector(changFrameBtnClicked)]) {
        isFullScreen = NO;
        botomStatusBarVertical.hidden = NO;
        botomStatusBar.hidden = YES;
        voiceSliderBg.hidden = YES;
        topStatusBar.hidden = YES;
        [self.delegate changFrameBtnClicked];
    }
}

- (void)playY {

    [self createView];

    // create some hotspots
    [self createHotspots];

    if ([self.videoUrl isEqualToString:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择视频" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }

    if (islocal) {
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:self.videoUrl ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        [self createAssetWithUrl:url];
    } else {
        [self createAssetWithUrl:[NSURL URLWithString:self.videoUrl]];
    }

    if ([pfAsset getStatus] == PF_ASSET_ERROR) {
        [self stop];
    } else {
        [pfAsset play];
        isChangeVideoUrl = YES;
        isStartFromLabtext = YES;
        NSLog(@"lab.text.floatValue = %f", voiceLenghLab.text.floatValue);
    }
}

- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (void)cancelViewController {
    [slidertimer invalidate];
    [speedTimer invalidate];
    [resetBarStatusTimer invalidate];

    [self stop];
    [appDelegate popViewControllerAnimated:NO];
}

- (void)creatBtnBySolutionName:(NSString *)solutionName andIndex:(NSInteger)index {
    UIButton *standardDefinition = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * index, resolutionSheet.frame.size.width, 44)];
    standardDefinition.tag = index;
    standardDefinition.titleLabel.font = [UIFont systemFontOfSize:16];
    [standardDefinition setTitle:solutionName forState:UIControlStateNormal];

    if (selectedBtnTag == index) {
        [standardDefinition setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];
    } else {
        [standardDefinition setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    [standardDefinition addTarget:self action:@selector(actionSheetClickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [resolutionSheet addSubview:standardDefinition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [slidertimer invalidate];
    [speedTimer invalidate];
    [resetBarStatusTimer invalidate];
}

- (void)checkPlayStatus {
    if (topStatusBar.hidden) {
        if (resolutionSheet.superview) {
            [resolutionSheet removeFromSuperview];
            spreadImgV.transform = CGAffineTransformMakeRotation(0);
        }
    }

    if ([pfAsset getStatus] == 0) { // 未播放
        return;
    }

    if ([pfAsset getStatus] == PF_ASSET_PAUSED) { // 已经暂停
        return;
    }

    if ([pfAsset getStatus] == PF_ASSET_STOPPED) { // 已经停止
        return;
    }

    CMTime t = [pfAsset getPlaybackTime];
    float playbackTime = CMTimeGetSeconds(t); // 当前播放时间
    if (lastPlayTime == -1) { // 开始播放
        lastPlayTime = playbackTime;
    } else if (playbackTime == lastPlayTime) { // 缓冲状态
        if (!startBufferTime) { // 缓冲开始计时
            startBufferTime = [NSDate date];
        }

        if (![[NetworkUtil me] reachable] && isNetworkReachable) {
            isNetworkReachable = NO;
            labNonet.text = @"网络出了点问题";
            noNetReachView.hidden = NO;
            seekindicatorView.hidden = YES;
        }

        if ([[NetworkUtil me] reachable] && noNetReachView.hidden) {
            isNetworkReachable = YES;
            seekindicatorView.hidden = NO;
        }

        int bufferSecond = (int) (-[startBufferTime timeIntervalSinceNow] + 1.1); // 计算缓冲的时长

        if (bufferSecond > 10) {
            if (showNoticeText) {
                showNoticeText = NO;
                if (![localbutton.titleLabel.text isEqualToString:@"标清"] && pfView && self.videoUrl.length) {
                    noticeText.hidden = NO;
                }
            }
        }

        // do something when player is buffering
    } else { // 播放状态
        seekindicatorView.hidden = YES;
        lastPlayTime = playbackTime; // 记录上1秒播放的时间
        startBufferTime = nil; // 播放的时候重置缓冲开始的时间
        // do something when player is playing
    }
}

- (void)volumeAdd:(CGFloat)step {
    [MPMusicPlayerController applicationMusicPlayer].volume = step;
}

- (void)volumeChanged:(NSNotification *)noti {
    float volume = [[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];

    voiceSlider.value = volume;

    if (volume == 0) {
        voiceIconImgV.image = [UIImage imageNamed:@"novoiceIcon"];
    } else {
        voiceIconImgV.image = [UIImage imageNamed:@"voiceIcon"];
    }
}

- (void)reachablityChangedWWAN:(NSNotification *)noti {
    if ([pfAsset getStatus] != 0) {
        if (pfAsset != nil) {
            [pfAsset pause];
        }
        labNonet.text = @"已断开无线网络，使用移动网络将可能产生流量费用";
        noNetReachView.hidden = NO;
        seekindicatorView.hidden = YES;
    }
}

@end
