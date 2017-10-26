//
//  PosterOperationView.m
//  KoMovie
//
//  Created by KKZ on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubTask.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "KKZUtility.h"
#import "PostInformViewController.h"
#import "PosterOperationView.h"
#import "RIButtonItem.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"

#define oprationVHeight 50
#define oprationVColor [UIColor r:232 g:232 b:232]
#define oprationTitleColor appDelegate.kkzBlue
#define oprationVCoverColor [UIColor r:0 g:0 b:0 alpha:0.5]

@interface PosterOperationView ()

/**
 *  是否点击分享按钮
 */
@property (nonatomic, assign) BOOL clickShareBtn;

@end

@implementation PosterOperationView

- (void)dealloc {
    DLog(@"退出PosterOperationView");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
/**
 *  添加去掉遮层的点击区域
 */
- (void)addCancelView {
    cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight - (oprationVHeight * 4 + 44 + 20))];
    [self addSubview:cancelView];
}

/**
 *  添加用户操作项
 */
- (void)addUserOperation {

    if (self.isUserSelf) { //用户自己的帖子

        if (self.isFav) {
            self.operationArr = [[NSMutableArray alloc] initWithObjects:@"分享帖子", @"取消收藏", @"删除帖子", @"取消", nil];
        } else {
            self.operationArr = [[NSMutableArray alloc] initWithObjects:@"分享帖子", @"收藏帖子", @"删除帖子", @"取消", nil];
        }

    } else { //别人的帖子
        if (self.isFav) {
            self.operationArr = [[NSMutableArray alloc] initWithObjects:@"分享帖子", @"取消收藏", @"举报帖子", @"取消", nil];
        } else {
            self.operationArr = [[NSMutableArray alloc] initWithObjects:@"分享帖子", @"收藏帖子", @"举报帖子", @"取消", nil];
        }
    }

    oprationVBg = [[UIView alloc] initWithFrame:CGRectMake(0, screentHeight - oprationVHeight * 4, screentWith, oprationVHeight * 4)];
    [self addSubview:oprationVBg];
    oprationVBg.hidden = NO;

    for (int i = 0; i < self.operationArr.count; i++) {
        [self addOperationWithTitle:self.operationArr[i] andIndex:i];
    }
}

- (void)addOperationWithTitle:(NSString *)title andIndex:(NSInteger)index {

    UIButton *operationV = [[UIButton alloc] initWithFrame:CGRectMake(0, index * oprationVHeight, screentWith, oprationVHeight)];
    [oprationVBg addSubview:operationV];

    [operationV setTitle:title forState:UIControlStateNormal];
    operationV.titleLabel.font = [UIFont systemFontOfSize:14];
    [operationV setBackgroundColor:[UIColor whiteColor]];

    if (index == 3) {
        [operationV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else
        [operationV setTitleColor:oprationTitleColor forState:UIControlStateNormal];

    operationV.tag = index + 100;

    [operationV addTarget:self action:@selector(operationVClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 0.6)];
    [topLine setBackgroundColor:oprationVColor];
    [operationV addSubview:topLine];
}

/**
 *  操作按钮被点击
 */
- (void)operationVClicked:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;

    if (btn.tag == 101) {
        self.tagYBtn = btn;
    }
    if (btn.tag - 100 == 3) {
        DLog(@"点击了取消按钮"); //取消
        [self removeFromSuperview];
        return;
    }

    self.clickShareBtn = FALSE;
    void (^action)() = ^() {
        switch (btn.tag - 100) {
            case 0:
                DLog(@"点击了操作按钮"); //分享
                self.clickShareBtn = TRUE;
                [oprationVBg removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:shareViewWillShowNotification
                                                                    object:nil];
                [weakSelf shareMassage];
                break;
            case 1:
                DLog(@"点击了操作按钮"); //收藏
                {

                    if (self.isFav) {
                        [weakSelf unCollectionPost];
                    } else {
                        [weakSelf collectionPost];
                    }

                    break;
                }
            case 2:
                DLog(@"点击了操作按钮"); //删除、举报
                if (weakSelf.isUserSelf) { //用户自己的帖子 删除

                    [weakSelf deletePostWithArticleId:weakSelf.articleId.integerValue];

                } else { //举报
                    PostInformViewController *ctr = [[PostInformViewController alloc] init];
                    ctr.articleId = self.articleId.integerValue;
                    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
                    [parentCtr presentViewController:ctr animated:YES completion:nil];
                    [weakSelf removeFromSuperview];
                }
                break;
            //            case 3:
            //                DLog(@"点击了取消按钮"); //取消
            //                [weakSelf removeFromSuperview];
            //                break;
            default:
                break;
        }
    };

    if (!appDelegate.isAuthorized) {

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
            if (succeeded)
                action();
        }
                                           withController:parentCtr];
    } else {

        action();
    }
}

/**
 * 添加手势
 */
- (void)addTapGesture {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [cancelView addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
    [self hideCoverView];
}

/**
 *  监听手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark-- HideCoverViewDelegate
- (void)hideCoverView {
    [self removeFromSuperview];
    if (self.clickShareBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:shareViewWillHidenNotification
                                                            object:nil];
    }
}

/**
 *  分享
 */
- (void)shareMassage {

    ClubPost *clubPost = self.clubPost;

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.delegateY = self;
    poplistview.userShareInfo = @"posterDetail";

    if (clubPost.share.image && clubPost.share.image.length) {
        [poplistview updateWithcontent:[NSString stringWithFormat:@"%@%@", clubPost.share.title, clubPost.share.url]
                         contentWeChat:clubPost.share.title
                        contentQQSpace:clubPost.share.title
                                 title:clubPost.share.title
                             imagePath:nil
                              imageURL:clubPost.share.image
                                   url:clubPost.share.url
                              soundUrl:nil
                              delegate:self
                             mediaType:SSPublishContentMediaTypeNews
                        statisticsType:StatisticsTypeSnsPoster
                             shareInfo:nil
                             sharedUid:nil];
    } else {
        [poplistview updateWithcontent:[NSString stringWithFormat:@"%@%@", clubPost.share.title, clubPost.share.url]
                         contentWeChat:clubPost.share.title
                        contentQQSpace:clubPost.share.title
                                 title:clubPost.share.title
                             imagePath:[UIImage imageNamed:@"ShareIcon"]
                                   url:clubPost.share.title
                              soundUrl:nil
                              delegate:self
                             mediaType:SSPublishContentMediaTypeNews
                        statisticsType:StatisticsTypeSnsPoster];
    }

    [poplistview setBackgroundColor:[UIColor clearColor]];
    [self addSubview:poplistview];
}

/**
*  收藏帖子接口
*/
- (void)collectionPost {
    self.collectionType = 1;
    ClubTask *task = [[ClubTask alloc] initCollectionPostWithArticleId:self.articleId.integerValue
                                                       andOprationType:self.collectionType
                                                              Finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                  [self collectionPostFinish:userInfo andSucced:succeeded];
                                                              }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)collectionPostFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed {
    if (succeed) {
        [self.tagYBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        self.clubPost.isFaverite = 1;
        self.isFav = YES;
        [appDelegate showAlertViewForTitle:@"" message:@"收藏成功" cancelButton:@"OK"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"isPostCollectionComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.isFav] forKey:@"isFav"]];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

//取消收藏
- (void)unCollectionPost {
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];

    cancel.action = ^{

    };

    RIButtonItem *ok = [RIButtonItem

            itemWithLabel:@"取消收藏"

                   action:^{

                       ClubTask *task = [[ClubTask alloc] initDeletePostWithArticleId:self.articleId.integerValue
                                                                             Finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                                 //操作类型 1：添加收藏 2：取消收藏

                                                                                 ClubTask *task = [[ClubTask alloc] initCollectionPostWithArticleId:self.articleId.integerValue
                                                                                                                                    andOprationType:2
                                                                                                                                           Finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                                                                                               [self uncollectionPostFinish:userInfo andSucced:succeeded];

                                                                                                                                           }];

                                                                                 if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                                                                                 }

                                                                             }];

                       if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                       }
                   }];

    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""

                                                      message:@"是否取消收藏该帖子"

                                             cancelButtonItem:cancel

                                             otherButtonItems:ok, nil];

    [alertAt show];
}

- (void)uncollectionPostFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed {

    if (succeed) {
        [self.tagYBtn setTitle:@"收藏帖子" forState:UIControlStateNormal];
        self.clubPost.isFaverite = 0;
        self.isFav = NO;
        [appDelegate showAlertViewForTitle:@"" message:@"已取消收藏" cancelButton:@"OK"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"isPostCollectionComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.isFav] forKey:@"isFav"]];

    } else {

        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)uploadData {
    //添加这层
    [self setBackgroundColor:oprationVCoverColor];
    //添加取消遮层的点击区域
    [self addCancelView];
    //添加用户操作项
    [self addUserOperation];
    //添加手势
    [self addTapGesture];
}

/**
 *  删除帖子
 */
- (void)deletePostWithArticleId:(NSInteger)articleId {

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{

    };

    RIButtonItem *ok = [RIButtonItem
            itemWithLabel:@"删除"
                   action:^{
                       ClubTask *task = [[ClubTask alloc] initDeletePostWithArticleId:articleId
                                                                             Finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                 [self deletePostFinish:userInfo andSucced:succeeded];
                                                                             }];

                       if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                       }
                   }];

    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"是否删除该帖子"
                                             cancelButtonItem:cancel
                                             otherButtonItems:ok, nil];
    [alertAt show];

    //    - (id)initDeletePostWithArticleId:(NSInteger)articleId Finished:(FinishDownLoadBlock)block
    //操作类型 1：添加收藏 2：取消收藏
}

- (void)deletePostFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed {
    if (succeed) {
        [appDelegate showAlertViewForTitle:@"" message:@"已删除该贴" cancelButton:@"OK"];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr popViewControllerAnimated:NO];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"isPostDeleteComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:self.articleId forKey:@"articleId"]];

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

@end
