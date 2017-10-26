//
//  KotaListForMovieCell.m
//  KoMovie
//
//  Created by avatar on 14-11-24.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//


#import "DataEngine.h"
#import "DateEngine.h"
#import "FavoriteTask.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "KotaListForMovieCell.h"
#import "KotaTask.h"
#import "Movie.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import "applyForViewController.h"
#import "kotaComment.h"

#define tagKotaByMovie 5555

enum {
    appliedKotaStatus = 1, //self.kota.status == 1 已申请，等待回复
    acceptedKotaStatus, //self.kota.status == 2 你同意了对方的申请
    refusedKotaStatus, //self.kota.status == 3 你拒绝了对方的申请
} KotaStatus;

@implementation KotaListForMovieCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RenewStatusApplyY" object:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 198)];
        [bgV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bgV];

        // 头像图片
        posterImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kDimensControllerHPadding, 20, 90, 90)];
        posterImgV.userInteractionEnabled = YES;
        posterImgV.layer.cornerRadius = 4;
        posterImgV.layer.masksToBounds = YES;
        posterImgV.image = [UIImage imageNamed:@"avatarSImg"];
        posterImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:posterImgV];

        left = kDimensControllerHPadding + 90 + 15;

        // 用户昵称
        lblshareNickname = [[UILabel alloc] initWithFrame:CGRectMake(left, 20, 90, 20)];
        [self addSubview:lblshareNickname];
        lblshareNickname.font = [UIFont systemFontOfSize:kTextSizeTitle];
        lblshareNickname.textColor = [UIColor colorWithRed:37 / 255.0 green:88 / 255.0 blue:144 / 255.0 alpha:1.0];
        lblshareNickname.backgroundColor = [UIColor clearColor];

        // 正在约电影
        lblApplying = [[UILabel alloc] initWithFrame:CGRectMake(135, 15, 90, 20)];
        [self addSubview:lblApplying];
        lblApplying.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblApplying.textColor = [UIColor grayColor];
        lblApplying.backgroundColor = [UIColor clearColor];

        CGFloat y = 40;

        // 影院名称
        lblcinemaName = [[UILabel alloc] initWithFrame:CGRectMake(left, y, 170, 20)];
        [self addSubview:lblcinemaName];
        lblcinemaName.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblcinemaName.textColor = [UIColor grayColor];
        lblcinemaName.backgroundColor = [UIColor clearColor];

        y += 16;

        // 创建时间
        lblcreateTime = [[UILabel alloc] initWithFrame:CGRectMake(left, y, screentWith - 130, 20)];
        [self addSubview:lblcreateTime];
        lblcreateTime.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblcreateTime.textColor = [UIColor grayColor];
        lblcreateTime.backgroundColor = [UIColor clearColor];

        y += 23;

        applyMeBtn = [[UIButton alloc] initWithFrame:CGRectMake(115, y, 70, 25)];
        [applyMeBtn setBackgroundImage:[UIImage imageNamed:@"acceptMe"] forState:UIControlStateNormal];
        [applyMeBtn addTarget:self action:@selector(acceptMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:applyMeBtn];

        refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(195, y, 50, 25)];
        [refuseBtn addTarget:self action:@selector(refuseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [refuseBtn setBackgroundImage:[UIImage imageNamed:@"refuseMe"] forState:UIControlStateNormal];
        [self addSubview:refuseBtn];

        applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(left, y, 133, 30)];
        [applyBtn addTarget:self action:@selector(applyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:applyBtn];

        commentView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, screentWith - 20, 40)];
        [commentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:commentView];

        lblkotaContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, screentWith - 20, 40)];
        lblkotaContent.font = [UIFont systemFontOfSize:14];
        lblkotaContent.numberOfLines = 0;
        lblkotaContent.textColor = [UIColor grayColor];
        lblkotaContent.backgroundColor = [UIColor clearColor];
        [self addSubview:lblkotaContent];

        // 文字评论
        commentTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith - 20, 40)];
        commentTextLbl.backgroundColor = [UIColor clearColor];
        commentTextLbl.textColor = [UIColor grayColor];
        commentTextLbl.font = [UIFont systemFontOfSize:14];
        commentTextLbl.numberOfLines = 0;
        [commentView addSubview:commentTextLbl];

        // 语音评论
        _audioBarView = [[AudioBarView alloc] initWithFrame:CGRectMake(0, 5, screentWith - 20, 40)];
        _audioBarView.minWidth = 110;
        _audioBarView.maxWidth = 110;
        _audioBarView.height = 30;
        [commentView addSubview:_audioBarView];

        lblapplyTime = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 60, 20)];
        [self addSubview:lblapplyTime];
        lblapplyTime.font = [UIFont systemFontOfSize:14];
        lblapplyTime.textColor = [UIColor grayColor];
        lblapplyTime.backgroundColor = [UIColor clearColor];

        nearImgV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 140, 10, 11)];
        [self addSubview:nearImgV];

        lbldistance = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 80, 20)];
        [self addSubview:lbldistance];
        lbldistance.font = [UIFont systemFontOfSize:14];
        lbldistance.textColor = [UIColor grayColor];
        lbldistance.backgroundColor = [UIColor clearColor];

        loveImgV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 50 - 18, 139, 14, 14)];
        [self addSubview:loveImgV];
        [loveImgV setImage:[UIImage imageNamed:@"kotaloveY"]];

        lbllove = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 50, 140, 35, 20)];
        [self addSubview:lbllove];
        lbllove.font = [UIFont systemFontOfSize:14];
        lbllove.textColor = [UIColor colorWithRed:235 / 255.0 green:132 / 255.0 blue:159 / 255.0 alpha:1.0];
        lbllove.backgroundColor = [UIColor clearColor];

        loveImgVR = [[UIView alloc] init];
        [self addSubview:loveImgVR];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [posterImgV addGestureRecognizer:tap];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAcceptStatus:) name:@"RenewStatusApplyY" object:nil];
    }
    return self;
}

//申请成功之后改变按钮的状态
- (void)updateAcceptStatus:(NSNotification *) not{
    if (self.kotaRmb.kotaId == self.kota.kotaId) {
        self.kota.status = appliedKotaStatus;
        applyBtn.tag = 1 + tagKotaByMovie;
        [applyBtn setBackgroundImage:[UIImage imageNamed:@"appliedBtnY"] forState:UIControlStateNormal];
        //已申请，等待回复
    };
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:posterImgV];
    if (CGRectContainsPoint(posterImgV.frame, point)) {

        if (![[NetworkUtil me] reachable]) {
            return;
        }
        FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
        ctr.userId = self.kota.userId;
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
}

- (void)reloadData {
    commentTextLbl.hidden = YES;
    _audioBarView.hidden = YES;
    lblkotaContent.hidden = YES;
    commentView.hidden = YES;
    lblcinemaName.hidden = YES;
    lblcreateTime.hidden = YES;

    applyBtn.hidden = YES;
    refuseBtn.hidden = YES;
    applyMeBtn.hidden = YES;

    [posterImgV loadImageWithURL:self.kota.shareHeadimg andSize:ImageSizeMiddle imgNameDefault:@"avatarSImg"];

    KKZUser *user = [KKZUser getUserWithId:self.kota.shareUserId];
    lblshareNickname.text = user.nickName;
    CGSize s = [self.kota.shareNickname sizeWithFont:[UIFont systemFontOfSize:kTextSizeTitle]];
    lblshareNickname.frame = CGRectMake(left, 20, s.width > (screentWith - 230) ? (screentWith - 230) : s.width, 20);

    lblApplying.text = @"正在约电影";
    lblApplying.frame = CGRectMake(CGRectGetMaxX(lblshareNickname.frame) + 3, 20, screentWith - 138 - lblshareNickname.frame.size.width, 20);

    applyBtn.hidden = NO;
    refuseBtn.hidden = YES;
    applyMeBtn.hidden = YES;

    //    query_share_list
    //    这个接口里
    //    kotaType=0是购票分享的约电影
    //    kotaType=2是普通分享的约电影

    if (self.kota.kotaType == 2) {

        commentView.hidden = NO;
        commentTextLbl.hidden = NO;
        _audioBarView.hidden = NO;
        lblkotaContent.hidden = YES;

        applyBtn.hidden = NO;
        [applyBtn setBackgroundImage:[UIImage imageNamed:@"applyBtnY"] forState:UIControlStateNormal];
        applyBtn.tag = tagKotaByMovie; // 申请与TA一起观影

        kotaComment *kotacomnt = [kotaComment getKotaCommentMessageWithId:self.kota.kotaCommentId];

        if (kotacomnt.commentType == 1) {

            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;
            commentTextLbl.text = kotacomnt.content;

        } else if (kotacomnt.commentType == 2) {

            commentTextLbl.hidden = YES;
            if (kotacomnt.attachPath && kotacomnt.attachPath.length > 0 && ![kotacomnt.attachPath isEqualToString:@"(null)"]) {
                [_audioBarView updateWithAudioURL:kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:kotacomnt.attachLength]];
                _audioBarView.hidden = NO;
            }
        } else {
            commentTextLbl.hidden = YES;
            _audioBarView.hidden = YES;
            lblkotaContent.hidden = YES;
            commentView.hidden = YES;
        }
    } else if (self.kota.kotaType == 0) {

        lblcinemaName.hidden = NO;
        lblcreateTime.hidden = NO;

        commentTextLbl.hidden = YES;
        _audioBarView.hidden = YES;
        lblkotaContent.hidden = NO;
        commentView.hidden = YES;

        applyBtn.hidden = NO;
        [applyBtn setBackgroundImage:[UIImage imageNamed:@"applyBtnY"] forState:UIControlStateNormal];
        applyBtn.tag = tagKotaByMovie; // 申请与TA一起观影

        [lblcinemaName setBackgroundColor:[UIColor clearColor]];

        if (self.kota.cinemaName.length) {
            lblcinemaName.text = self.kota.cinemaName;
        } else {
            lblcinemaName.text = @" ";
        }

        if ([self.kota.screenDegree isEqualToNumber:@2]) {

            self.screenDegreeType = @"2D";

        } else if ([self.kota.screenDegree isEqualToNumber:@3]) {

            self.screenDegreeType = @"3D";

        } else if ([self.kota.screenDegree isEqualToNumber:@4]) {
            self.screenDegreeType = @"4D";
        } else {
            self.screenDegreeType = @" ";
        }

        if ([self.kota.screenSize isEqualToNumber:@0]) {
            self.screenSizeType = @" ";
        } else if ([self.kota.screenSize isEqualToNumber:@1]) {
            self.screenSizeType = @"imax";
        } else if ([self.kota.screenSize isEqualToNumber:@2]) {
            self.screenSizeType = @"dmax";
        }

        if ([[DateEngine sharedDateEngine] shortDateStringFromDateNYR:self.kota.ticketTime].length) {
            self.movieTimeType = [[DateEngine sharedDateEngine] stringFromDate:self.kota.ticketTime withFormat:@"MM月dd日 HH:mm"];
        } else {
            self.movieTimeType = @" ";
        }

        if ([self.kota.lang isEqual:[NSNull null]]) {
            self.langType = @" ";
        } else if ([[NSString stringWithFormat:@"%@", self.kota.lang] isEqualToString:@"(null)"]) {
            self.langType = @" ";
        } else {
            self.langType = self.kota.lang;
        }

        lblcreateTime.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.movieTimeType, self.screenSizeType, self.screenDegreeType, self.langType];
        lblkotaContent.text = @"今天没人陪我去看，有没有朋友愿意一起看这场电影？";
    }

    if (self.kota.status == appliedKotaStatus) {

        kotaComment *kotacomnt = [kotaComment getKotaCommentMessageWithId:self.kota.kotaCommentId];

        if (kotacomnt.commentType == 1) {

            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;

            commentTextLbl.text = kotacomnt.content;

        } else if (kotacomnt.commentType == 2) {

            commentTextLbl.hidden = YES;
            if (kotacomnt.attachPath && kotacomnt.attachPath.length > 0 && ![kotacomnt.attachPath isEqualToString:@"(null)"]) {
                [_audioBarView updateWithAudioURL:kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:kotacomnt.attachLength]];
                _audioBarView.hidden = NO;
            }
        } else {
            commentTextLbl.hidden = YES;
            _audioBarView.hidden = YES;
            lblkotaContent.hidden = YES;
            commentView.hidden = YES;
        }
        [applyBtn setBackgroundImage:[UIImage imageNamed:@"appliedBtnY"] forState:UIControlStateNormal];
        applyBtn.tag = 1 + tagKotaByMovie;
    }

    CGFloat y = CGRectGetMaxY(commentView.frame) + 5;
    lblapplyTime.text = [[DateEngine sharedDateEngine] formattedStringFromDateNew:self.kota.createTime];
    lblapplyTime.frame = CGRectMake(15, y, 60, 20);

    if ([self.kota.distance intValue] == 9999999) { //距离特别远的情况下，距离图标隐藏
        lbldistance.hidden = YES;
        nearImgV.hidden = YES;
    } else {
        nearImgV.hidden = NO;
        nearImgV.image = [UIImage imageNamed:@"nearByIcon"];
        nearImgV.frame = CGRectMake(80, y + 4, 10, 11);
        lbldistance.hidden = NO;
        lbldistance.text = [NSString stringWithFormat:@"%.2fkm", [self.kota.distance intValue] * 0.001];
        lbldistance.frame = CGRectMake(92, y, 80, 20);
    }

    loveImgV.frame = CGRectMake(screentWith - 70, y + 5, 14, 12);
    lbllove.text = [NSString stringWithFormat:@"%d", self.kota.loveNum];
    lbllove.frame = CGRectMake(screentWith - 50, y, 35, 20);
    loveImgVR.frame = CGRectMake(screentWith - 80, y - 3, 65, 20);

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 197, screentWith, 1)];
    [v setBackgroundColor:[UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.0]];
    [self addSubview:v];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    CGRect likeRect = loveImgVR.frame;
    if (CGRectContainsPoint(likeRect, point)) { //支持
        if (self.kota.userId == [[DataEngine sharedDataEngine].userId intValue]) {
            [appDelegate showAlertViewForTitle:@"" message:@"您不能对自己的相关信息进行操作！" cancelButton:@"确定"];
            return;
        }
        [self handleTouchOnLove];
    }
}

- (void)applyBtnClicked:(UIButton *)btn {
    DLog(@"申请状态按钮被点击，申请状态发生变化");

    if (![[NetworkUtil me] reachable]) {
        return;
    }
    KKZUser *user = [KKZUser getUserWithId:self.kota.shareUserId];
    if (user.userId == [DataEngine sharedDataEngine].userId.intValue) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"不能对自己进行操作！"
                              cancelButton:@"OK"];

    } else {
        if (btn.tag == tagKotaByMovie) {

            self.kotaRmb = self.kota;
            applyForViewController *vC = [[applyForViewController alloc] init];
            vC.cinemaName = self.kota.cinemaName;
            vC.filmName = self.kota.movieName;
            vC.shareHeadimg = self.kota.shareHeadimg;
            vC.shareNickname = self.kota.shareNickname;
            vC.screenDegree = self.kota.screenDegree;
            vC.screenSize = self.kota.screenSize;
            vC.lang = self.kota.lang;
            vC.createTime = self.kota.ticketTime;
            vC.kotaId = [NSNumber numberWithInt:self.kota.kotaId];
            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:vC animation:CommonSwitchAnimationSwipeR2L];
        } else if (btn.tag == tagKotaByMovie + 1) {
        }
    }
}

//点赞
- (void)handleTouchOnLove {
    FavoriteTask *task = [[FavoriteTask alloc] initAddKotaLikeWithUserId:[NSString stringWithFormat:@"%d", self.kota.userId]
                                                                withType:@2
                                                            withTargetId:[NSString stringWithFormat:@"%d", self.kota.kotaId]
                                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                    if (succeeded) {
                                                                        self.kota.loveNum += 1;
                                                                        lbllove.text = [NSString stringWithFormat:@"%d", self.kota.loveNum];
                                                                    } else {
                                                                        [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                    }
                                                                }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)acceptMeBtnClicked:(UIButton *)btn {
    KotaTask *task = [[KotaTask alloc] initAcceptMyAppointmentWithKotaId:[NSString stringWithFormat:@"%d", self.kota.kotaId]
                                                               andStatus:acceptedKotaStatus
                                                               andUserId:[NSString stringWithFormat:@"%d", self.kota.userId]
                                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                    if (succeeded) {
                                                                        [appDelegate showAlertViewForTitle:@"" message:@"您同意了对方的申请" cancelButton:@"OK"];
                                                                    } else {
                                                                        [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                    }
                                                                }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)refuseBtnClicked:(UIButton *)btn {
    KotaTask *task = [[KotaTask alloc] initAcceptMyAppointmentWithKotaId:[NSString stringWithFormat:@"%d", self.kota.kotaId]
                                                               andStatus:refusedKotaStatus
                                                               andUserId:[NSString stringWithFormat:@"%d", self.kota.userId]
                                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                    if (succeeded) {
                                                                        [appDelegate showAlertViewForTitle:@"" message:@"您拒绝了对方的申请" cancelButton:@"OK"];
                                                                    } else {
                                                                        [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                    }
                                                                }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

@end
