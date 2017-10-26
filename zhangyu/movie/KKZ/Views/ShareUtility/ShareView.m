//
//  ShareView.m
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "InputContentShareViewController.h"
#import "RoundCornersButton.h"
#import "ShareView.h"
#import "UIConstants.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <QuartzCore/QuartzCore.h>

#import "CommonViewController.h"
#import "DataManager.h"
#import "KKZUtility.h"
#import "StatisticsComponent.h"

#define CHeight 50

@interface ShareView ()

@property (nonatomic, assign) PopViewAnimation popViewAnimation;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentWeChat;
@property (nonatomic, strong) NSString *contentQQSpace;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *sUrl;
@property (nonatomic, assign) int mediaType;

@property (nonatomic, assign) StatisticsType statisticsType;
@property (nonatomic, strong) NSString *shareInfo;
@property (nonatomic, strong) UILabel *titleLabel;

/**
 选择后自动隐藏：使用show()显示时，选择后默认自动消失
 */
@property (nonatomic) BOOL autoHidden;

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation ShareView {

    UIControl *_overlayView;
    ShareType shareType;

    CGRect weixinFRect, weixinRect, sinaWeiboRect, qqWeiboRect, renrenRect, qZoneRect, cancelRect;
}

- (void)dealloc {
    DLog(@"ShareView dealloc");
}

- (id)initWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    self = [super initWithFrame:frame];

    if (self) {
        [self defalutInit];
        self.isScore = NO;
    }
    return self;
}

- (void)defalutInit {

    self.clipsToBounds = TRUE;
    self.popViewAnimation = PopViewAnimationSwipeD2U;
    //微信朋友圈 微信  新浪微博  腾讯微博  qq空间  人人网
    UIView *showBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 200)];
    showBg.backgroundColor = [UIColor r:245 g:245 b:245];
    [self addSubview:showBg];

    // 左边线
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(15, 25, (screentWith - 15 * 2 - 120) * 0.5, 1)];
    leftLine.backgroundColor = kUIColorDivider;
    [showBg addSubview:leftLine];

    // 右边线
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(screentWith - (screentWith - 15 * 2 - 120) * 0.5 - 15, 25, (screentWith - 15 * 2 - 120) * 0.5, 1)];
    rightLine.backgroundColor = kUIColorDivider;
    [showBg addSubview:rightLine];

    // title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - 15 * 2 - 120) * 0.5 + 15, 15, 120, 20)];
    self.titleLabel = titleLbl;
    if (self.frame.origin.y == 0) {
        titleLbl.text = @"炫耀一下";
    } else
        titleLbl.text = @"分享给好友";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor r:50 g:50 b:50];
    titleLbl.font = [UIFont systemFontOfSize:kTextSizeTitle];
    [showBg addSubview:titleLbl];

    CGFloat marginY = (screentWith - 10 * 2 - 75 * 4) / 3;

    qZoneRect = CGRectMake(10, 52, 75, 60);
    UIImageView *qqZoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 52, 44, 44)];
    qqZoneIcon.image = [UIImage imageNamed:@"logoQzoneIcon"];
    [showBg addSubview:qqZoneIcon];

    UILabel *qZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 102, 75, 12)];
    qZoneLabel.text = @"QQ空间";
    qZoneLabel.backgroundColor = [UIColor clearColor];
    qZoneLabel.textAlignment = NSTextAlignmentCenter;
    qZoneLabel.font = [UIFont systemFontOfSize:11];
    qZoneLabel.textColor = [UIColor r:100 g:100 b:100];
    [showBg addSubview:qZoneLabel];

    weixinFRect = CGRectMake(85 + marginY, 52, 75, 60);
    UIImageView *weixinFIcon = [[UIImageView alloc] initWithFrame:CGRectMake(100.5 + marginY, 52, 44, 44)];
    weixinFIcon.image = [UIImage imageNamed:@"logoWechatMomentsIcon"];
    [showBg addSubview:weixinFIcon];

    UILabel *weixinFLabel = [[UILabel alloc] initWithFrame:CGRectMake(85 + marginY, 102, 75, 12)];
    weixinFLabel.text = @"朋友圈";
    weixinFLabel.backgroundColor = [UIColor clearColor];
    weixinFLabel.textAlignment = NSTextAlignmentCenter;
    weixinFLabel.font = [UIFont systemFontOfSize:11];
    weixinFLabel.textColor = [UIColor r:100 g:100 b:100];
    [showBg addSubview:weixinFLabel];

    weixinRect = CGRectMake(175.5 + marginY * 2, 52, 75, 60);
    UIImageView *weixinIcon = [[UIImageView alloc] initWithFrame:CGRectMake(175.5 + marginY * 2, 52, 44, 44)];
    weixinIcon.image = [UIImage imageNamed:@"logoWechatIcon"];
    [showBg addSubview:weixinIcon];

    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(160 + marginY * 2, 102, 75, 12)];
    weixinLabel.text = @"微信";
    weixinLabel.backgroundColor = [UIColor clearColor];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.font = [UIFont systemFontOfSize:11];
    weixinLabel.textColor = [UIColor r:100 g:100 b:100];
    [showBg addSubview:weixinLabel];

    sinaWeiboRect = CGRectMake(250.5 + marginY * 3, 52, 75, 60);
    UIImageView *weiboIcon = [[UIImageView alloc] initWithFrame:CGRectMake(250.5 + marginY * 3, 52, 44, 44)];
    weiboIcon.image = [UIImage imageNamed:@"logoSinaIcon"];
    [showBg addSubview:weiboIcon];

    UILabel *sinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(235 + marginY * 3, 102, 75, 12)];
    sinaWeiboLabel.text = @"新浪微博";
    sinaWeiboLabel.backgroundColor = [UIColor clearColor];
    sinaWeiboLabel.textAlignment = NSTextAlignmentCenter;
    sinaWeiboLabel.font = [UIFont systemFontOfSize:11];
    sinaWeiboLabel.textColor = [UIColor r:100 g:100 b:100];
    [showBg addSubview:sinaWeiboLabel];

    cancelRect = CGRectMake(20, 135, screentWith - 20 * 2, 40);
    RoundCornersButton *cancelBtn = [[RoundCornersButton alloc] initWithFrame:cancelRect];
    cancelBtn.backgroundColor = [UIColor r:240 g:240 b:240];
    cancelBtn.fillColor = [UIColor r:240 g:240 b:240];
    cancelBtn.cornerNum = kDimensCornerNum;
    cancelBtn.enabled = NO;
    cancelBtn.titleName = @"取消分享";
    cancelBtn.titleColor = [UIColor r:100 g:100 b:100];
    cancelBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    [showBg addSubview:cancelBtn];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];

    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [[UIColor blackColor] alpha:.5];
    [_overlayView addTarget:self
                      action:@selector(dismiss)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateWithcontent:(NSString *)content
            contentWeChat:(NSString *)contentWeChat
           contentQQSpace:(NSString *)contentQQSpace
                    title:(NSString *)title
                imagePath:(UIImage *)image
                 imageURL:(NSString *)imageURL
                      url:(NSString *)url
                 soundUrl:(NSString *)sUrl
                 delegate:(id)delegate
                mediaType:(SSPublishContentMediaType)mediaType
           statisticsType:(StatisticsType)stype
                shareInfo:(NSString *)si
                sharedUid:(NSString *)uid {

    self.content = content;
    self.contentWeChat = contentWeChat;
    self.contentQQSpace = contentQQSpace;
    self.title = title;
    self.image = image;
    self.url = url;
    self.sUrl = sUrl;
    self.delegate = delegate;
    self.mediaType = mediaType;
    self.imageURL = imageURL;
    self.statisticsType = stype;

    [DataManager shareDataManager].statisticsType = stype;
    [DataManager shareDataManager].shareInfo = si;
    [DataManager shareDataManager].sharedUid = uid;
    [DataManager shareDataManager].isStatistics = YES;
}

- (void)updateWithcontent:(NSString *)content
            contentWeChat:(NSString *)contentWeChat
           contentQQSpace:(NSString *)contentQQSpace
                    title:(NSString *)title
                imagePath:(UIImage *)image
                      url:(NSString *)url
                 soundUrl:(NSString *)sUrl
                 delegate:(id)delegate
                mediaType:(SSPublishContentMediaType)mediaType
           statisticsType:(StatisticsType)stype {

    self.content = content;
    self.contentWeChat = contentWeChat;
    self.contentQQSpace = contentQQSpace;
    self.title = title;
    self.image = image;
    self.url = url;
    self.sUrl = sUrl;
    self.delegate = delegate;
    self.mediaType = mediaType;
    self.statisticsType = stype;

    [DataManager shareDataManager].isStatistics = NO;
}

- (void)showShareController {
    InputContentShareViewController *ctr =
            [[InputContentShareViewController alloc] initWithTitle:self.title
                                                           content:self.content
                                                             image:self.image
                                                               url:self.url
                                                              sUrl:self.sUrl
                                                         mediaType:self.mediaType
                                                         shareType:shareType];
    
    ctr.imageURL = self.imageURL;

    ctr.movieId = self.movieId.intValue;

    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

- (NSString *)getEventNameByStatisType {
    if (self.statisticsType == StatisticsTypeMovie) {
        return EVENT_SHARE_MOVIE;
    } else if (self.statisticsType == StatisticsTypeCinema) {
        return EVENT_SHARE_CINEMA;
    } else if (self.statisticsType == StatisticsTypeOrder) {
        return EVENT_SHARE_ORDER;
    } else if (self.statisticsType == StatisticsTypePrivilege) {
        return EVENT_SHARE_PRIVILEGE;
    } else if (self.statisticsType == StatisticsTypeSnsPoster) { //已有
        return EVENT_SHARE_SNS_POSTER;
    } else if (self.statisticsType == StatisticsTypeSubscriber) {
        return EVENT_SHARE_SUBSCRIBER;
    }
    return @"";
}

- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(sinaWeiboRect, point)) { //新浪微博
        //统计事件：分享
        StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"SinaWeibo" });

        shareType = ShareTypeSinaWeibo;
        
        [self showShareController];

    } else if (CGRectContainsPoint(weixinRect, point)) { //微信朋友圈
        //统计事件：分享
        StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"WechatMoments" });

        if (self.imageURL.length) {
            [[ShareEngine shareEngine] shareToWeiXin:self.contentWeChat
                                               title:self.title
                                            imageUrl:self.imageURL
                                                 url:self.url
                                            soundUrl:self.sUrl
                                            delegate:self.delegate
                                           mediaType:self.mediaType
                                                type:ShareTypeWeixiSession];
        } else {
            [[ShareEngine shareEngine] shareToWeiXin:self.contentWeChat
                                               title:self.title
                                               image:self.image
                                                 url:self.url
                                            soundUrl:self.sUrl
                                            delegate:self.delegate
                                           mediaType:self.mediaType
                                                type:ShareTypeWeixiSession];
        }

    } else if (CGRectContainsPoint(weixinFRect, point)) { //微信好友
        //统计事件：分享
        StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"Wechat" });

        if (self.imageURL.length) {
            [[ShareEngine shareEngine] shareToWeiXin:self.contentWeChat
                                               title:self.contentWeChat
                                            imageUrl:self.imageURL
                                                 url:self.url
                                            soundUrl:self.sUrl
                                            delegate:self.delegate
                                           mediaType:self.mediaType
                                                type:ShareTypeWeixiTimeline];
        } else {
            [[ShareEngine shareEngine] shareToWeiXin:self.contentWeChat
                                               title:self.contentWeChat
                                               image:self.image
                                                 url:self.url
                                            soundUrl:self.sUrl
                                            delegate:self.delegate
                                           mediaType:self.mediaType
                                                type:ShareTypeWeixiTimeline];
        }

    } else if (CGRectContainsPoint(qZoneRect, point)) { //QQ空间
        //统计事件：分享
        StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"QQZone" });

        shareType = ShareTypeQQSpace;
        if (self.imageURL.length) {
            [[ShareEngine shareEngine] shareToQZone:self.contentQQSpace
                                              title:self.title
                                           imageUrl:self.imageURL
                                           imageURL:self.imageURL
                                                url:self.url
                                           delegate:self.delegate
                                          mediaType:self.mediaType
                                               type:ShareTypeQQSpace];
        } else
            [[ShareEngine shareEngine] shareToQZone:self.contentQQSpace
                                              title:self.title
                                              image:self.image
                                           imageURL:self.imageURL
                                                url:self.url
                                           delegate:self.delegate
                                          mediaType:self.mediaType
                                               type:ShareTypeQQSpace];

    } else if (CGRectContainsPoint(cancelRect, point)) {
        [self dismiss];
        return;
    }

    if (self.autoHidden == YES) {
        [self dismiss];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

#pragma mark - animations
- (void)fadeIn {
    if (self.popViewAnimation == PopViewAnimationNone) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35
                         animations:^{
                             self.alpha = 1;
                             self.transform = CGAffineTransformMakeScale(1, 1);
                         }];
    } else if (self.popViewAnimation == PopViewAnimationBounce) {
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        [UIView animateWithDuration:.35
                         animations:^{
                             self.alpha = 1;
                             self.transform = CGAffineTransformMakeScale(1, 1);
                         }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(-screentWith, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35
                         animations:^{
                             self.frame = popFrame;
                         }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(screentWith + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35
                         animations:^{
                             self.frame = popFrame;
                         }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationSwipeD2U--%@\n", NSStringFromCGRect(self.frame));
        self.frame = CGRectMake(popFrame.origin.x, 460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35
                         animations:^{
                             self.frame = popFrame;
                         }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(popFrame.origin.x, -460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35
                         animations:^{
                             self.frame = popFrame;
                         }];
    } else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationActionSheet--%@\n", NSStringFromCGRect(self.frame));

        self.frame = CGRectMake(popFrame.origin.x, 460, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35
                         animations:^{
                             self.frame = popFrame;
                         }];
    }
}
- (void)fadeOut {
    if (self.popViewAnimation == PopViewAnimationNone) {
        [UIView animateWithDuration:.35
                animations:^{
                    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationBounce) {
        [UIView animateWithDuration:.35
                animations:^{
                    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        [UIView animateWithDuration:.35
                animations:^{
                    CGRect popFrame = self.frame;
                    self.frame = CGRectMake(-screentWith, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        [UIView animateWithDuration:.35
                animations:^{
                    CGRect popFrame = self.frame;
                    self.frame = CGRectMake(screentWith + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        [UIView animateWithDuration:.35
                animations:^{
                    CGRect popFrame = self.frame;
                    self.frame = CGRectMake(popFrame.origin.x, 460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        [UIView animateWithDuration:.35
                animations:^{
                    CGRect popFrame = self.frame;
                    self.frame = CGRectMake(popFrame.origin.x, -460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
                    self.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    } else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        [UIView animateWithDuration:.35
                animations:^{
                    CGRect popFrame = self.frame;
                    self.frame = CGRectMake(popFrame.origin.x, screentHeight, popFrame.size.width, popFrame.size.height);
                    self.alpha = 0.3;
                    _overlayView.alpha = 0;
                }
                completion:^(BOOL finished) {
                    if (finished) {
                        [_overlayView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
    }
}

- (void)show {
    self.autoHidden = YES;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [self fadeIn];
}

- (void)dismiss {
    [self fadeOut];

    if (self.delegateY && [self.delegateY respondsToSelector:@selector(hideCoverView)]) {
        [self.delegateY hideCoverView];
    }
}

#define mark -UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // tell the delegate the cancellation
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListViewCancel:)]) {
    //        [self.delegate popoverListViewCancel:self];
    //    }

    // dismiss self
    
    if (self.autoHidden == YES) {
        [self dismiss];
    }
    
}

@end
