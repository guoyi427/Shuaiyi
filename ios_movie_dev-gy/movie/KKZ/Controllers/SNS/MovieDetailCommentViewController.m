//
//  MovieDetailCommentViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieDetailCommentViewController.h"
#import "KKZUtility.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Hex.h"
#import "CustomTextView.h"
#import "KKZWaveformPlayerView.h"
#import "MovieCommentData.h"
#import "DataEngine.h"

/************文本输入框的尺寸***************/
static const CGFloat textViewLeft = 15.0f;
static const CGFloat textViewTop = 15.0f;

/************预览视图的尺寸***************/
static const CGFloat preViewWidth = 120.0f;
static const CGFloat preViewHeight = 90.0f;
static const CGFloat preViewTop = 15.0f;
static const CGFloat preViewRight = 15.0f;

/**************左导航栏视图*******************/
static const CGFloat closeButtonOriginX = 15.0f;
static const CGFloat closeButtonOriginY = 13.0f;
static const CGFloat closeButtonWidth = 17.0f;

/**************右导航栏视图*******************/
static const CGFloat submitButtonRight = 15.0f;
static const CGFloat submitButtonWidth = 30.0f;

/**************重新拍摄视图*******************/
static const CGFloat againButtonWidth = 120.0f;
static const CGFloat againButtonHeight = 35.0f;
static const CGFloat againButtonTop = 10.0f;

@interface MovieDetailCommentViewController () <AVAudioPlayerDelegate> {

    //视频播放器控制器
    MPMoviePlayerController *player;

    //音乐波形
    KKZWaveformPlayerView *playerView;
}

/**
 *  用户的评论
 */
@property (nonatomic, strong) CustomTextView *textView;

/**
 *  附件Id数组
 */
@property (nonatomic, strong) NSMutableArray *attachIdArray;

/**
 *  需要重新播放视频
 */
@property (nonatomic, assign) BOOL needPlayVideo;
@end

@implementation MovieDetailCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载导航条
    [self loadNavBar];
    //预览页面
    [self loadPreView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //当前显示的类型
   if (self.type == chooseTypeAudio) {
        [playerView stopAudioPlayer];
    }
}


- (void)loadNavBar {

    //视图背景
    self.view.backgroundColor = [UIColor whiteColor];

    //导航栏背景
    self.navBarView.backgroundColor = [UIColor colorWithHex:@"#191821"];
    self.kkzTitleLabel.text = @"发表内容";
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
    self.kkzTitleLabel.textColor = [UIColor whiteColor];

    //左导航按钮
    UIImage *closeImg = [UIImage imageNamed:@"loginCloseButton"];
    UIButton *closelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closelButton.frame = CGRectMake(0.0f, 0.0f, closeButtonWidth + closeButtonOriginX * 2, closeButtonWidth + closeButtonOriginY * 2);
    closelButton.backgroundColor = [UIColor clearColor];
    [closelButton setImage:closeImg forState:UIControlStateNormal];
    [closelButton setImageEdgeInsets:UIEdgeInsetsMake(closeButtonOriginY, closeButtonOriginX, closeButtonOriginY, closeButtonOriginX)];
    closelButton.tag = MovieCommentCloseButtonTag;
    [closelButton addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:closelButton];

    //右按钮
    UIButton *submitButton = [UIButton buttonWithType:0];
    CGFloat totalWidth = submitButtonWidth + 2 * submitButtonRight;
    submitButton.frame = CGRectMake(kCommonScreenWidth - totalWidth, 0, totalWidth, CGRectGetHeight(self.navBarView.frame));
    [submitButton setTitle:@"提交"
                  forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [submitButton setTitleColor:[UIColor colorWithHex:@"#f9c452"]
                       forState:UIControlStateNormal];
    submitButton.tag = submitButtonTag;
    [submitButton addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:submitButton];
}

- (void)loadPreView {

    //重新拍摄按钮
    UIButton *takeButton = [UIButton buttonWithType:0];
    takeButton.frame = CGRectMake(kCommonScreenWidth - preViewWidth - preViewRight, CGRectGetMaxY(self.navBarView.frame) + preViewTop + preViewHeight + againButtonTop, againButtonWidth, againButtonHeight);
    takeButton.layer.borderWidth = 0.3f;
    takeButton.layer.borderColor = [UIColor colorWithHex:@"#191821"].CGColor;
    [takeButton setTitleColor:[UIColor colorWithHex:@"#191821"]
                     forState:UIControlStateNormal];
    [takeButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    takeButton.layer.cornerRadius = 5.0f;
    takeButton.layer.masksToBounds = YES;
    [takeButton addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeButton];

    //当前显示的类型
    if (self.type == chooseTypeAudio) {

        //得到MP3的解压路径
        NSString *mp3FileName = [audioOutputPath lastPathComponent];
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [audioTemporarySavePath stringByAppendingPathComponent:mp3FileName];

        //获取到MP3的相关信息
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:mp3FilePath]
                                                    options:nil];

        //初始化MP3的波形图
        CGRect playerViewFrame = CGRectMake(kCommonScreenWidth - preViewWidth - preViewRight, CGRectGetMaxY(self.navBarView.frame) + preViewTop, preViewWidth, preViewHeight);
        playerView = [[KKZWaveformPlayerView alloc] initWithFrame:playerViewFrame
                                                            asset:asset
                                                            color:[UIColor lightGrayColor]
                                                    progressColor:[UIColor redColor]];
        playerView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:playerView];

        //录音按钮
        UIImage *videoImg = [UIImage imageNamed:@"movieComment_again_record"];
        [takeButton setTitle:@"重新录制"
                    forState:UIControlStateNormal];
        [takeButton setImage:videoImg
                    forState:UIControlStateNormal];
        [takeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.0f)];
        takeButton.tag = againVideoButtonTag;
    }

    //添加输入框图文：晒观影心情~关于 用户名 在看过《影片名》的照片秀来啦！
    self.textView.customText = [[MovieCommentData sharedInstance] getCommentContentWithType:self.type];
    [self.view addSubview:self.textView];
}

/**
 *  视频播放完成通知
 *
 *  @param notify
 */
- (void)movieFinishBack:(NSNotification *)notify {

    //视频的当前播放时间清0
    player.currentPlaybackTime = 0.0f;

    //播放视频
    [self startPlayerVideo];
}

- (void)routeChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable || changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        //        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        //        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //        //原设备为耳机则暂停
        //        if ([portDescription.portType isEqualToString:@"Headphones"]) {
        //
        //        }
        [self startPlayerVideo];
    }
}


- (void)startPlayerVideo {
    [player play];
}

- (void)stopPlayerVideo {
    [player stop];
}

- (void)uploadAudioAndVideoFileToServer {

    //发表视频请求
    ClubRequest *request = [ClubRequest new];
    if (self.type == chooseTypeAudio) {
        NSString *mp3FileName = [audioOutputPath lastPathComponent];
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [audioTemporarySavePath stringByAppendingPathComponent:mp3FileName];
        NSData *audioData = [NSData dataWithContentsOfFile:mp3FilePath];
        NSArray *dataArray = [[NSArray alloc] initWithObjects:audioData,nil];
        
        [request uploadAudio:dataArray success:^(NSArray * _Nullable attaches) {
            [self.attachIdArray addObjectsFromArray:attaches];
            [self sendMediaPost];
        } failure:^(NSError * _Nullable err) {
             [self requestFail];
        }];
    }
}

- (void)requestFail {
    [KKZUtility hidenIndicator];
    [KKZUtility showAlertTitle:@"上传失败，请重试"
                        detail:@""
                        cancel:@"确定"
                     clickCall:nil
                        others:nil];
}

- (void)uploadImageFileToServer {

    //加载框
    [KKZUtility showIndicatorWithTitle:@"正在发表"
                                atView:self.view.window];

    if(self.type == chooseTypeAudio) {
        [self uploadAudioAndVideoFileToServer];
    }
}

- (void)sendMediaPost {
    //发布帖子
    ClubRequest *request = [ClubRequest new];
    
    NSInteger type = 0;
    
    switch (self.type) {
        case chooseTypeImageAndWord:
            type = 1;
            break;
        case chooseTypeAudio:
            type = 2;
            break;
            
        default:
            break;
    }
    
    [request requestCreatArticle:type content:self.textView.text attaches:self.attachIdArray success:^(ClubPost * _Nullable post) {
        
        [KKZUtility hidenIndicator];
        
        [self joinMovieCommentSuccessWithArticle:post];
        
    } failure:^(NSError * _Nullable err) {
        [KKZUtility hidenIndicator];
        [KKZUtility showAlertTitle:@"发表帖子失败,请重试"
                            detail:@""
                            cancel:@"确定"
                         clickCall:nil
                            others:nil];
    }];
    
    
}

- (void)joinMovieCommentSuccessWithArticle:(ClubPost *)article {
    
    //统计事件：发表帖子
    NSString *typeName =  @"语音";
    StatisEventWithAttributes(EVENT_SNS_PUBLISH_POSTER, @{ @"type" : typeName });

    //进入到电影评论成功页面
    MovieCommentSuccessViewController *ctr = [[MovieCommentSuccessViewController alloc] init];
    ctr.pageFrom = joinCurrentPageFromCamera;
    ctr.clubPost = article;
    [self pushViewController:ctr
                     animation:CommonSwitchAnimationFlipL];
}

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL
                                                options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 2)
                                                    actualTime:NULL
                                                         error:&thumbnailImageGenerationError];

    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}

#pragma mark - getter Method

- (CustomTextView *)textView {
    if (!_textView) {
        _textView = [[CustomTextView alloc] initWithFrame:CGRectMake(textViewLeft, textViewTop + CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth - preViewWidth - preViewRight - 2 * textViewLeft, preViewHeight + againButtonTop + againButtonHeight)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeHoder = @"说说你的想法吧...";
        _textView.font = [UIFont systemFontOfSize:15.0f];
        [_textView becomeFirstResponder];
    }
    return _textView;
}

- (NSMutableArray *)attachIdArray {
    if (!_attachIdArray) {
        _attachIdArray = [[NSMutableArray alloc] init];
    }
    return _attachIdArray;
}

#pragma mark - View pulic Method

- (void)commonBtnClick:(UIButton *)sender {

    switch (sender.tag) {
        case MovieCommentCloseButtonTag: {
            //取消键盘响应
            [self.textView resignFirstResponder];
            //弹出加载框
            [KKZUtility showAlertTitle:@"是否关闭此页面"
                                detail:@""
                                cancel:@"取消"
                             clickCall:^(NSInteger buttonIndex) {
                                 if (buttonIndex == 1) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification object:nil];
                                 } else if (buttonIndex == 0) {
                                     [self.textView becomeFirstResponder];
                                 }
                             }
                                others:@"关闭"];
            break;
        }
        case againVideoButtonTag: {
            //取消键盘响应
            [self.textView resignFirstResponder];
            //弹出加载框
            [KKZUtility showAlertTitle:@"是否放弃当前编辑内容?"
                                detail:@""
                                cancel:@"否"
                             clickCall:^(NSInteger buttonIndex) {
                                 if (buttonIndex == 1) {
                                     [self popViewControllerAnimated:YES];
                                 } else if (buttonIndex == 0) {
                                     [self.textView becomeFirstResponder];
                                 }
                             }
                                others:@"确定"];
            break;
        }
        case submitButtonTag: {

            //取消键盘
            [self.textView resignFirstResponder];

            //判断上传字符串是否为空
            if ([KKZUtility inputStringIsEmptyWith:self.textView.text]) {
                [KKZUtility showAlertTitle:@"提示"
                                    detail:@"内容不能为空"
                                    cancel:@"重新填写"
                                 clickCall:nil
                                    others:nil];
                return;
            }

            //上传数据钱先清空数据源
            [self.attachIdArray removeAllObjects];

            //上传视频的其中一帧数据到服务器
            [self uploadImageFileToServer];
            break;
        }
        default:
            break;
    }
}

- (BOOL)showBackButton {
    return FALSE;
}

- (void)dealloc {
    //停止视频播放
    if (self.type == chooseTypeAudio) {
        [playerView stopAudioPlayer];
    }
    //移除掉视频播放完成的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
