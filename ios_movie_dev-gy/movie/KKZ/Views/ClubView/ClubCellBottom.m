//
//  ClubCellBottom.m
//  KoMovie
//
//  Created by KKZ on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubCellBottom.h"
#import "CommonViewController.h"
#import "DateEngine.h"
#import "FriendHomeViewController.h"
#import "ImageEngineNew.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "RoundCornersButton.h"
#import "SubscriberHomeViewController.h"

#define marginX 15
#define headPortraitWith 33
#define marginImgToWord 10
#define marginWordToWord 3

#define WordTitleLabelHeight 15
#define WordTitleFont 13

#define MarginWordTitleLabelTop 1
#define MarginWordTitleLabelBottom 3

#define WordSubTitleLabelHeight 13
#define WordSubTitleFont 10

#define WordLineToLine 3
#define IconViewToIconView 20
#define ClubCellBottomHeight 33
#define WordTitleLabelLargeWith 150

#define SupportIconWith 13
#define SupportIconHeight 13

#define MarginIconWithNum 2

#define RoundCornersButtonFont 10

#define DateFont 10

#define SupportNumFont 11

@implementation ClubCellBottom

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostUserSupportSucceed" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        //用户头像
        headPortraitV = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, 0, headPortraitWith, headPortraitWith)];
        headPortraitV.layer.cornerRadius = headPortraitWith * 0.5;
        headPortraitV.clipsToBounds = YES;
        [headPortraitV setBackgroundColor:[UIColor clearColor]];
        [self addSubview:headPortraitV];

        UIButton *headPortraitVBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, 0, headPortraitWith * 2, headPortraitWith)];
        [headPortraitVBtn addTarget:self action:@selector(headPortraitVBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headPortraitVBtn];

        //用户名
        userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headPortraitV.frame) + marginImgToWord, MarginWordTitleLabelTop, WordTitleLabelLargeWith, WordTitleLabelHeight)];
        userNameLbl.textAlignment = NSTextAlignmentLeft;
        userNameLbl.font = [UIFont systemFontOfSize:WordTitleFont];
        userNameLbl.textColor = [UIColor blackColor];
        [self addSubview:userNameLbl];

        //用户类别
        userCategoryLbl = [[RoundCornersButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLbl.frame) + marginWordToWord, MarginWordTitleLabelTop, WordTitleLabelHeight, WordTitleLabelHeight - 2)];
        userCategoryLbl.titleColor = appDelegate.kkzBlue;
        userCategoryLbl.rimColor = appDelegate.kkzBlue;
        userCategoryLbl.rimWidth = 0.6;
        userCategoryLbl.fillColor = [UIColor clearColor];
        userCategoryLbl.titleName = @"";
        userCategoryLbl.titleFont = [UIFont systemFontOfSize:RoundCornersButtonFont];
        userCategoryLbl.cornerNum = 1.5;
        userCategoryLbl.userInteractionEnabled = NO;
        userCategoryLbl.hidden = NO;
        [self addSubview:userCategoryLbl];

        //点赞
        supportLbl = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - marginX, MarginWordTitleLabelTop, WordTitleLabelHeight, WordTitleLabelHeight)];
        supportLbl.font = [UIFont systemFontOfSize:SupportNumFont];
        supportLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:supportLbl];

        supportIconV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(supportLbl.frame) - marginWordToWord, MarginWordTitleLabelTop, SupportIconWith, SupportIconHeight)];
        [self addSubview:supportIconV];
        supportIconV.image = [UIImage imageNamed:@"supportIcon"]; //supportIcon

        //评论

        commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(supportIconV.frame) - IconViewToIconView, MarginWordTitleLabelTop, WordTitleLabelHeight, WordTitleLabelHeight)];
        commentLbl.font = [UIFont systemFontOfSize:SupportNumFont];
        commentLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:commentLbl];

        commentIconV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(commentLbl.frame) - marginWordToWord, MarginWordTitleLabelTop, SupportIconWith, SupportIconWith)];
        [self addSubview:commentIconV];
        commentIconV.image = [UIImage imageNamed:@"commentIcon"];

        //好友关系
        relationshipLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headPortraitV.frame) + marginImgToWord, CGRectGetMaxY(userNameLbl.frame) + WordLineToLine, screentWith, WordSubTitleLabelHeight)];
        relationshipLbl.textAlignment = NSTextAlignmentLeft;
        relationshipLbl.font = [UIFont systemFontOfSize:WordSubTitleFont];
        relationshipLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:relationshipLbl];

        //发帖的日期
        postDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userNameLbl.frame) + WordLineToLine, screentWith - marginX * 2, WordSubTitleLabelHeight)];
        postDateLbl.textAlignment = NSTextAlignmentRight;
        postDateLbl.font = [UIFont systemFontOfSize:DateFont];
        postDateLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:postDateLbl];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postUserSupportSucceed:) name:@"PostUserSupportSucceed" object:nil];
    }

    return self;
}

//更新用户信息
- (void)upLoadData {
    CGFloat viewX;
    CGFloat strWith;
    //加载头像
    if (self.clubPost.author.head && self.clubPost.author.head.length) {
        
//        [headPortraitV loadImageWithURL:self.headImage andSize:ImageSizeOrign defaultImagePath:@"avatarSImg"];
        
        [headPortraitV loadImageWithURL:self.clubPost.author.head andSize:ImageSizeOrign imgNameDefault:@"avatarSImg"];

    } else {
        headPortraitV.image = [UIImage imageNamed:@"avatarSImg"];
    }

    //加载用户名称以及计算用户名称Lbl的frame
    userNameLbl.text = self.clubPost.author.userName;

    CGSize userNameStrSize = [self.clubPost.author.userName sizeWithFont:[UIFont systemFontOfSize:WordTitleFont]];
    userNameLbl.frame = CGRectMake(CGRectGetMaxX(headPortraitV.frame) + marginImgToWord, MarginWordTitleLabelTop, userNameStrSize.width, WordTitleLabelHeight);

    //点赞的用户数
    if (self.supportNum.integerValue) {
        supportLbl.text = [NSString stringWithFormat:@"%@", self.supportNum];
    } else {
        supportLbl.text = @"0";
    }
    NSString *supportNumStr = [NSString stringWithFormat:@"%@", self.supportNum];
    CGSize supportNumSize = [supportNumStr sizeWithFont:[UIFont systemFontOfSize:SupportNumFont]];
    supportLbl.frame = CGRectMake(screentWith - marginX - supportNumSize.width - marginWordToWord, MarginWordTitleLabelTop, supportNumSize.width, WordTitleLabelHeight);
    supportIconV.frame = CGRectMake(CGRectGetMinX(supportLbl.frame) - marginWordToWord - SupportIconWith, MarginWordTitleLabelTop + MarginIconWithNum, SupportIconWith, SupportIconHeight);

    //评论的用户
    if (self.commentNum.integerValue) {
        commentLbl.text = [NSString stringWithFormat:@"%ld", (long) self.commentNum.integerValue];
    } else {
        commentLbl.text = @"0";
    }
    NSString *commentNumStr = [NSString stringWithFormat:@"%ld", (long) self.commentNum.integerValue];
    CGSize commentNumSize = [commentNumStr sizeWithFont:[UIFont systemFontOfSize:SupportNumFont]];
    commentLbl.frame = CGRectMake(CGRectGetMinX(supportIconV.frame) - IconViewToIconView - commentNumSize.width, MarginWordTitleLabelTop, commentNumSize.width, WordTitleLabelHeight);
    commentIconV.frame = CGRectMake(CGRectGetMinX(commentLbl.frame) - marginWordToWord - SupportIconWith, MarginWordTitleLabelTop + MarginIconWithNum, SupportIconWith, SupportIconWith);

    //好友关系
    relationshipLbl.text = self.clubPost.author.rel;

    //发帖的日期
    //    NSString *timeStr =  [[DateEngine sharedDateEngine] stringFromDate:self.clubPostDate withFormat:@"MM月dd日 HH:mm"];
    postDateLbl.text = self.clubPost.publishTime;

    //加载用户类别以及计算用户类别Lbl的frame
    if (1 == 1) {
        userCategoryLbl.titleColor = appDelegate.kkzBlue;
    }
    userCategoryLbl.titleName = self.clubPost.author.userGroup;

    CGSize userCategoryStrSize = [self.clubPost.author.userGroup sizeWithFont:[UIFont systemFontOfSize:RoundCornersButtonFont]];
    strWith = userCategoryStrSize.width + 8;
    viewX = CGRectGetMaxX(userNameLbl.frame) + marginWordToWord;

    if (viewX + strWith + marginWordToWord > CGRectGetMinX(commentIconV.frame)) {
        userNameLbl.frame = CGRectMake(CGRectGetMaxX(headPortraitV.frame) + marginImgToWord, MarginWordTitleLabelTop, CGRectGetMinX(commentIconV.frame) - strWith - marginWordToWord - marginWordToWord - (CGRectGetMaxX(headPortraitV.frame) + marginImgToWord), WordTitleLabelHeight);
        [userNameLbl setBackgroundColor:[UIColor clearColor]];
        userCategoryLbl.frame = CGRectMake(CGRectGetMaxX(userNameLbl.frame) + marginWordToWord, MarginWordTitleLabelTop, strWith, WordTitleLabelHeight);

    } else {
        userNameLbl.frame = CGRectMake(CGRectGetMaxX(headPortraitV.frame) + marginImgToWord, MarginWordTitleLabelTop, userNameStrSize.width, WordTitleLabelHeight);
        userCategoryLbl.frame = CGRectMake(viewX, MarginWordTitleLabelTop, strWith, WordTitleLabelHeight);
    }

    if (self.clubPost.author.userGroup.length) {
        userCategoryLbl.hidden = NO;
    } else {
        userCategoryLbl.hidden = YES;
    }
}

/**
 *  点击用户头像或者用户昵称进入用户主页
 */

- (void)headPortraitVBtnClicked:(UIButton *)btn {

    if (self.clubPost.author.userGroupId.integerValue == 5) {

        SubscriberHomeViewController *ctr = [[SubscriberHomeViewController alloc] init];

        ctr.userId = self.clubPost.author.userId.unsignedIntValue;

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];

    } else {

        FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];

        ctr.userId = self.clubPost.author.userId.unsignedIntValue;

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
}

-(void)postUserSupportSucceed:(NSNotification *)not{
    NSNumber *postID = not.object[@"postId"];
    if ([self.clubPost.articleId isEqualToNumber:postID]) {
        if (self.supportNum.integerValue) {
            NSInteger num = self.supportNum.integerValue + 1;
            supportLbl.text = [NSString stringWithFormat:@"%ld", (long) num];

        } else {
            supportLbl.text = @"1";
        }
    }
}

@end
