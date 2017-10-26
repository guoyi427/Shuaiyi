//
//  MovieCommentSuccessViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieCommentSuccessViewController.h"
#import "ClubPostPictureViewController.h"
#import "UIColor+Hex.h"
#import "ThirdPartLoginEngine.h"
#import "MovieSelectHeader.h"
#import "ClubPost.h"
#import "MovieCommentData.h"
#import "UIConstants.h"

/**************顶部视图*******************/
static const CGFloat submitButtonRight = 15.0f;
static const CGFloat submitButtonWidth = 30.0f;
static const CGFloat topTitleBarLeft = 15.0f;
static const CGFloat successViewTop = 30.0f;

static const CGFloat successTitleTop = 18.0f;
static const CGFloat successDetailTop = 10.0f;
static const CGFloat successTitleHeight = 18.0f;
static const CGFloat successDetailHeight = 13.0f;

static const CGFloat successButtonTop = 25.0f;
static const CGFloat successButtonHeight = 30.0f;
static const CGFloat successButtonWeight = 121.0f;

/**************分享视图******************/
static const CGFloat shareTitleTop = 48.0f;
static const CGFloat shareTitleWidth = 165.0f;
static const CGFloat shareTitleHeight = 13.0f;

static const CGFloat shareDetailTop = 10.0f;
static const CGFloat shareDetailHeight = 11.0f;

static const CGFloat shareLeftLineRight = 20.0f;
static const CGFloat shareViewTop = 35.0f;
static const CGFloat shareViewLeft = 35.0f;

typedef enum : NSUInteger {
    lookButtonTag,
    completeButtonTag,
    clickWeixinButtonTag,
    clickFriendButtonTag,
    clickWeiboButtonTag,
    clickQQZoneButtonTag,
} movieCommentAllButtonTag;

@interface MovieCommentSuccessViewController ()

/**
 *  右导航按钮
 */
@property (nonatomic, strong) UIButton *rightButton;

/**
 *  顶部标题条
 */
@property (nonatomic, strong) UIImageView *topTitleBarIgV;

/**
 *  成功的图片
 */
@property (nonatomic, strong) UIImageView *successIgV;

/**
 *  成功的主标题
 */
@property (nonatomic, strong) UILabel *successTitle;

/**
 *  成功的副标题
 */
@property (nonatomic, strong) UILabel *successDetail;

/**
 *  成功的按钮
 */
@property (nonatomic, strong) UIButton *successButton;

/**
 *  分享标题
 */
@property (nonatomic, strong) UILabel *shareTitleLabel;

/**
 *  分享子标题
 */
@property (nonatomic, strong) UILabel *shareDetailLabel;

/**
 *  分享标题的左边线
 */
@property (nonatomic, strong) UIView *shareLeftLine;

/**
 *  分享标题的右边线
 */
@property (nonatomic, strong) UIView *shareRightLine;

/**
 *  应用程序的icon图标
 */
@property (nonatomic, strong) UIImage *iconImg;


/**
 *  第三方登录管理
 */
@property (nonatomic, strong) ThirdPartLoginEngine *thirdPartLoginEngine;

@end

@implementation MovieCommentSuccessViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航条
    [self loadNavBar];

    //加载主页面
    [self loadMainView];

    //加载分享视图
    [self loadShareView];

    //加载通知
    [self loadNotification];
    
}

- (void)loadNavBar {

    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];

    //添加右导航按钮
    [self.navBarView addSubview:self.rightButton];
}

- (void)loadMainView {
    //加载顶部标题图片
    [self.view addSubview:self.topTitleBarIgV];

    //加载成功的图片
    [self.topTitleBarIgV addSubview:self.successIgV];

    //成功的主标题
    [self.topTitleBarIgV addSubview:self.successTitle];

    //成功的副标题
    [self.topTitleBarIgV addSubview:self.successDetail];

    //成功的按钮
    [self.topTitleBarIgV addSubview:self.successButton];

    //分享的标题
    [self.view addSubview:self.shareTitleLabel];
    [self.view addSubview:self.shareLeftLine];
    [self.view addSubview:self.shareRightLine];
    //    [self.view addSubview:self.shareDetailLabel];
}

- (void)loadShareView {
    NSArray *titleArr = @[ @"微信好友", @"朋友圈", @"新浪微博", @"QQ空间" ];
    NSArray *buttonImgs = @[ @"movieComment_weixin", @"movieComment_friend", @"movieComment_weibo", @"movieComment_QQZone" ];
    CGFloat left = shareViewLeft;
    CGFloat top = CGRectGetMaxY(_shareTitleLabel.frame) + shareViewTop;
    UIImage *image = [UIImage imageNamed:buttonImgs[0]];
    CGFloat offsetX = (kCommonScreenWidth - left * 2 - image.size.width * titleArr.count) / (titleArr.count - 1);
    for (int i = 0; i < titleArr.count; i++) {

        //按钮
        UIButton *button = [UIButton buttonWithType:0];
        UIImage *buttonImg = [UIImage imageNamed:buttonImgs[i]];
        button.frame = CGRectMake(left, top, buttonImg.size.width, buttonImg.size.height);
        [button setImage:buttonImg
                forState:UIControlStateNormal];
        button.tag = clickWeixinButtonTag + i;
        [button addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        //标签
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, CGRectGetMaxY(button.frame) + 11.0f, CGRectGetWidth(button.frame), 20.0f)];
        label.textColor = [UIColor colorWithHex:@"#333333"];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];

        left += offsetX + button.frame.size.width;
    }
}

- (void)loadNotification {
    if ([MovieCommentData sharedInstance].movieId) {
        //发送更新用户通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubscribePostSucceedMovieDetail"
                                                            object:nil
                                                          userInfo:[NSDictionary dictionaryWithObject:self.clubPost forKey:@"SubscribeClubPost"]];
    } else {
        //        //发送更新用户通知
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubscribePostSucceedClub"
        //                                                            object:nil
        //                                                          userInfo:[NSDictionary dictionaryWithObject:self.clubPost forKey:@"SubscribeClubPost"]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePostComplete:)
                                                 name:@"isPostDeleteComplete"
                                               object:nil];
}

- (void)deletePostComplete:(NSNotification *) not{
    if (self.pageFrom == joinCurrentPageFromCamera) {
        [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification
                                                            object:nil];
    } else if (self.pageFrom == joinCurrentPageFromLibrary) {
        [self dismissViewControllerAnimated:NO
                                   completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification
                                                            object:nil];
    }
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *submitButton = [UIButton buttonWithType:0];
        CGFloat totalWidth = submitButtonWidth + 2 * submitButtonRight;
        submitButton.frame = CGRectMake(kCommonScreenWidth - totalWidth, 0, totalWidth, CGRectGetHeight(self.navBarView.frame));
        [submitButton setTitle:@"完成"
                      forState:UIControlStateNormal];
        [submitButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [submitButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        submitButton.tag = completeButtonTag;
        [submitButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:submitButton];
    }
    return _rightButton;
}

- (UIImageView *)topTitleBarIgV {
    if (!_topTitleBarIgV) {
        UIImage *image = [UIImage imageNamed:@"movieComment_top_bar"];
        _topTitleBarIgV = [[UIImageView alloc] initWithFrame:CGRectMake(topTitleBarLeft, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth - topTitleBarLeft * 2, image.size.height)];
        _topTitleBarIgV.image = image;
    }
    return _topTitleBarIgV;
}

- (UIImageView *)successIgV {
    if (!_successIgV) {
        UIImage *successImg = [UIImage imageNamed:@"paySucceedIcon"];
        _successIgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_topTitleBarIgV.frame) - successImg.size.width) / 2.0f, successViewTop, successImg.size.width, successImg.size.height)];
        _successIgV.image = successImg;
    }
    return _successIgV;
}

- (UILabel *)successTitle {
    if (!_successTitle) {
        _successTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_successIgV.frame) + successTitleTop, CGRectGetWidth(_topTitleBarIgV.frame), successTitleHeight)];
        _successTitle.font = [UIFont boldSystemFontOfSize:17.0f];
        _successTitle.textColor = [UIColor blackColor];
        _successTitle.textAlignment = NSTextAlignmentCenter;
        _successTitle.text = @"提交评论成功";
    }
    return _successTitle;
}

- (UILabel *)successDetail {
    if (!_successDetail) {
        _successDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_successTitle.frame) + successDetailTop, CGRectGetWidth(_topTitleBarIgV.frame), successDetailHeight)];
        _successDetail.font = [UIFont systemFontOfSize:13.0f];
        _successDetail.textColor = [UIColor blackColor];
        _successDetail.text = @"您的评论正在审核，感谢您的参与";
        _successDetail.textAlignment = NSTextAlignmentCenter;
    }
    return _successDetail;
}

- (UIButton *)successButton {
    if (!_successButton) {
        _successButton = [UIButton buttonWithType:0];
        _successButton.backgroundColor = appDelegate.kkzBlue;
        _successButton.frame = CGRectMake((CGRectGetWidth(_topTitleBarIgV.frame) - successButtonWeight) / 2.0f, CGRectGetMaxY(_successDetail.frame) + successButtonTop, successButtonWeight, successButtonHeight);
        _successButton.layer.cornerRadius = successButtonHeight / 2.0f;
        _successButton.layer.masksToBounds = YES;
        [_successButton setTitle:@"查看" forState:UIControlStateNormal];
        [_successButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
        _successButton.tag = lookButtonTag;
        [_successButton addTarget:self
                           action:@selector(commonBtnClick:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _successButton;
}

- (UILabel *)shareTitleLabel {
    if (!_shareTitleLabel) {
        _shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kCommonScreenWidth - shareTitleWidth) / 2.0f, CGRectGetMaxY(_topTitleBarIgV.frame) + shareTitleTop, shareTitleWidth, shareTitleHeight)];
        _shareTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _shareTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        _shareTitleLabel.backgroundColor = [UIColor clearColor];
        _shareTitleLabel.text = @"与好友分享你的精彩评论";
    }
    return _shareTitleLabel;
}

- (UILabel *)shareDetailLabel {
    if (!_shareDetailLabel) {
        _shareDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shareTitleLabel.frame) + shareDetailTop, kCommonScreenWidth, shareDetailHeight)];
        _shareDetailLabel.textColor = [UIColor colorWithHex:@"#ffab33"];
        _shareDetailLabel.font = [UIFont systemFontOfSize:12.0f];
        _shareDetailLabel.textAlignment = NSTextAlignmentCenter;
        _shareDetailLabel.text = @"分享成功可获100积分";
    }
    return _shareDetailLabel;
}

- (UIView *)shareLeftLine {
    if (!_shareLeftLine) {
        CGFloat width = (kCommonScreenWidth - topTitleBarLeft * 2 - shareLeftLineRight * 2 - shareTitleWidth)/2.0f;
        _shareLeftLine = [[UIView alloc] initWithFrame:CGRectMake(topTitleBarLeft,CGRectGetMidY(_shareTitleLabel.frame) - 0.3f, width, K_ONE_PIXEL)];
        _shareLeftLine.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _shareLeftLine;
}

- (UIView *)shareRightLine {
    if (!_shareRightLine) {
        _shareRightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shareTitleLabel.frame) + shareLeftLineRight, CGRectGetMidY(_shareTitleLabel.frame) - 0.3f, CGRectGetWidth(_shareLeftLine.frame), K_ONE_PIXEL)];
        _shareRightLine.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _shareRightLine;
}

- (UIImage *)iconImg {
    if (!_iconImg) {
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        _iconImg = [UIImage imageNamed:icon];
    }
    return _iconImg;
}


- (ThirdPartLoginEngine *)thirdPartLoginEngine {
    if (!_thirdPartLoginEngine) {
        _thirdPartLoginEngine = [[ThirdPartLoginEngine alloc] init];
    }
    return _thirdPartLoginEngine;
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case clickWeixinButtonTag:{
            [self.thirdPartLoginEngine shareContentToThirdPartWithTitle:self.clubPost.share.title
                                                                Content:self.clubPost.share.title
                                                                withUrl:self.clubPost.share.url
                                                                  image:self.clubPost.share.image
                                                               WithSite:ShareTypeWeixiSession
                                                         showDialogView:self.view
                                                                 result:^(BOOL result){

                                                                 }];
            break;
        }
        case clickFriendButtonTag:{
            [self.thirdPartLoginEngine shareContentToThirdPartWithTitle:self.clubPost.share.title
                                                                Content:self.clubPost.share.title
                                                                withUrl:self.clubPost.share.url
                                                                  image:self.clubPost.share.image
                                                               WithSite:ShareTypeWeixiTimeline
                                                         showDialogView:self.view
                                                                 result:^(BOOL result){

                                                                 }];
            break;
        }
        case clickWeiboButtonTag:{
            NSString *title = self.clubPost.share.title;
            if (title.length > 100) {
                title = [title substringToIndex:100];
            }
            
            [self.thirdPartLoginEngine shareContentToThirdPartWithTitle:title
                                                                Content:[NSString stringWithFormat:@"%@,%@",title,self.clubPost.share.url]
                                                                withUrl:self.clubPost.share.url
                                                                  image:self.clubPost.share.image
                                                               WithSite:ShareTypeSinaWeibo
                                                         showDialogView:self.view
                                                                 result:^(BOOL result){

                                                                 }];
            break;
        }
        case clickQQZoneButtonTag:{
            [self.thirdPartLoginEngine shareContentToThirdPartWithTitle:self.clubPost.share.title
                                                                Content:self.clubPost.share.title
                                                                withUrl:self.clubPost.share.url
                                                                  image:self.clubPost.share.image
                                                               WithSite:ShareTypeQQSpace
                                                         showDialogView:self.view
                                                                 result:^(BOOL result){

                                                                 }];
            break;
        }
        case completeButtonTag: {
            if (self.pageFrom == joinCurrentPageFromCamera) {
                [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification
                                                                    object:nil];
            } else if (self.pageFrom == joinCurrentPageFromLibrary) {
                [self dismissViewControllerAnimated:NO
                                           completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification
                                                                    object:nil];
            }
            break;
        }
        case lookButtonTag: {
            ClubPostPictureViewController *club = [[ClubPostPictureViewController alloc] init];
            club.articleId = self.clubPost.articleId;
            club.postType = self.clubPost.type.integerValue;

            [self pushViewController:club
                             animation:CommonSwitchAnimationBounce];
            break;
        }
        default:
            break;
    }
}

- (BOOL)showBackButton {
    return FALSE;
}


@end
