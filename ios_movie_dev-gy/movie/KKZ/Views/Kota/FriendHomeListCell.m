//
//  FriendHomeListCell.m
//  KoMovie
//
//  Created by avatar on 14-11-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "DataEngine.h"
#import "DateEngine.h"
#import "FavoriteTask.h"
#import "FriendHomeListCell.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "MovieDetailViewController.h"
#import "TaskQueue.h"
#import "UIConstants.h"

@implementation FriendHomeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        vBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [vBg setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:vBg];

        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 35, 35)];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
        avatarImageView.clipsToBounds = YES;
        [self addSubview:avatarImageView];
        CALayer *l = avatarImageView.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:17.5];

        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 120, 20, 105, 16)];
        timeLbl.text = @"未知"; //createTime
        timeLbl.textColor = [UIColor grayColor];
        timeLbl.backgroundColor = [UIColor clearColor];
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeLbl];

        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 170, 16)];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLbl];
        titleLbl.hidden = YES;

        titleView = [[UIView alloc] initWithFrame:CGRectMake(60, 20, screentWith - 150, 16)];
        [self addSubview:titleView];
        titleView.hidden = YES;

        titleLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
        titleLbl1.textColor = [UIColor blackColor];
        titleLbl1.text = @"评论了";
        titleLbl1.backgroundColor = [UIColor clearColor];
        titleLbl1.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:titleLbl1];

        titleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0, 16)];
        titleLbl2.textColor = appDelegate.kkzBlue;
        titleLbl2.text = @"影片";
        titleLbl2.backgroundColor = [UIColor clearColor];
        titleLbl2.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:titleLbl2];

        titleLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 75, 16)];
        titleLbl3.textColor = [UIColor blackColor];
        titleLbl3.text = @"发表了评论";
        titleLbl3.backgroundColor = [UIColor clearColor];
        titleLbl3.font = [UIFont systemFontOfSize:14];
        //        [titleView addSubview:titleLbl3];

        movieView = [[UIView alloc] initWithFrame:CGRectMake(60, 55, screentWith - 75, 110)];
        [self addSubview:movieView];
        movieView.hidden = YES;

        UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0 - 3, 0 - 3, 75 + 6, 105 + 6)];
        shadowImg.image = [UIImage imageNamed:@"post_black_shadow"];
        shadowImg.contentMode = UIViewContentModeScaleAspectFill;
        shadowImg.clipsToBounds = YES;
        [movieView addSubview:shadowImg];

        moviePoster = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 105)];
        moviePoster.contentMode = UIViewContentModeScaleAspectFill;
        moviePoster.clipsToBounds = YES;
        [movieView addSubview:moviePoster];

        movieTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, screentWith - 160, 20)];
        movieTitleLbl.textColor = [UIColor blackColor];
        movieTitleLbl.backgroundColor = [UIColor clearColor];
        movieTitleLbl.font = [UIFont systemFontOfSize:14];
        [movieView addSubview:movieTitleLbl];

        newLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 20, 20)];
        newLbl.text = @"新";
        newLbl.textAlignment = NSTextAlignmentCenter;
        newLbl.textColor = [UIColor whiteColor];
        newLbl.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:145 / 255.0 blue:10 / 255.0 alpha:1.0];
        newLbl.font = [UIFont systemFontOfSize:14];

        scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 35, 20)];
        scoreLbl.textAlignment = NSTextAlignmentRight;
        scoreLbl.textColor = [UIColor orangeColor];
        scoreLbl.backgroundColor = [UIColor clearColor];
        scoreLbl.font = [UIFont systemFontOfSize:14];

        directerLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, screentWith - 160, 16)];
        directerLbl.textColor = [UIColor grayColor];
        directerLbl.backgroundColor = [UIColor clearColor];
        directerLbl.font = [UIFont systemFontOfSize:12];
        [movieView addSubview:directerLbl];

        leaderLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 41, screentWith - 160, 16)];
        leaderLbl.textColor = [UIColor grayColor];
        leaderLbl.backgroundColor = [UIColor clearColor];
        leaderLbl.font = [UIFont systemFontOfSize:12];
        [movieView addSubview:leaderLbl];

        movieIntroduce = [[RoundCornersButton alloc] initWithFrame:CGRectMake(85, 77, 132, 30)];
        movieIntroduce.titleColor = [UIColor orangeColor];
        movieIntroduce.rimColor = [UIColor orangeColor];
        movieIntroduce.backgroundColor = [UIColor clearColor];
        movieIntroduce.titleName = @"电影介绍";
        movieIntroduce.titleFont = [UIFont systemFontOfSize:14];
        movieIntroduce.cornerNum = 4;
        movieIntroduce.rimWidth = 1;
        movieIntroduce.userInteractionEnabled = YES;
        [movieView addSubview:movieIntroduce];

        [movieIntroduce addTarget:self action:@selector(movieIntroduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        commentView = [[UIView alloc] initWithFrame:CGRectMake(60, 45, screentWith - 75, 90)];
        [self addSubview:commentView];
        commentView.hidden = YES;

        starView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [starView setImagesDeselected:@"fav_star_no_yellow_match"
                       partlySelected:@"fav_star_half_yellow"
                         fullSelected:@"fav_star_full_yellow"
                             iconSize:CGSizeMake(13, 13)
                          andDelegate:self];

        starView.userInteractionEnabled = NO;
        [starView displayRating:0];
        [commentView addSubview:starView];

        scorestarLbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 40, 11)];
        scorestarLbl.backgroundColor = [UIColor clearColor];
        scorestarLbl.textColor = appDelegate.kkzYellow;
        scorestarLbl.textAlignment = NSTextAlignmentLeft;
        scorestarLbl.font = [UIFont systemFontOfSize:13];
        [commentView addSubview:scorestarLbl];

        //文字评论
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screentWith - 75, 40)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor grayColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        [commentView addSubview:textLabel];

        //语音评论
        [self configurePlayerButton];

        operactionView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, screentWith - 75, 50)];
        [commentView addSubview:operactionView];

        //1支持
        supportImgView = [[UIImageView alloc] init];
        supportImgView.frame = CGRectMake(0, 35, 15, 15);
        supportImgView.image = [UIImage imageNamed:@"heart"];
        supportImgView.highlightedImage = [UIImage imageNamed:@"ic_heart_blue"];
        supportImgView.userInteractionEnabled = YES;

        tapSupportView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 60, 30)];
        [operactionView addSubview:tapSupportView];
        [operactionView addSubview:supportImgView];

        //支持的数量
        likeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 35, 40, 15)];
        likeNumLabel.textColor = [UIColor r:181 g:181 b:181];
        likeNumLabel.text = @"0";
        likeNumLabel.backgroundColor = [UIColor clearColor];
        likeNumLabel.font = [UIFont systemFontOfSize:12];
        likeNumLabel.textAlignment = NSTextAlignmentLeft;
        [operactionView addSubview:likeNumLabel];

        //2反对
        opposeImgView = [[UIImageView alloc] init];
        opposeImgView.frame = CGRectMake(70, 35, 15, 15);
        opposeImgView.image = [UIImage imageNamed:@"comment_oppsition"];
        opposeImgView.highlightedImage = [UIImage imageNamed:@"hight_comment_oppsition"];
        opposeImgView.userInteractionEnabled = YES;
        tapOppositView = [[UIView alloc] initWithFrame:CGRectMake(70, 35, 60, 30)];
        [operactionView addSubview:tapOppositView];
        [operactionView addSubview:opposeImgView];

        //反对的数量
        dislikeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 35, 40, 15)];
        dislikeNumLabel.textColor = [UIColor r:181 g:181 b:181];
        dislikeNumLabel.text = @"0";
        dislikeNumLabel.backgroundColor = [UIColor clearColor];
        dislikeNumLabel.font = [UIFont systemFontOfSize:12];
        dislikeNumLabel.textAlignment = NSTextAlignmentLeft;
        dislikeNumLabel.userInteractionEnabled = YES;
        [operactionView addSubview:dislikeNumLabel];

        //评论按钮
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - 75) - 53, 75, 48, 14)];
        [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [commentView addSubview:commentBtn];

        UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        [commentIcon setImage:[UIImage imageNamed:@"comment"]];
        [commentIcon setUserInteractionEnabled:NO];
        [commentBtn addSubview:commentIcon];

        UILabel *commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 40, 14)];
        commentLbl.textAlignment = NSTextAlignmentLeft;
        commentLbl.text = @"评论";
        commentLbl.textColor = [UIColor r:150 g:150 b:150];
        commentLbl.font = [UIFont systemFontOfSize:kTextSizeSmall];
        [commentBtn addSubview:commentLbl];

        line = [[UIView alloc] initWithFrame:CGRectMake(0, 90, screentWith, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:211 / 255.0 alpha:1.0]];
        [self addSubview:line];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateLayout {

    titleLbl.hidden = YES;
    commentView.hidden = YES;
    movieView.hidden = YES;
    titleLbl.hidden = YES;
    titleView.hidden = YES;

    textViewBg.hidden = YES;
    textLabel.hidden = YES;
    _audioBarView.hidden = YES;
    newLbl.hidden = YES;

    KKZUser *userY = [KKZUser getUserWithId:self.currentUid];

    [avatarImageView loadImageWithURL:userY.headImg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];

    timeLbl.text = [[DateEngine sharedDateEngine] formattedStringFromDateNew:[[DateEngine sharedDateEngine] dateFromString:self.friendMessage.createTime]];

    //    17 看过
    //    16 想看
    //    13 评论

    if (self.friendMessage.status == 17) {
        movieView.hidden = NO;
        scoreLbl.hidden = YES;
        Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];

        scoreLbl.text = [NSString stringWithFormat:@"%@分", movie.moviePoint];
        titleLbl.text = @"看过了这部电影";
        titleLbl.hidden = NO;
        if (movie.halfPosterPath.length) {
            [moviePoster loadImageWithURL:movie.halfPosterPath andSize:ImageSizeMiddle];
        } else {
            [moviePoster loadImageWithURL:movie.pathVerticalS andSize:ImageSizeMiddle];
        }

        movieTitleLbl.text = movie.movieName;

        CGSize s = [movie.movieName sizeWithFont:[UIFont systemFontOfSize:14]];

        movieTitleLbl.frame = CGRectMake(85, 0, s.width > (screentWith - 180) ? (screentWith - 180) : s.width, 20);

        if ([[NSDate date] timeIntervalSinceDate:movie.publishTime] > 7 * 24 * 60 * 60) { //一星期之内的显示“新”的标识
            newLbl.hidden = NO;
            newLbl.frame = CGRectMake(CGRectGetMaxX(movieTitleLbl.frame) + 5, 0, 20, 20);
        }

        directerLbl.text = [NSString stringWithFormat:@"导演：%@", movie.movieDirector];
        leaderLbl.text = [NSString stringWithFormat:@"主演：%@", movie.starringActor];

        scoreLbl.text = [NSString stringWithFormat:@"%@", movie.moviePoint];
        line.frame = CGRectMake(0, 184, screentWith, 1);

        vBg.frame = CGRectMake(0, 0, screentWith, 185);

    } else if (self.friendMessage.status == 16) {
        titleLbl.hidden = NO;
        movieView.hidden = NO;
        Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];

        CGSize s = [movie.movieName sizeWithFont:[UIFont systemFontOfSize:14]];

        movieTitleLbl.frame = CGRectMake(85, 0, s.width > (screentWith - 180) ? (screentWith - 180) : s.width, 20);

        newLbl.frame = CGRectMake(CGRectGetMaxX(movieTitleLbl.frame) + 5, 0, 20, 20);

        if ([[NSDate date] timeIntervalSinceDate:movie.publishTime] > 7 * 24 * 60 * 60) {
            newLbl.hidden = NO;
            newLbl.frame = CGRectMake(CGRectGetMaxX(movieTitleLbl.frame), 0, 20, 20);
        }
        scoreLbl.text = [NSString stringWithFormat:@"%@分", movie.moviePoint];
        titleLbl.text = @"添加了想看这部电影";

        if (movie.halfPosterPath.length) {
            [moviePoster loadImageWithURL:movie.halfPosterPath andSize:ImageSizeMiddle];

        } else {
            [moviePoster loadImageWithURL:movie.pathVerticalS andSize:ImageSizeMiddle];
        }
        movieTitleLbl.text = movie.movieName;
        directerLbl.text = [NSString stringWithFormat:@"导演：%@", movie.movieDirector];
        leaderLbl.text = [NSString stringWithFormat:@"主演：%@", movie.starringActor];

        line.frame = CGRectMake(0, 184, screentWith, 1);

        vBg.frame = CGRectMake(0, 0, screentWith, 185);

    } else if (self.friendMessage.status == 13) {

        vBg.frame = CGRectMake(0, 0, screentWith, 150);

        line.frame = CGRectMake(0, 149, screentWith, 1);
        commentView.hidden = NO;
        titleView.hidden = NO;

        Comment *comment = [Comment getCommentWithId:self.friendMessage.commentId];
        if ([comment.relation integerValue] == 1) { //对评论过的信息，显示支持还是反对
            supportImgView.highlighted = YES;
            opposeImgView.highlighted = NO;

        } else if ([comment.relation integerValue] == 2) {
            supportImgView.highlighted = NO;
            opposeImgView.highlighted = YES;

        } else {
            supportImgView.highlighted = NO;
            opposeImgView.highlighted = NO;
        }
        if ([comment.commentTargetType isEqualToNumber:@1]) { //commentTargetType == 1 对电影进行评论

            Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];
            NSString *s = @"评论了";
            titleLbl1.text = @"评论了";
            CGSize titleLbl1Size = [s sizeWithFont:[UIFont systemFontOfSize:14]];
            titleLbl1.frame = CGRectMake(0, 0, titleLbl1Size.width, 20);

            if (movie.movieName.length) {

                titleLbl2.text = [NSString stringWithFormat:@"《%@》", movie.movieName];
                CGSize titleLbl2Size = [titleLbl2.text sizeWithFont:[UIFont systemFontOfSize:14]];

                if (titleLbl2Size.width > screentWith - 320 + 100) {
                    titleLbl2Size.width = screentWith - 320 + 100;
                }

                titleLbl2.frame = CGRectMake(titleLbl1Size.width, 0, titleLbl2Size.width, 20);
                titleLbl3.frame = CGRectMake(titleLbl2Size.width + titleLbl1Size.width, 0, 105, 20);
            }

            titleLbl3.text = @"发表了评论";

            [starView displayRating:[comment.commentScore floatValue] / 2.0];
            scorestarLbl.text = [NSString stringWithFormat:@"%.1f", [comment.commentScore floatValue]];
            if ([comment.commentType isEqualToNumber:@1]) {

                textViewBg.hidden = YES;
                _audioBarView.hidden = YES;
                textLabel.hidden = NO;

                textLabel.text = comment.commentContent;

            } else if ([comment.commentType isEqualToNumber:@2]) {
                textLabel.hidden = YES;
                if (comment.audioUrl && comment.audioUrl.length > 0 && ![comment.audioUrl isEqualToString:@"(null)"]) {
                    [_audioBarView updateWithAudioURL:comment.audioUrl withAudioLength:comment.shuoLength];
                    _audioBarView.hidden = NO;
                }
            }
            likeNumLabel.text = [NSString stringWithFormat:@"%@", comment.isLove];
            dislikeNumLabel.text = [NSString stringWithFormat:@"%@", comment.isOppo];
        } else if ([comment.commentTargetType isEqualToNumber:@2]) { //commentTargetType == 2 对影院进行评论

            Cinema *cinema = [Cinema getCinemaWithId:self.friendMessage.cinemaId];

            NSString *s = @"评论了";
            titleLbl1.text = @"评论了";
            CGSize titleLbl1Size = [s sizeWithFont:[UIFont systemFontOfSize:14]];
            titleLbl1.frame = CGRectMake(0, 0, titleLbl1Size.width, 20);

            titleLbl2.text = cinema.cinemaName;
            CGSize titleLbl2Size = [cinema.cinemaName sizeWithFont:[UIFont systemFontOfSize:14]];
            if (titleLbl2Size.width > screentWith - 320 + 100) {
                titleLbl2Size.width = screentWith - 320 + 100;
            }
            titleLbl2.frame = CGRectMake(titleLbl1Size.width, 0, titleLbl2Size.width, 20);
            titleLbl3.text = @"发表了评论";
            titleLbl3.frame = CGRectMake(titleLbl2Size.width + titleLbl1Size.width, 0, 105, 20);

            [starView displayRating:[comment.commentScore floatValue] / 2.0];

            scorestarLbl.text = [NSString stringWithFormat:@"%.1f", [comment.commentScore floatValue]];

            if ([comment.commentType isEqualToNumber:@1]) { //文字

                textViewBg.hidden = YES;
                textLabel.hidden = NO;

                textLabel.text = comment.commentContent;

            } else if ([comment.commentType isEqualToNumber:@2]) //语音
            {

                if (comment.audioUrl && comment.audioUrl.length > 0 && ![comment.audioUrl isEqualToString:@"(null)"]) {
                    [_audioBarView updateWithAudioURL:comment.audioUrl withAudioLength:comment.shuoLength];
                    _audioBarView.hidden = NO;
                }
            }
            likeNumLabel.text = [NSString stringWithFormat:@"%@", comment.isLove];
            dislikeNumLabel.text = [NSString stringWithFormat:@"%@", comment.isOppo];
        }
    }

    self.frame = CGRectMake(0, 0, screentWith, 250);
}

//电影介绍，点击进入影片详情界面
- (void)movieIntroduceBtnClicked:(UIButton *)btn {
    DLog(@"影片详情按钮被点击");
    Movie *movie = [Movie getMovieWithId:self.friendMessage.movieId];
    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:movie.movieId];
    
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:mvc animation:CommonSwitchAnimationBounce];
}

- (void)configurePlayerButton {

    _audioBarView = [[AudioBarView alloc] initWithFrame:CGRectMake(0, 25, 265, 40)];
    _audioBarView.minWidth = 110;
    _audioBarView.maxWidth = 110;
    _audioBarView.height = 30;
    [commentView addSubview:_audioBarView];
}

- (void)ratingChanged:(CGFloat)newRating {

    scorestarLbl.text = [NSString stringWithFormat:@"%.1f分", newRating * 2];
}

- (void)commentBtnClicked:(UIButton *)btn {
    Comment *comment = [Comment getCommentWithId:self.friendMessage.commentId];
    if (comment.userId == [DataEngine sharedDataEngine].userId.intValue) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"您不能对自己的信息发表评论"
                              cancelButton:@"OK"];

        return;
    }
}

//反对
- (void)handleTouchOnOpposition {

    Comment *comment = [Comment getCommentWithId:self.friendMessage.commentId];
    NSInteger num = [comment.relation integerValue];

    if (num == 1 || num == 2) {
        [appDelegate showAlertViewForTitle:@"" message:@"您已经点过了喔" cancelButton:@"确定"];
        return;
    }

    FavoriteTask *task = [[FavoriteTask alloc] initAddLikeWithUserId:nil
                                                            withType:@2
                                                        withTargetId:[NSString stringWithFormat:@"%u", comment.commentId]
                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                [appDelegate hideIndicator];
                                                                if (succeeded) {
                                                                    comment.relation = @2;
                                                                    comment.isOppo = @([comment.isOppo intValue] + 1);
                                                                    if (comment.isOppo) {
                                                                        dislikeNumLabel.text = [NSString stringWithFormat:@"%d", [comment.isOppo intValue]];
                                                                    } else {
                                                                        dislikeNumLabel.text = @"0";
                                                                    }

                                                                    opposeImgView.highlighted = YES;
                                                                } else {
                                                                    [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                }

                                                            }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

//支持
- (void)handleTouchOnSupport {

    Comment *comment = [Comment getCommentWithId:self.friendMessage.commentId];

    NSInteger num = [comment.relation integerValue];

    if (num == 1 || num == 2) {
        [appDelegate showAlertViewForTitle:@"" message:@"您已经点过了喔" cancelButton:@"确定"];
        return;
    }

    NSString *userId = [NSString stringWithFormat:@"%u", comment.userId];
    FavoriteTask *task = [[FavoriteTask alloc] initAddLikeWithUserId:userId
                                                            withType:@1
                                                        withTargetId:[NSString stringWithFormat:@"%u", comment.commentId]
                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                [appDelegate hideIndicator];
                                                                if (succeeded) {
                                                                    comment.relation = @1;
                                                                    comment.isLove = @([comment.isLove intValue] + 1);
                                                                    if (comment.isLove) {
                                                                        likeNumLabel.text = [NSString stringWithFormat:@"%d", [comment.isLove intValue]];
                                                                    } else {
                                                                        likeNumLabel.text = @"0";
                                                                    }
                                                                    supportImgView.highlighted = YES;
                                                                } else {
                                                                    [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                }
                                                            }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {

    if (self.friendMessage.status != 13) {
        return;
    }
    CGPoint point = [gesture locationInView:operactionView];
    Comment *comment = [Comment getCommentWithId:self.friendMessage.commentId];
    if (CGRectContainsPoint(tapSupportView.frame, point)) { //支持
        if (comment.userId == [[DataEngine sharedDataEngine].userId intValue]) {
            [appDelegate showAlertViewForTitle:@"" message:@"您不能对自己的相关信息进行操作！" cancelButton:@"确定"];
            return;
        }
        [self handleTouchOnSupport];
    } else if (CGRectContainsPoint(tapOppositView.frame, point)) { //反对
        if (comment.userId == [[DataEngine sharedDataEngine].userId intValue]) {
            [appDelegate showAlertViewForTitle:@"" message:@"您不能对自己的相关信息进行操作！" cancelButton:@"确定"];
            return;
        }
        [self handleTouchOnOpposition];
        return;
    }
}

@end
