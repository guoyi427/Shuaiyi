//
//  MyFavHeaderView.h
//  KKZ
//
//  Created by xuyang on 13-4-10.
//  Copyright 2011年 kokozu. All rights reserved.
// 我的个人中心，自己的表头

#import <UIKit/UIKit.h>
#import "RoundCornersButton.h"
#import "KKZUser.h"
#import "EGORefreshTableHeaderView.h"

@protocol MyFavHeaderViewDelegate <NSObject>

@optional

- (void)handleTouchOnAvatar;
-(void)refreshUserInfoComplete:(KKZUser *)user;
-(void)gotoRefresh;
-(void)checkUserIsFriendComplete;
-(void)addFriendComplete;

@end

static NSInteger MyFavHeaderMinHeight = 166;
static NSInteger FoldedViewMinY = -72;
static NSInteger FoldedViewMaxY = 47;
static NSInteger FoldedViewHeight = 132;

@interface MyFavHeaderView: UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    
    UIScrollView *allScrollView;
    UIView *contentScrollView;
    UIView *centerWhiteBarView;
    EGORefreshTableHeaderView *refreshHeaderView;
    UILabel * nameLabel;
    UILabel * fansNumLabel;
    UILabel* favoriteNumLabel;
    UILabel *messageNumLabel;
    UILabel *commentNumsLabel;
    UILabel *wantNumsLabel;
    UILabel *watchedBgNumsLabel;
    UILabel *goodFriendsNumLabel;
    UILabel * ageLabel;
    UIImage * roundImg;
    UIImageView * avatarImageView;
    UIImageView * genderImageView;
    UIImageView * avatarBg, *vipIcon,*noMessageReadImage;
    RoundCornersButton * collectRectBtn;
    CGRect attentionRect,seenRect,wantseeRect,commentRect;
    UILabel *attentionLbl,*seenLbl,*wantseeLbl;

}

@property (nonatomic, weak) id <MyFavHeaderViewDelegate> delegate;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic,strong)KKZUser *user;
@property (nonatomic,assign)BOOL isFriend;
@property(nonatomic,copy)NSString *avatarPath;
@property (nonatomic, strong)UIImageView *homeBackgroundViewY;
@property(nonatomic,copy)NSString *userNickname;
-(void)updateLayout;
-(void)refreshUserDetails;
-(void)setNewFriendCount:(NSNumber *)count;
-(void)addFriend;
@end
