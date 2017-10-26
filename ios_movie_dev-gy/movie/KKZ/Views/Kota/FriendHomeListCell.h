//
//  FriendHomeListCell.h
//  KoMovie
//
//  Created by avatar on 14-11-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioButton.h"
#import "RoundCornersButton.h"
#import "AudioBarView.h"
#import "FriendHomeMessage.h"
#import "Movie.h"
#import "Cinema.h"
#import "Comment.h"
#import "RatingView.h"

@interface FriendHomeListCell : UITableViewCell<RatingViewDelegate>
{
    UIImageView *avatarImageView,*moviePoster,*textViewBg,*supportImgView,*opposeImgView;
    UIView *movieView,*titleView,*commentView;
    UILabel *titleLbl,*titleLbl1,*titleLbl2,*titleLbl3,*timeLbl,*movieTitleLbl,*scoreLbl,*directerLbl,*leaderLbl,*scorestarLbl,*textLabel,*likeNumLabel,*dislikeNumLabel,*newLbl;
    RoundCornersButton *movieIntroduce;
    RatingView *starView;
    UIView *line,*operactionView;
    UIView *tapSupportView,*tapOppositView;
    UIView *vBg;
    
}


@property (nonatomic,assign) BOOL isInFriendHome; //是否在好友家，当前逻辑相同
@property (nonatomic,assign)unsigned int currentUid; //当前的用户
@property (nonatomic, strong) FriendHomeMessage *friendMessage;
@property (nonatomic, strong) AudioBarView *audioBarView;

- (void)updateLayout;

@end
