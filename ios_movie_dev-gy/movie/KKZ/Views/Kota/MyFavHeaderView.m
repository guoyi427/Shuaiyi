
//
//  MyFavHeaderView.m
//  KKZ
//
//  Created by xuyang on 13-4-10.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "ClubTask.h"
#import "CollectedMovieViewController.h"
#import "CommonViewController.h"
#import "DataEngine.h"
#import "FriendPublishedPostViewController.h"
#import "KKZUserTask.h"
#import "KKZUtility.h"
#import "KotaTask.h"

#import "MyFavHeaderView.h"
#import "MyFriendAttentionViewController.h"
#import "TaskQueue.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UserDefault.h"
#import "UserRequest.h"
#import "UIButton+PPiAwesome.h"

#define kFontSize 13

@implementation MyFavHeaderView {
    CGPoint startPoint;
    //    UIImageView *homeBackgroundView;
    BOOL isAnimation;

    UILabel *messageLabel, *specialtyLabel; //私信，文字label //专业影评人，电影成就

    UIView *messageView; //私信

    UIView *addOrDeleteFriendView; //关注TA，或者取消关注，自己家
    UIImageView *addOrDeleteFriendBg;
    UILabel *addOrDeleteFriendLabel;
    UIImageView *noReadImage, *arrowImg; //未读红色消息
    UILabel *noReadLabel; //未读个数

    UIButton *touchButton; // 包括下面所有的view。

    //非折叠view
    UIView *commentView; //评论
    UIView *specialtyView; //专业影评人

    UIView *foldedView; //折叠view
    UIImageView *wantBg; //想看
    UIImageView *watchedBg; //看了
    UIView *favoriteView; //关注
    UIView *fansView; //粉丝
    UIView *goodFriendsView; //好友
    UIButton *foldBtn;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];

        contentScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 166)];
        [self addSubview:contentScrollView];

        avatarBg = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 80) * 0.5, 2.5, 80, 80)];
        [contentScrollView addSubview:avatarBg];

        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 65) * 0.5, 10, 65, 65)];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [avatarImageView setBackgroundColor:[UIColor clearColor]];
        avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
        avatarImageView.clipsToBounds = YES;
        [contentScrollView addSubview:avatarImageView];

        CALayer *l = avatarImageView.layer;

        [l setMasksToBounds:YES];

        [l setCornerRadius:65 * 0.5];

        //我的私信

        messageView = [[UIView alloc] initWithFrame:CGRectMake(60, 18, 45, 64)];
        messageView.hidden = NO;

        if ([DataEngine sharedDataEngine].userId.intValue) {
            messageView.hidden = NO;
        }

        [contentScrollView addSubview:messageView];

        UIImageView *messageWhiteBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 45, 64)];
        messageWhiteBg.image = [UIImage imageNamed:@"privateMess"];
        messageWhiteBg.contentMode = UIViewContentModeScaleAspectFit;
        [messageView addSubview:messageWhiteBg];

        //取消关注，或者关注TA,好友家才显示

        addOrDeleteFriendView = [[UIView alloc] initWithFrame:CGRectMake(screentWith - 105, 18, 45, 64)];
        addOrDeleteFriendView.backgroundColor = [UIColor clearColor];
        addOrDeleteFriendView.hidden = NO;
        [contentScrollView addSubview:addOrDeleteFriendView];

        addOrDeleteFriendBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 45, 64)];
        addOrDeleteFriendBg.image = [UIImage imageNamed:@"attenYN"];
        addOrDeleteFriendBg.highlightedImage = [UIImage imageNamed:@"unattenYN"];
        addOrDeleteFriendBg.highlighted = YES;
        addOrDeleteFriendBg.contentMode = UIViewContentModeScaleAspectFit;
        [addOrDeleteFriendView addSubview:addOrDeleteFriendBg];

        attentionRect = CGRectMake(0, 109, (screentWith - 20 * 2) * 0.25 + 20, 40);

        UIView *attentionRectV = [[UIView alloc] initWithFrame:attentionRect];
        [attentionRectV setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:attentionRectV];

        UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 125, (screentWith - 20 * 2) * 0.25, 16)];
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [attentionBtn setTextFont:[UIFont systemFontOfSize:14] forUIControlState:UIControlStateNormal];
        attentionLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 109, (screentWith - 20 * 2) * 0.25, 16)];
        [attentionLbl setTextColor:[UIColor whiteColor]];
        attentionLbl.font = [UIFont systemFontOfSize:14];
        attentionLbl.text = @"0";
        [attentionLbl setBackgroundColor:[UIColor clearColor]];
        attentionLbl.textAlignment = NSTextAlignmentCenter;
        attentionLbl.userInteractionEnabled = NO;
        attentionBtn.userInteractionEnabled = NO;
        [contentScrollView addSubview:attentionBtn];
        [contentScrollView addSubview:attentionLbl];

        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 1, 125, 1, 16)];
        v1.backgroundColor = [UIColor whiteColor];
        [contentScrollView addSubview:v1];

        seenRect = CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 1, 109, (screentWith - 20 * 2) * 0.25, 40);

        UIView *seenRectV = [[UIView alloc] initWithFrame:seenRect];
        [seenRectV setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:seenRectV];

        UIButton *seenBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 1, 125, (screentWith - 20 * 2) * 0.25, 16)];
        [seenBtn setTitle:@"看过" forState:UIControlStateNormal];
        [seenBtn setTextFont:[UIFont systemFontOfSize:14] forUIControlState:UIControlStateNormal];
        seenLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 1, 109, (screentWith - 20 * 2) * 0.25, 16)];
        [seenLbl setTextColor:[UIColor whiteColor]];
        seenLbl.font = [UIFont systemFontOfSize:14];
        seenLbl.text = @"0";
        [seenLbl setBackgroundColor:[UIColor clearColor]];
        seenLbl.textAlignment = NSTextAlignmentCenter;
        seenBtn.userInteractionEnabled = NO;
        seenLbl.userInteractionEnabled = NO;
        [contentScrollView addSubview:seenBtn];
        [contentScrollView addSubview:seenLbl];

        UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 2, 125, 1, 16)];
        v2.backgroundColor = [UIColor whiteColor];
        [contentScrollView addSubview:v2];

        wantseeRect = CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 2, 109, (screentWith - 20 * 2) * 0.25, 40);

        UIView *wantseeRectV = [[UIView alloc] initWithFrame:wantseeRect];
        [wantseeRectV setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:wantseeRectV];

        UIButton *wantseeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 2, 125, (screentWith - 20 * 2) * 0.25, 16)];
        [wantseeBtn setTitle:@"想看" forState:UIControlStateNormal];
        [wantseeBtn setTextFont:[UIFont systemFontOfSize:14] forUIControlState:UIControlStateNormal];
        wantseeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 2, 109, (screentWith - 20 * 2) * 0.25, 16)];
        [wantseeLbl setTextColor:[UIColor whiteColor]];
        wantseeLbl.font = [UIFont systemFontOfSize:14];
        wantseeLbl.text = @"0";
        [wantseeLbl setBackgroundColor:[UIColor clearColor]];
        wantseeLbl.textAlignment = NSTextAlignmentCenter;
        wantseeBtn.userInteractionEnabled = NO;
        wantseeLbl.userInteractionEnabled = NO;
        [contentScrollView addSubview:wantseeBtn];
        [contentScrollView addSubview:wantseeLbl];

        UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 3, 125, 1, 16)];
        v3.backgroundColor = [UIColor whiteColor];
        [contentScrollView addSubview:v3];

        commentRect = CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 3, 109, (screentWith - 20 * 2) * 0.25 + 20, 40);

        UIView *commentRectV = [[UIView alloc] initWithFrame:commentRect];
        [commentRectV setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:commentRectV];

        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 3, 125, (screentWith - 20 * 2) * 0.25, 16)];
        [commentBtn setTitle:@"帖子" forState:UIControlStateNormal];
        [commentBtn setTextFont:[UIFont systemFontOfSize:14] forUIControlState:UIControlStateNormal];
        commentNumsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (screentWith - 20 * 2) * 0.25 * 3, 109, (screentWith - 20 * 2) * 0.25, 16)];
        [commentNumsLabel setTextColor:[UIColor whiteColor]];
        commentNumsLabel.font = [UIFont systemFontOfSize:14];
        commentNumsLabel.text = @"0";
        [commentNumsLabel setBackgroundColor:[UIColor clearColor]];
        commentNumsLabel.textAlignment = NSTextAlignmentCenter;
        commentBtn.userInteractionEnabled = NO;
        commentNumsLabel.userInteractionEnabled = NO;
        [contentScrollView addSubview:commentBtn];
        [contentScrollView addSubview:commentNumsLabel];

        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                        -20.0f,
                                                                                        320.0f,
                                                                                        20)];
        [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
        [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)refreshUserDetails {

    if (![[NetworkUtil me] reachable]) {
        return;
    }

    KotaTask *task = [[KotaTask alloc] initFriendUserDetail:self.userId
                                                   finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                       [self userInfoFinished:userInfo status:succeeded];
                                                   }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)userInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {

        DLog(@"user info succeeded");

        self.user = userInfo[@"user"];
        self.userId = self.user.userId;
        [self updateLayout]; // 填充数据

        [self checkFriend]; //查询好友状态

        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshUserInfoComplete:)]) {

            [self.delegate refreshUserInfoComplete:self.user];
        }
    }
}

- (void)checkFriend {

    if (appDelegate.isAuthorized) {
        KKZUserTask *task = [[KKZUserTask alloc] initUserRelationWith:self.userId
                                                             finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                 [self checkFriendFinished:userInfo status:succeeded];
                                                             }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    }
}

- (void)checkFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"checkFriendFinished finished");
    [appDelegate hideIndicator];
    if (succeeded) {
        self.isFriend = [[userInfo kkz_boolNumberForKey:@"tag"] boolValue];

        self.hidden = NO;
        [self updateLayout];

        if (self.delegate && [self.delegate respondsToSelector:@selector(checkUserIsFriendComplete)]) {
            [self.delegate checkUserIsFriendComplete];
        }
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark utilities
- (void)updateLayout {

    [self refreshMyPblishNum];

    if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {
        messageLabel.frame = CGRectMake(36, 12, 30, kFontSize + 2);
        messageLabel.text = @"私信";
        messageNumLabel.hidden = YES;
        noMessageReadImage.hidden = NO;
        messageView.hidden = NO;

        addOrDeleteFriendView.hidden = NO;
    } else {
        messageLabel.frame = CGRectMake(06, 12, 60, kFontSize + 2);
        messageLabel.text = @"发私信";
        messageNumLabel.hidden = YES;
        noMessageReadImage.hidden = YES;
        messageView.hidden = NO;

        addOrDeleteFriendView.hidden = NO;
        if (self.isFriend) {
            addOrDeleteFriendLabel.text = @"取消关注";
            addOrDeleteFriendBg.highlighted = NO;
        } else {
            addOrDeleteFriendLabel.text = @"关注TA";
            addOrDeleteFriendBg.highlighted = YES;
        }
    }

    genderImageView.hidden = NO;

    if ([self.user.sex intValue]) {
        genderImageView.image = [UIImage imageNamed:@"fav_man_icon"];
    } else {
        genderImageView.image = [UIImage imageNamed:@"fav_woman_icon"];
    }

    ageLabel.text = self.user.age;
    fansNumLabel.text = [NSString stringWithFormat:@"%d", [self.user.followerCount intValue]];

    if ([self.user.messageCount intValue]) {
        messageNumLabel.hidden = NO;
        noMessageReadImage.hidden = NO;
        messageNumLabel.text = [NSString stringWithFormat:@"%d", [self.user.messageCount intValue]];

    } else {
        messageNumLabel.hidden = YES;
        noMessageReadImage.hidden = YES;
    }

    //    commentNumsLabel.text = [NSString stringWithFormat:@"%d",[self.user.commentCount intValue]];

    int attention = [self.user.favoriteCount intValue];

    if ([self.user.likeCount isEqual:[NSNull null]]) {
        wantseeLbl.text = @"0";
    } else
        wantseeLbl.text = [NSString stringWithFormat:@"%d", [self.user.likeCount intValue]];

    if ([self.user.collectCount isEqual:[NSNull null]]) {
        seenLbl.text = @"0";
    } else
        seenLbl.text = [NSString stringWithFormat:@"%d", [self.user.collectCount intValue]];

    if (attention > 999) {
        attentionLbl.text = @"999+";
    } else {
        attentionLbl.text = [NSString stringWithFormat:@"%d", attention];
    }

    [avatarImageView loadImageWithURL:self.user.avatarPath andSize:ImageSizeTiny imgNameDefault:@"avatarRImg"];

    if (self.user.level.length != 0 && ![self.user.level isEqualToString:@"(null)"]) {
        specialtyLabel.text = self.user.level;
    } else {
        specialtyLabel.text = @"电影成就";
    }
}

- (void)setNewFriendCount:(NSNumber *)count {
    if ([count intValue] > 0) {
        noReadImage.hidden = NO;
        if ([count intValue] > 99) {
            noReadLabel.text = [NSString stringWithFormat:@"%d", 99];
        } else {
            noReadLabel.text = [NSString stringWithFormat:@"%d", [count intValue]];
        }

    } else {
        noReadImage.hidden = YES;
    }
}

#pragma mark touch view delegate
- (void)handleTap:(UITapGestureRecognizer *)gesture {

    if (!appDelegate.isAuthorized) {

        //调用loginview。

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [[DataEngine sharedDataEngine] startLoginFinished:nil withController:parentCtr];

        return;
    }

    if (![[NetworkUtil me] reachable]) {
        return;
    }

    CGPoint point = [gesture locationInView:self];

    if (CGRectContainsPoint(addOrDeleteFriendView.frame, point) && !addOrDeleteFriendView.hidden) {

        if (!appDelegate.isAuthorized) {
            //调用loginview。
            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [[DataEngine sharedDataEngine] startLoginFinished:nil withController:parentCtr];
            return;
        } else {

            if (self.isFriend) {
                addOrDeleteFriendView.userInteractionEnabled = NO;
                [self deleteFriend];
            } else {
                addOrDeleteFriendView.userInteractionEnabled = NO;
                [self addFriend];
            }
            return;
        }
        //添加删除关注
    }

    //关注

    if (CGRectContainsPoint(attentionRect, point)) {
        MyFriendAttentionViewController *ctr = [[MyFriendAttentionViewController alloc] init];
        ctr.userId = [NSString stringWithFormat:@"%d", self.userId];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

        return;
    }

    //看过

    if (CGRectContainsPoint(seenRect, point)) {

        //看了

        CollectedMovieViewController *ctr = [[CollectedMovieViewController alloc] initWithUser:[NSString stringWithFormat:@"%d", self.userId]];

        ctr.isCollect = YES;
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];

        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

        return;
    }

    //想看

    if (CGRectContainsPoint(wantseeRect, point)) {

        CollectedMovieViewController *ctr = [[CollectedMovieViewController alloc] initWithUser:[NSString stringWithFormat:@"%d", self.userId]];

        ctr.isCollect = NO;

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];

        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

        return;
    }

    //评价

    if (CGRectContainsPoint(commentRect, point)) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromComment" object:nil];

        FriendPublishedPostViewController *myCommentVc = [[FriendPublishedPostViewController alloc] init];

        myCommentVc.userId = self.userId;

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];

        [parentCtr pushViewController:myCommentVc animation:CommonSwitchAnimationSwipeR2L];

        return;
    }

    //头像
    if (CGRectContainsPoint(avatarBg.frame, point)) {

        return;
    }
}

- (void)addFriend {

    void (^doAction)() = ^() {
        NSString *userid = [NSString stringWithFormat:@"%u", self.userId];
        if ([userid isEqualToString:[DataEngine sharedDataEngine].userId]) {
            [appDelegate showAlertViewForTitle:@"" message:@"自己不能关注自己" cancelButton:@"确定"];
            return;
        }
        KKZUserTask *task = [[KKZUserTask alloc] initAddFriend:self.userId
                                                      finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                          [self addFriendFinished:userInfo status:succeeded];
                                                      }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"正在添加..."
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:YES
                                    andAutoHide:NO];
        }
    };

    if (!appDelegate.isAuthorized) {
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
            if (succeeded) {
                doAction();
            }
        }
                                           withController:parentCtr];
    } else {
        doAction();
    }
}

- (void)addFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"addFriendFinished finished");
    [appDelegate hideIndicator];
    if (succeeded) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"已关注该用户"
                              cancelButton:@"确定"];
        self.isFriend = YES;
        addOrDeleteFriendLabel.text = @"取消关注";
        addOrDeleteFriendBg.highlighted = NO;

        if (self.delegate && [self.delegate respondsToSelector:@selector(addFriendComplete)]) {
            [self.delegate addFriendComplete];
        }

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }

    addOrDeleteFriendView.userInteractionEnabled = NO;
}

- (void)deleteFriend {
    if (self.isFriend) {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
        cancel.action = ^{

        };

        RIButtonItem *ok = [RIButtonItem
                itemWithLabel:@"删除"
                       action:^{
                           KKZUserTask *task = [[KKZUserTask alloc] initDelFriend:self.userId
                                                                         finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                             [self delFriendFinished:userInfo status:succeeded];
                                                                         }];
                           if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                               [appDelegate showIndicatorWithTitle:@"正在删除..."
                                                          animated:YES
                                                        fullScreen:NO
                                                      overKeyboard:YES
                                                       andAutoHide:NO];
                           }

                       }];

        UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"是否删除好友？"
                                                 cancelButtonItem:cancel
                                                 otherButtonItems:ok, nil];
        [alertAt show];

    } else {
    }
}

- (void)delFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"delFriendFinished finished");
    [appDelegate hideIndicator];
    if (succeeded) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"成功删除好友"
                              cancelButton:@"OK"];
        self.isFriend = NO;
        addOrDeleteFriendLabel.text = @"关注TA";
        addOrDeleteFriendBg.highlighted = YES;

        if (self.delegate && [self.delegate respondsToSelector:@selector(addFriendComplete)]) {
            [self.delegate addFriendComplete];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"isFriendComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"isFriendY"]];

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }

    addOrDeleteFriendView.userInteractionEnabled = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == [UIButton class]) {
        return YES;
    }
    return YES;
}

- (void)refreshMyPblishNum {

    UserRequest *request = [UserRequest new];
    [request requestMessageCount:[NSNumber numberWithLong:self.userId] success:^(NSNumber * _Nullable inviteMovieCount, NSNumber * _Nullable availableCouponCount, NSNumber * _Nullable needCommentOrderCount, NSNumber * _Nullable articleCount) {
        commentNumsLabel.text = articleCount.stringValue;
    } failure:^(NSError * _Nullable err) {
        
    }];
    
}



@end
