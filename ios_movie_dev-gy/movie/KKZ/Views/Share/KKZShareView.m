//
//  KKZShareView.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZShareView.h"
#import "ThirdPartLoginEngine.h"

/***************显示的背景视图***********/
static const CGFloat showBackViewHeight = 200.0f;

/***************背景视图左边线************/
static const CGFloat leftLineViewLeft = 15.0f;
static const CGFloat leftLineViewTop = 25.0f;
static const CGFloat leftLineViewHeight = 1.0f;

/***************背景视图标题************/
static const CGFloat titleLabelWidth = 120.0f;
static const CGFloat titleLabelHeight = 20.0f;
static const CGFloat titleLabelTop = 15.0f;
static const CGFloat titleLabelFont = 14.0f;

/**************qq按钮************/
static const CGFloat QQButtonTop = 52.0f;
static const CGFloat QQButtonWidth = 44.0f;
static const CGFloat QQButtonHeight = 44.0f;

/**************qq文字************/
static const CGFloat QQLabelHeight = 12.0f;
static const CGFloat QQLabelTop = 6.0f;

/*************取消分享按钮************/
static const CGFloat cancelShareButtonLeft = 20.0f;
static const CGFloat cancelShareButtonHeight = 40.0f;
static const CGFloat cancelShareButtonTop = 135.0f;
static const CGFloat cancelShareButtonFont = 14.0f;

typedef enum : NSUInteger {
    cancelShareButtonTag = 1000,
    qqButtonTag,
    friendButtonTag,
    weixinButtonTag,
    weiboButtonTag
} allButtonTag;

@interface KKZShareView ()

/**
 *  显示的视图
 */
@property (nonatomic, strong) UIView *showBackView;

/**
 *  左边线视图
 */
@property (nonatomic, strong) UIView *leftLineView;

/**
 *  右边线视图
 */
@property (nonatomic, strong) UIView *rightLineView;

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  QQ空间按钮
 */
@property (nonatomic, strong) UIButton *qqButton;

/**
 *  取消收藏按钮
 */
@property (nonatomic, strong) UIButton *cancelShareButton;

/**
 *  第三方登录引擎
 */
@property (nonatomic, strong) ThirdPartLoginEngine *thirdPartLoginEngine;

@end

@implementation KKZShareView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //背景颜色
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

        //添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hiden)];
        [self addGestureRecognizer:tap];

        //添加显示的视图
        [self addSubview:self.showBackView];

        //添加标题视图
        [self.showBackView addSubview:self.titleLabel];

        //添加左边线
        [self.showBackView addSubview:self.leftLineView];

        //添加右边线
        [self.showBackView addSubview:self.rightLineView];

        //添加分享视图
        [self loadShareButtons];

        //取消分享按钮
        [self.showBackView addSubview:self.cancelShareButton];
    }
    return self;
}

- (void)loadShareButtons {
    NSArray *titleArr = @[ @"QQ空间", @"朋友圈", @"微信", @"新浪微博" ];
    NSArray *imgArr = @[ @"logoQzoneIcon", @"logoWechatMomentsIcon", @"logoWechatIcon", @"logoSinaIcon" ];
    CGFloat leftMargin = (CGRectGetWidth(self.frame) - titleArr.count * QQButtonWidth) / (titleArr.count + 1);
    CGFloat left = leftMargin;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(left, QQButtonTop, QQButtonWidth, QQButtonHeight);
        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]]
                          forState:UIControlStateNormal];
        btn.tag = qqButtonTag + i;
        [btn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.showBackView addSubview:btn];

        UILabel *weixinFLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, CGRectGetMaxY(btn.frame) + QQLabelTop, QQButtonWidth, QQLabelHeight)];
        weixinFLabel.text = titleArr[i];
        weixinFLabel.backgroundColor = [UIColor clearColor];
        weixinFLabel.textAlignment = NSTextAlignmentCenter;
        weixinFLabel.font = [UIFont systemFontOfSize:11];
        weixinFLabel.textColor = [UIColor r:100 g:100 b:100];
        [self.showBackView addSubview:weixinFLabel];
        left = left + leftMargin + QQButtonWidth;
    }
}

- (void)show {
    self.hidden = NO;
    self.showBackView.frame = CGRectMake(0, kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.showBackView.frame = CGRectMake(0, kCommonScreenHeight - showBackViewHeight, kCommonScreenWidth, showBackViewHeight);
                     }];
}

- (void)hiden {
    self.hidden = YES;
    [UIView animateWithDuration:0.3f
            animations:^{
                self.showBackView.frame = CGRectMake(0, kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
            }
            completion:^(BOOL finished){

            }];
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case cancelShareButtonTag: {
            [self hiden];
            break;
        }
        case qqButtonTag: {
            StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"QQZone" });
            [self shareMethod:ShareTypeQQSpace];
            break;
        }
        case friendButtonTag: {
            StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"WechatMoments" });
            [self shareMethod:ShareTypeWeixiTimeline];
            break;
        }
        case weixinButtonTag: {
            StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"Wechat" });
            [self shareMethod:ShareTypeWeixiSession];
            break;
        }
        case weiboButtonTag: {
            StatisEventWithAttributes([self getEventNameByStatisType], @{ @"platform" : @"SinaWeibo" });
            [self shareMethod:ShareTypeSinaWeibo];
            break;
        }
        default:
            break;
    }
}

- (NSString *)getEventNameByStatisType {
    if (self.statisType == StatisticsTypeMovie) {
        return EVENT_SHARE_MOVIE;
    } else if (self.statisType == StatisticsTypeCinema) {
        return EVENT_SHARE_CINEMA;
    } else if (self.statisType == StatisticsTypeOrder) {
        return EVENT_SHARE_ORDER;
    } else if (self.statisType == StatisticsTypePrivilege) {
        return EVENT_SHARE_PRIVILEGE;
    } else if (self.statisType == StatisticsTypeSnsPoster) { //已有
        return EVENT_SHARE_SNS_POSTER;
    } else if (self.statisType == StatisticsTypeSubscriber) {
        return EVENT_SHARE_SUBSCRIBER;
    }
    return @"";
}

- (void)shareMethod:(ShareType)type {
    [self.thirdPartLoginEngine shareContentToThirdPartWithTitle:self.title
                                                        Content:[NSString stringWithFormat:@"%@,%@", self.content, self.url]
                                                        withUrl:self.url
                                                          image:self.imageUrl
                                                       WithSite:type
                                                 showDialogView:self
                                                         result:^(BOOL result){

                                                         }];
}

- (UIView *)showBackView {
    if (!_showBackView) {
        _showBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - showBackViewHeight, kCommonScreenWidth, showBackViewHeight)];
        _showBackView.backgroundColor = [UIColor r:245 g:245 b:245];
    }
    return _showBackView;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(leftLineViewLeft, leftLineViewTop, CGRectGetMinX(self.titleLabel.frame) - leftLineViewLeft * 2, leftLineViewHeight)];
        _leftLineView.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0];
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + leftLineViewLeft, leftLineViewTop, CGRectGetWidth(self.leftLineView.frame), leftLineViewHeight)];
        _rightLineView.backgroundColor = self.leftLineView.backgroundColor;
    }
    return _rightLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - titleLabelWidth) * 0.5, titleLabelTop, titleLabelWidth, titleLabelHeight)];
        _titleLabel.text = @"分享给好友";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor r:50 g:50 b:50];
        _titleLabel.font = [UIFont systemFontOfSize:titleLabelFont];
    }
    return _titleLabel;
}

- (UIButton *)cancelShareButton {
    if (!_cancelShareButton) {
        CGRect cancelRect = CGRectMake(cancelShareButtonLeft, cancelShareButtonTop, CGRectGetWidth(self.frame) - cancelShareButtonLeft * 2, cancelShareButtonHeight);
        _cancelShareButton = [UIButton buttonWithType:0];
        _cancelShareButton.frame = cancelRect;
        _cancelShareButton.backgroundColor = [UIColor r:240 g:240 b:240];
        _cancelShareButton.layer.cornerRadius = 2.0f;
        [_cancelShareButton setTitle:@"取消分享"
                            forState:UIControlStateNormal];
        [_cancelShareButton setTitleColor:[UIColor r:100 g:100 b:100]
                                 forState:UIControlStateNormal];
        [_cancelShareButton.titleLabel setFont:[UIFont systemFontOfSize:cancelShareButtonFont]];
        _cancelShareButton.tag = cancelShareButtonTag;
        [_cancelShareButton addTarget:self
                               action:@selector(commonBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelShareButton;
}

- (ThirdPartLoginEngine *)thirdPartLoginEngine {
    if (!_thirdPartLoginEngine) {
        _thirdPartLoginEngine = [[ThirdPartLoginEngine alloc] init];
    }
    return _thirdPartLoginEngine;
}

@end
