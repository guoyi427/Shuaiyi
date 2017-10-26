//
//  KotaHomePageMessCell.h
//  KoMovie
//
//  Created by avatar on 14-12-2.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendHomeMessage.h"
#import "AudioButton.h"
#import "RoundCornersButton.h"
#import "AudioBarView.h"
#import "KKZUser.h"
#import "kotaComment.h"

@interface KotaHomePageMessCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UIImageView *avatarImageView,*posterImgV,*moviePoster;
    UILabel *timeLbl,*nickNameLbl,*messageLbl,*movieTitleLbl,*ticketMessage,*cinemaNameLbl,*commentTextLbl;
    UIView *movieView,*commentView;
    UIView *line;
    UIView *vBg;
    unsigned int userId;
    NSString *userName;
}

@property (nonatomic, strong) FriendHomeMessage *friendMessage;
@property (nonatomic, strong) FriendHomeMessage *friendMessageMeb;
@property (nonatomic, strong) NSString *cinemaNameType;
@property (nonatomic, strong) NSString *movieTimeType;
@property (nonatomic, strong) NSString *screenDegreeType;
@property (nonatomic, strong) NSString *screenSizeType;
@property (nonatomic, strong) NSString *movieNameType;
@property (nonatomic, strong) NSString *hallNameType;
@property (nonatomic, strong) NSString *langType;
@property (nonatomic, strong) NSString *imageUrlYN;
@property (nonatomic, strong) AudioBarView *audioBarView;
@property (nonatomic, strong) kotaComment *kotacomnt;
@property (nonatomic, strong) NSDate *movieTime;
@property (nonatomic, assign) BOOL isInFriendHome;
@property (nonatomic,assign)int userIdNow;

-(void)updateLayout;
@end
