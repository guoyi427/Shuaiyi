//
//  KotaHomePageMessCell.m
//  KoMovie
//
//  Created by avatar on 14-12-2.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "Cinema.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "KotaHomePageMessCell.h"
#import "KotaTask.h"
#import "KotaTicketMessage.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import "applyForViewController.h"
#import "kotaComment.h"

#define tagMark 55555
#define tagMarkMe 66666

@implementation KotaHomePageMessCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RenewStatusApplyY" object:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        //为了适配iOS6（cell背景透明）
        vBg = [[UIView alloc] init];
        [vBg setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:vBg];

        //头像
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 35, 35)];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
        avatarImageView.userInteractionEnabled = YES;
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        CALayer *l = avatarImageView.layer; //头像设置成圆形
        [l setMasksToBounds:YES];
        [l setCornerRadius:17.5];
        UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [avatarBtn addTarget:self action:@selector(gotoUserHomeView) forControlEvents:UIControlEventTouchUpInside];
        avatarBtn.frame = CGRectMake(0, 0, 35, 35);
        [avatarImageView addSubview:avatarBtn];

        nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 175, 20)];
        nickNameLbl.text = @"章鱼电影";
        nickNameLbl.textColor = [UIColor blackColor];
        nickNameLbl.backgroundColor = [UIColor clearColor];
        nickNameLbl.textAlignment = NSTextAlignmentLeft;
        nickNameLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:nickNameLbl];

        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 120, 20, 105, 20)];
        timeLbl.text = @"未知";
        timeLbl.textColor = [UIColor grayColor];
        timeLbl.backgroundColor = [UIColor clearColor];
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeLbl];

        commentView = [[UIView alloc] init];
        [commentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:commentView];

        //文字评论
        commentTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith - 75, 60)];
        commentTextLbl.backgroundColor = [UIColor clearColor];
        commentTextLbl.textColor = [UIColor grayColor];
        commentTextLbl.font = [UIFont systemFontOfSize:14];
        commentTextLbl.numberOfLines = 0;
        [commentView addSubview:commentTextLbl];

        //语音评论

        _audioBarView = [[AudioBarView alloc] initWithFrame:CGRectMake(0, 5, screentWith - 75, 40)];
        _audioBarView.minWidth = 110;
        _audioBarView.maxWidth = 110;
        _audioBarView.height = 30;
        [commentView addSubview:_audioBarView];

        movieView = [[UIView alloc] initWithFrame:CGRectMake(60, 115, screentWith - 75, 110)];
        [movieView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:movieView];

        UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0 - 3, 0 - 3, 75 + 6, 105 + 6)];
        shadowImg.image = [UIImage imageNamed:@"post_black_shadow"];
        shadowImg.contentMode = UIViewContentModeScaleAspectFill;
        shadowImg.clipsToBounds = YES;
        [movieView addSubview:shadowImg];

        //海报
        moviePoster = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 105)];
        moviePoster.contentMode = UIViewContentModeScaleAspectFill;
        moviePoster.clipsToBounds = YES;
        [moviePoster setBackgroundColor:[UIColor clearColor]];
        [movieView addSubview:moviePoster];

        //电影详细信息
        movieTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, screentWith - 160, 20)];
        movieTitleLbl.textColor = [UIColor blackColor];
        movieTitleLbl.backgroundColor = [UIColor clearColor];
        movieTitleLbl.font = [UIFont systemFontOfSize:14];
        [movieView addSubview:movieTitleLbl];

        cinemaNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, screentWith - 160, 16)];
        cinemaNameLbl.textColor = [UIColor blackColor];
        cinemaNameLbl.backgroundColor = [UIColor clearColor];
        cinemaNameLbl.font = [UIFont systemFontOfSize:12];
        [movieView addSubview:cinemaNameLbl];

        ticketMessage = [[UILabel alloc] initWithFrame:CGRectMake(85, 40, screentWith - 160, 30)];
        ticketMessage.textColor = [UIColor grayColor];
        ticketMessage.numberOfLines = 0;
        ticketMessage.backgroundColor = [UIColor clearColor];
        ticketMessage.font = [UIFont systemFontOfSize:12];
        [movieView addSubview:ticketMessage];

        line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0]];
        [self addSubview:line];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAcceptStatus:) name:@"RenewStatusApplyY" object:nil];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

        [moviePoster addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:moviePoster];

    //设置

    if (CGRectContainsPoint(moviePoster.frame, point)) {

        MovieDetailViewController *mdv = [[MovieDetailViewController alloc] initCinemaListForMovie:[NSNumber numberWithInt:self.friendMessage.movieId]];
        
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:mdv animation:CommonSwitchAnimationBounce];
        return;
    }
}

- (void)updateLayout {

    _audioBarView.hidden = YES;
    commentTextLbl.hidden = YES;
    messageLbl.hidden = YES;
    [vBg setBackgroundColor:[UIColor whiteColor]];

    Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];
    KotaTicketMessage *ticketMess = [KotaTicketMessage getKotaTicketMessageWithId:self.friendMessage.kotaId];

    if ([ticketMess.ticketTime isEqual:[NSNull null]]) {
        self.movieTimeType = @"";
    } else {

        self.movieTimeType = [[DateEngine sharedDateEngine] shortDateStringFromDateMdHs:[[DateEngine sharedDateEngine] dateFromString:ticketMess.ticketTime]];
    }

    if (ticketMess.screenDegree == 2) {

        self.screenDegreeType = @"2D";

    } else if (ticketMess.screenDegree == 3) {

        self.screenDegreeType = @"3D";

    } else if (ticketMess.screenDegree == 4) {

        self.screenDegreeType = @"4D";

    } else {

        self.screenDegreeType = @"";
    }

    if (ticketMess.screenSize == 0) {

        self.screenSizeType = @"普通";

    } else if (ticketMess.screenSize == 1) {

        self.screenSizeType = @"imax";

    } else if (ticketMess.screenSize == 2) {

        self.screenSizeType = @"dmax";
    }

    if (movie.movieName.length) {
        self.movieNameType = [NSString stringWithFormat:@"《%@》", movie.movieName];
    } else {
        self.movieNameType = @"";
    }

    if ([ticketMess.hallName isEqual:[NSNull null]]) {

        self.hallNameType = @"";
    } else if ([ticketMess.hallName isEqualToString:@"<null>"]) {
        self.hallNameType = @"";

    } else {
        self.hallNameType = ticketMess.hallName;
    }

    if ([ticketMess.cinemaName isEqual:[NSNull null]]) {

        self.cinemaNameType = @"";
    } else if ([ticketMess.cinemaName isEqualToString:@"<null>"]) {
        self.cinemaNameType = @"";

    } else {
        self.cinemaNameType = ticketMess.cinemaName;
    }

    if ([ticketMess.lang isEqual:[NSNull null]]) {

        self.langType = @"";
    } else if ([ticketMess.lang isEqualToString:@"<null>"]) {
        self.langType = @"";

    } else {
        self.langType = ticketMess.lang;
    }

    if (ticketMess.ticketId) {

        cinemaNameLbl.hidden = NO;
        ticketMessage.hidden = NO;

        cinemaNameLbl.text = self.cinemaNameType;
        ticketMessage.text = [NSString stringWithFormat:@"%@\n%@%@%@", self.movieTimeType, self.screenDegreeType, self.screenSizeType, self.langType];
    }

    else {
        cinemaNameLbl.hidden = YES;
        ticketMessage.hidden = YES;
    }

    if (self.friendMessage.status == 0 || self.friendMessage.status == 7) {

        kotaComment *kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];

        if (kotacomnt.commentType == 1) {

            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;
            commentTextLbl.text = kotacomnt.content;
            CGSize s = [kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                     constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
            commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
            movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
            line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
        } else if (kotacomnt.commentType == 2) {

            commentTextLbl.hidden = YES;
            if (kotacomnt.attachPath && kotacomnt.attachPath.length > 0 && ![kotacomnt.attachPath isEqualToString:@"(null)"]) {
                [_audioBarView updateWithAudioURL:kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:kotacomnt.attachLength]];
                _audioBarView.hidden = NO;
            }

            commentView.frame = CGRectMake(60, 45, (screentWith - 320) + 235, 45);

            movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);

            line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);

            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
            vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
        } else {

            if (ticketMess.ticketId) {

                _audioBarView.hidden = YES;
                commentTextLbl.hidden = NO;

                NSString *str = [NSString stringWithFormat:@"我购买了一张%@%@%@%@%@%@%@电影票，有想与我一起看的吗", self.cinemaNameType, self.movieTimeType, self.movieNameType, self.hallNameType, self.screenDegreeType, self.screenSizeType, self.langType];
                commentTextLbl.text = str;

                [commentTextLbl setBackgroundColor:[UIColor clearColor]];
                commentTextLbl.frame = CGRectMake(0, 0, (screentWith - 320) + 235, 65);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, 65);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, 239, screentWith, 1);
                vBg.frame = CGRectMake(0, 0, screentWith, 240);

            } else {

                [commentTextLbl setBackgroundColor:[UIColor clearColor]];
                commentTextLbl.frame = CGRectMake(0, 0, (screentWith - 320) + 235, 65);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, 65);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, 239, screentWith, 1);
                vBg.frame = CGRectMake(0, 0, screentWith, 240);
            }
        }
    }

    if (self.friendMessage.status == 1) {

        if (self.friendMessage.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.requestKotaCommentId];

        } else

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];

        KotaTicketMessage *ticketMess = [KotaTicketMessage getKotaTicketMessageWithId:self.kotacomnt.kotaId];
        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:60 * 60];

        if ([[[DateEngine sharedDateEngine] dateFromString:ticketMess.ticketTime] compare:lateDate] < 0) {

            CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                          constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;

            commentTextLbl.text = @"约电影已过期";

            commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
            commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
            movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
            line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

        } else {

            if (self.kotacomnt.commentType == 1) {

                _audioBarView.hidden = YES;
                commentTextLbl.hidden = NO;

                commentTextLbl.text = self.kotacomnt.content;

                CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                              constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
            } else if (self.kotacomnt.commentType == 2) {

                commentTextLbl.hidden = YES;
                if (self.kotacomnt.attachPath && self.kotacomnt.attachPath.length > 0 && ![self.kotacomnt.attachPath isEqualToString:@"(null)"]) {
                    [_audioBarView updateWithAudioURL:self.kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:self.kotacomnt.attachLength]];
                    _audioBarView.hidden = NO;
                }

                commentView.frame = CGRectMake(60, 45, (screentWith - 320) + 235, 45);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
            } else {

                if (ticketMess.ticketId) {

                    _audioBarView.hidden = YES;
                    commentTextLbl.hidden = NO;
                    [commentTextLbl setBackgroundColor:[UIColor clearColor]];

                    NSString *str = [NSString stringWithFormat:@"我购买了一张%@%@%@%@%@%@%@电影票，有想与我一起看的吗", self.cinemaNameType, self.movieTimeType, self.movieNameType, self.hallNameType, self.screenDegreeType, self.screenSizeType, self.langType];

                    commentTextLbl.text = str;
                    [commentTextLbl setBackgroundColor:[UIColor clearColor]];
                    commentTextLbl.frame = CGRectMake(0, 0, (screentWith - 320) + 235, 65);
                    commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, 65);
                    movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                    line.frame = CGRectMake(0, 239, screentWith, 1);
                    vBg.frame = CGRectMake(0, 0, screentWith, 240);

                } else {

                    [commentTextLbl setBackgroundColor:[UIColor clearColor]];
                    commentTextLbl.frame = CGRectMake(0, 0, (screentWith - 320) + 235, 65);
                    commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, 65);
                    movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                    line.frame = CGRectMake(0, 239, screentWith, 1);
                    vBg.frame = CGRectMake(0, 0, screentWith, 240);
                }
            }
        }
    }
    if (self.friendMessage.status == 2) {

        KotaTicketMessage *ticketMess = [KotaTicketMessage getKotaTicketMessageWithId:self.friendMessage.kotaId];

        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:60 * 60];
        if (ticketMess.ticketId) {

            if ([[[DateEngine sharedDateEngine] dateFromString:ticketMess.ticketTime] compare:lateDate] < 0) {

                _audioBarView.hidden = YES;
                commentTextLbl.hidden = NO;

                NSString *str = @"约电影失败";

                commentTextLbl.text = str;

                CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:14]

                           constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];
                commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            }

            else {

                if (self.friendMessage.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

                    self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.requestKotaCommentId];
                    if (self.kotacomnt.commentType == 1) {
                        _audioBarView.hidden = YES;
                        commentTextLbl.hidden = NO;
                        commentTextLbl.text = self.kotacomnt.content;
                        CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                                      constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                        commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                        commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                        movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                        line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                        self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                        vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                    } else if (self.kotacomnt.commentType == 2) {

                        commentTextLbl.hidden = YES;
                        if (self.kotacomnt.attachPath && self.kotacomnt.attachPath.length > 0 && ![self.kotacomnt.attachPath isEqualToString:@"(null)"]) {
                            [_audioBarView updateWithAudioURL:self.kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:self.kotacomnt.attachLength]];
                            _audioBarView.hidden = NO;
                        }

                        commentView.frame = CGRectMake(60, 45, (screentWith - 320) + 235, 45);
                        movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                        line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                        self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                        vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                    } else {
                        self.kotacomnt.content = @"";

                        _audioBarView.hidden = YES;
                        commentTextLbl.hidden = NO;
                        commentTextLbl.text = self.kotacomnt.content;
                        CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                                      constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                        commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                        commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                        movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                        line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                        self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                        vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                    }
                } else {

                    self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];
                    if (ticketMess.ticketId) {
                        _audioBarView.hidden = YES;
                        commentTextLbl.hidden = NO;

                        commentTextLbl.text = @"接受了您的申请";

                        CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                                      constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                        commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                        commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                        movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                        line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                        self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                        vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                    }
                }
            }
        } else {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];

            self.kotacomnt.commentType = 1;
            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;

            NSString *str = @"约电影成功";
            commentTextLbl.text = str;

            CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:14]
                       constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
            commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
            movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
            line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
        }
    }

    if (self.friendMessage.status == 3) {

        if (self.friendMessage.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.requestKotaCommentId];

            if (self.kotacomnt.commentType == 1) {

                _audioBarView.hidden = YES;
                commentTextLbl.hidden = NO;

                commentTextLbl.text = self.kotacomnt.content;

                CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                              constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            } else if (self.kotacomnt.commentType == 2) {

                commentTextLbl.hidden = YES;
                if (self.kotacomnt.attachPath && self.kotacomnt.attachPath.length > 0 && ![self.kotacomnt.attachPath isEqualToString:@"(null)"]) {
                    [_audioBarView updateWithAudioURL:self.kotacomnt.attachPath withAudioLength:[NSNumber numberWithInt:self.kotacomnt.attachLength]];
                    _audioBarView.hidden = NO;
                }

                commentView.frame = CGRectMake(60, 45, (screentWith - 320) + 235, 45); // commentView = 45 movieView = 110 下边距 = 20 上边标题 45

                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);

                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);

                self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
            } else {
                _audioBarView.hidden = YES;
                commentTextLbl.hidden = NO;

                commentTextLbl.text = self.kotacomnt.content;
                NSString *str = @"";
                CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:14]

                           constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
                commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
                movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
                line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
                self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

                vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
            }
        } else {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];

            _audioBarView.hidden = YES;
            commentTextLbl.hidden = NO;

            NSString *str = @"无情的拒绝了您";

            commentTextLbl.text = str;

            CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
            commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
            movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);

            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);

            line.frame = CGRectMake(0, CGRectGetMaxY(movieView.frame) - 1 + 20, screentWith, 1);
        }
    }
    if (self.friendMessage.status == 4) {
        self.kotacomnt = [kotaComment getKotaCommentMessageWithId:self.friendMessage.requestKotaCommentId];

        _audioBarView.hidden = YES;
        commentTextLbl.hidden = NO;

        NSString *str = @"约电影成功了";

        _audioBarView.hidden = YES;
        commentTextLbl.hidden = NO;

        commentTextLbl.text = str;

        CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:14]

                   constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

        commentTextLbl.frame = CGRectMake(0, 0, s.width, s.height);
        commentView.frame = CGRectMake(60, 50, (screentWith - 320) + 235, s.height + 15);
        movieView.frame = CGRectMake(60, CGRectGetMaxY(commentView.frame), (screentWith - 320) + 245, 110);
        vBg.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(movieView.frame) + 20);
        line.frame = CGRectMake(0, s.height + 15 + 50 + 110 + 20 - 1, screentWith, 1);
    }

    if (movie.halfPosterPath.length) {
        [moviePoster loadImageWithURL:movie.halfPosterPath andSize:ImageSizeMiddle];
    } else {
        [moviePoster loadImageWithURL:movie.pathVerticalS andSize:ImageSizeMiddle];
    }     

    movieTitleLbl.hidden = NO;
    movieTitleLbl.text = movie.movieName;

    if (self.friendMessage.shareUserId) {

        if (self.friendMessage.shareUserId == self.userIdNow && self.userIdNow == [DataEngine sharedDataEngine].userId.intValue) {

            if (self.friendMessage.requestUserId) {

                KKZUser *user = [KKZUser getUserWithId:self.friendMessage.requestUserId];
                [avatarImageView loadImageWithURL:user.headImg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];
                nickNameLbl.text = user.nickName;
                userId = user.userId;
                userName = user.nickName;
                self.imageUrlYN = user.avatarPathFinal;

            } else {

                KKZUser *user = [KKZUser getUserWithId:self.friendMessage.shareUserId];
                nickNameLbl.text = user.nickName;
                [avatarImageView loadImageWithURL:user.headImg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];
                userId = user.userId;
                userName = user.nickName;
                self.imageUrlYN = user.avatarPathFinal;
            }

        } else {

            KKZUser *user = [KKZUser getUserWithId:self.friendMessage.shareUserId];
            nickNameLbl.text = user.nickName;
            [avatarImageView loadImageWithURL:user.headImg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];

            userId = user.userId;
            userName = user.nickName;
            self.imageUrlYN = user.avatarPathFinal;
        }

    } else {

        KKZUser *user = [KKZUser getUserWithId:self.friendMessage.requestUserId];
        nickNameLbl.text = user.nickName;
        userId = user.userId;
        userName = user.nickName;
        self.imageUrlYN = user.avatarPathFinal;

        [avatarImageView loadImageWithURL:user.headImg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];
    }

    timeLbl.text = [[DateEngine sharedDateEngine] formattedStringFromDateNew:[[DateEngine sharedDateEngine] dateFromString:self.friendMessage.createTime]];

    if (self.friendMessage.status == 1) {


        } else if (self.friendMessage.status == 2) {


      
    } else if (self.friendMessage.status == 3) {
      
    } else if (self.friendMessage.status == 4) {
       
    }
}

- (void)updateAcceptStatus:(NSNotification *) not{
    if (self.friendMessageMeb.homeMessageId == self.friendMessage.homeMessageId) {
        self.friendMessage.status = 1;
    
    };
}

//联网的情况下，点击头像进入用户主页
- (void)gotoUserHomeView {

    if (![[NetworkUtil me] reachable]) {
        return;
    }
    if (userId == self.userIdNow || userId == [[DataEngine sharedDataEngine].userId intValue]) {
        return;
    }
    FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
    ctr.userId = userId;
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

- (void)applyBtnClicked:(UIButton *)btn {
    if (btn.tag == tagMarkMe) {
        [self acceptKotaMovie];
    } else if (btn.tag == tagMarkMe + 1) {
        [self kotaBuyTicket];
    } else if (btn.tag == tagMarkMe + 2) {
        //约电影成功，进入聊天界面
        
    }
}

- (void)acceptKotaMovie {

    if (self.friendMessage.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"不能对自己进行操作！"
                              cancelButton:@"OK"];
    } else {
        self.friendMessageMeb = self.friendMessage;
        if (self.friendMessage.status == 1) {
            return;
        }
        applyForViewController *vC = [[applyForViewController alloc] init];
        Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];
        KKZUser *shareUser = [KKZUser getUserWithId:self.friendMessage.shareUserId];
        KotaTicketMessage *kotaT = [KotaTicketMessage getKotaTicketMessageWithId:self.friendMessage.kotaId];
        if (self.friendMessage.kotaCommentId) {
            kotaComment *kotacomment = [kotaComment getKotaCommentMessageWithId:self.friendMessage.kotaCommentId];
            vC.kotaId = [NSNumber numberWithInt:kotacomment.kotaId];
        } else if (self.friendMessage.kotaId) {
            vC.kotaId = [NSNumber numberWithInt:kotaT.kotaId];
        }
        vC.cinemaName = kotaT.cinemaName;
        vC.filmName = movie.movieName;
        vC.shareHeadimg = shareUser.headImg;
        vC.shareNickname = shareUser.nickName;
        vC.screenDegree = [NSNumber numberWithInt:kotaT.screenDegree];
        vC.screenSize = [NSNumber numberWithInt:kotaT.screenSize];
        vC.lang = kotaT.lang;
        vC.createTime = [[DateEngine sharedDateEngine] dateFromString:kotaT.ticketTime]; //ticketTime

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:vC animation:CommonSwitchAnimationSwipeR2L];
    }
}

- (void)kotaBuyTicket {

}



@end
