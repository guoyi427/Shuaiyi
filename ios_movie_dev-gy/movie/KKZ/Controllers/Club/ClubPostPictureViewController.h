//
//  ClubPostPictureViewController.h
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "ClubPostHeadViewText.h"
#import "ClubPostHeadViewVideo.h"
#import "ClubPostHeadViewAudio.h"
#import "ClubPostHeadViewSubscriber.h"
#import "VideoPostInfoView.h"
#import "NSObject+Delegate.h"

@class ClubSupportView;
@class ClubTextView;
@class KKClubPostModel;
@class ClubPostComment;
@class Movie;

/**
 帖子详情
 */
@interface ClubPostPictureViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate,ClubPostHeadViewTextDelegate,ClubPostHeadViewSubscriberDelegate,VideoPostInfoViewDelegate,HandleUrlProtocol> {

    //UITableView
    UITableView *clubTableView;
    //clubTableView的headerView
    ClubPostHeadViewText *clubHeaderView;
    ClubPostHeadViewVideo *clubHeaderViewVideo;
    ClubPostHeadViewAudio *clubHeaderViewAudio;
    ClubPostHeadViewSubscriber *clubHeaderViewSubscriber;
    //clubTableView的footerView
    UIView *clubFooterView;

    NSInteger currentPage;
    //加载导航栏右边按钮
    UIButton *rightBtn;

    UIButton *coverKeyBoard;

    UIView *clubSectionHeader;
    UILabel *clubPostCommentNum;

    UIView *messageLblBgV;
}

/**
 *  帖子图片数组
 */
@property (nonatomic, assign) CGFloat currentContentOffsety;
/**
 *  帖子id
 */
@property (nonatomic, copy) NSNumber *articleId;

/**
 *  帖子类型
 */
@property (nonatomic, assign) NSInteger postType;

/**
 *  帖子回复
 */
@property (nonatomic, strong) NSMutableArray *clubPostCommentList;

/**
 *  帖子点赞列表
 */
@property (nonatomic, strong) NSMutableArray *supportList;

/**
 *  帖子相关电影
 */
@property (nonatomic, strong) Movie *movie;

@property (nonatomic, assign) BOOL hasUp;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) BOOL hasKeyBoard;
@property (nonatomic, assign) NSInteger isFav;
@property (nonatomic, copy) NSString *clubPostContent;

@end
