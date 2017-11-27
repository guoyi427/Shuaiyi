//
//  ActivityDetailViewController.m
//  KoMovie
//
//  Created by wuzhen on 15/5/9.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "Activity.h"
#import "ActivityDetailViewController.h"
#import "ImageEngine.h"
#import "ShareView.h"
//#import "TaskQueue.h"
#import "ActivityRequest.h"

@interface ActivityDetailViewController()
@property (nonatomic, strong) Activity *activity;

@end

@implementation ActivityDetailViewController

#pragma mark - Init methods
- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.activityId = [extra1 intValue];

            [self.indicatorView startAnimating];
            [self queryActivityDetail];
        }
    }
    return self;
}

- (id)initWithActivityId:(NSInteger)activityId {
    self = [super init];
    if (self) {
        self.activityId = activityId;

        [self.indicatorView startAnimating];
        [self queryActivityDetail];
    }
    return self;
}

- (void)queryActivityDetail {

    ActivityRequest *request = [[ActivityRequest alloc] init];
    [request requestDetail:[NSNumber numberWithInteger:self.activityId]
            success:^(Activity *_Nullable activity) {
                if (activity) {
                    self.kkzTitleLabel.text = activity.activityTitle;
                    [self loadRequestWithURL:activity.activityUrl];
                    self.activity = activity;
                }
            }
            failure:^(NSError *_Nullable err){

            }];
}
#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(screentWith - 60, 3, 60, 40);
    [shareBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateHighlighted];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 15)];
    [shareBtn addTarget:self action:@selector(shareContent) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:shareBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    DLog(@"媒体打开窗口被隐藏");
    //使用 UIWebView 来播放视频的时候，在页面切换时 停止播放
    //    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self reloadPage];
}

#pragma mark - Share methods
//我参加了{活动标题名称}活动，召唤小伙伴一起参加优惠活动！快下载【抠电影客户端】http://www.komovie.cn/download
- (void)shareContent {

    NSString *imgUrl;
    if (self.activity.sharePicUrl.length) {
        imgUrl = self.activity.sharePicUrl;
    } else {
        imgUrl = self.activity.picSmall; //看活动列表中用的是那个图片
    }

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.userShareInfo = @"activity";

    NSString *acContent;
    NSString *contentQQSpace;
    NSString *contentWeChat;

    if (self.activity.shareContent.length) {
        acContent = [NSString stringWithFormat:@"%@,%@", self.activity.shareContent, self.activity.activityUrl];
        contentQQSpace = self.activity.shareContent;
        contentWeChat = self.activity.shareContent;
    } else {
        acContent = [NSString stringWithFormat:@"我参加了{%@}活动，召唤小伙伴一起参加优惠活动！快下载【章鱼电影客户端】%@", self.activity.activityTitle, kAppHTML5Url];
        contentQQSpace = [NSString stringWithFormat:@"我参加了{%@}活动，召唤小伙伴一起参加优惠活动！快下载【章鱼电影客户端】%@", self.activity.activityTitle, kAppHTML5Url];
        contentWeChat = [NSString stringWithFormat:@"我参加了{%@}活动，召唤小伙伴一起参加优惠活动！快下载【章鱼电影客户端】%@", self.activity.activityTitle, kAppHTML5Url];
    }
    [poplistview updateWithcontent:acContent
                     contentWeChat:contentWeChat
                    contentQQSpace:contentQQSpace
                             title:acContent
                         imagePath:nil
                          imageURL:imgUrl
                               url:self.activity.activityUrl
                          soundUrl:nil
                          delegate:self
                         mediaType:SSPublishContentMediaTypeNews
                    statisticsType:StatisticsTypePrivilege
                         shareInfo:nil
                         sharedUid:nil];
    [poplistview show];
}

@end
