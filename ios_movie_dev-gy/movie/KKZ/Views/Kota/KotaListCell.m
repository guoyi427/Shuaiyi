//
//  KotaListCell.m
//  KKZ
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "KotaListCell.h"
#import "ImageEngine.h"
#import "DataEngine.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationEngine.h"
#import "ShareView.h"
#import "Constants.h"
#import "UserDefault.h"
#import "KotaShare.h"
#import "RIButtonItem.h"
#import "KotaTask.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "TaskTypeUtils.h"
#import "Reachability.h"

#define kMarginX 10
#define LINENUM 5 //行宽
#define LINEHEIGHT 12 //行高
#define kFont 13
@implementation KotaListCell {
    UIImageView *genderImage;
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    [[UIColor r:181 g:181 b:181] set];

    CGContextAddRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        userAvatarRect = CGRectMake(0, 0, 66, 70);
        applyBtnRect = CGRectMake(28, 98, 125, 40);
        emailBtnRect = CGRectMake(160, 98, 87, 26);

        //右上角的时间标示,对齐timedistancelabel的左边
        timeDistanceBg = [[UIImageView alloc] initWithFrame:CGRectMake(240, 5, 13, 7)];
        timeDistanceBg.contentMode = UIViewContentModeScaleAspectFit;
        timeDistanceBg.image = [UIImage imageNamed:@"kota_time_distance_blue"];
        timeDistanceBg.frame = CGRectMake(240, 8, 14, 14);
        timeDistanceBg.image = [UIImage imageNamed:@"kota_time_distance_red"];
        [self addSubview:timeDistanceBg];

        timeDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(258, 6, 100, kFont)];
        timeDistanceLabel.text = @"30分钟前 / 0.08km";
        timeDistanceLabel.textAlignment = NSTextAlignmentRight;
        timeDistanceLabel.textColor = [UIColor r:181 g:181 b:181];
        timeDistanceLabel.backgroundColor = [UIColor clearColor];
        timeDistanceLabel.font = [UIFont systemFontOfSize:kFont - 1];
        [self addSubview:timeDistanceLabel];

        //头像
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 54, 54)];
        avatarImageView.contentMode = UIViewContentModeScaleToFill;
        avatarImageView.clipsToBounds = YES;
        avatarImageView.layer.cornerRadius = 54 * 0.5f;
        [self addSubview:avatarImageView];

        genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        genderImage.image = [UIImage imageNamed:@"kota_famale"];
        genderImage.highlightedImage = [UIImage imageNamed:@"kota_male"];
        [avatarImageView addSubview:genderImage];

        //用户名字
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 16, 150, kFont + 2)];
        nameLabel.text = @"游客";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.textColor = appDelegate.kkzTextColor;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:kFont + 1];
        nameLabel.numberOfLines = 1;
        [self addSubview:nameLabel];

        //想看或者买了一张电影票的电影名字
        movieLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 41, 200, kFont)];
        movieLabel.text = @"想看/买了一张电影票《》";
        movieLabel.textAlignment = NSTextAlignmentLeft;
        movieLabel.textColor = appDelegate.kkzTextColor;
        movieLabel.backgroundColor = [UIColor clearColor];
        movieLabel.font = [UIFont systemFontOfSize:kFont];
        movieLabel.numberOfLines = 1;
        [self addSubview:movieLabel];
        //买的电影票的日期时间
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, 200, kFont)];
        dateLabel.text = @"03-25";
        dateLabel.hidden = YES;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.textColor = appDelegate.kkzTextColor;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:kFont];
        [self addSubview:dateLabel];
        //购买的电影院
        cinemaLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 76.5, 200, kFont)];
        cinemaLabel.text = @"海航天宝影城";
        cinemaLabel.hidden = YES;
        cinemaLabel.textAlignment = NSTextAlignmentLeft;
        cinemaLabel.textColor = appDelegate.kkzTextColor;
        cinemaLabel.backgroundColor = [UIColor clearColor];
        cinemaLabel.font = [UIFont systemFontOfSize:kFont];
        cinemaLabel.numberOfLines = 2;
        cinemaLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:cinemaLabel];
        //发私信的按钮，给TA私信
        emailButtonBg = [[UIImageView alloc] initWithFrame:emailBtnRect];
        emailButtonBg.image = [UIImage imageNamed:@"kota_email_img"];
        [self addSubview:emailButtonBg];
        //分享的按钮
        msgShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        msgShareBtn.frame = CGRectMake(265, 140 - 40, 35, 33);
        [msgShareBtn setImage:[UIImage imageNamed:@"msg_share_btn"] forState:UIControlStateNormal];
        [msgShareBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [msgShareBtn addTarget:self action:@selector(shareMassage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:msgShareBtn];
        //分享次数
        forwardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(298, 110, 51, kFont)];
        forwardNumLabel.textColor = [UIColor r:181 g:181 b:181];
        forwardNumLabel.backgroundColor = [UIColor clearColor];
        forwardNumLabel.textAlignment = NSTextAlignmentLeft;
        forwardNumLabel.text = @"0";
        forwardNumLabel.font = [UIFont systemFontOfSize:kFont - 1];
        [self addSubview:forwardNumLabel];
        //申请与TA一起观影
        applyButtonBg = [[UIImageView alloc] initWithFrame:CGRectMake(28, 103, 128, 26)];
        applyButtonBg.image = [UIImage imageNamed:@"kota_apply_img"];
        applyButtonBg.hidden = YES;
        [self addSubview:applyButtonBg];
        emailButtonBg.frame = emailBtnRect;
        //已申请的按钮
        noApplyButtonBg = [[UIImageView alloc] initWithFrame:CGRectMake(66, 103, 87, 26)];
        noApplyButtonBg.image = [UIImage imageNamed:@"kota_applied_img"];
        noApplyButtonBg.hidden = YES;
        [self addSubview:noApplyButtonBg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (float)heightWithCellState:(CellState)state {
    return state == CellStateDefault ? 123 : 153;
}

- (void)updateLayout {

    if (self.kotaType == 0) {

        timeDistanceBg.frame = CGRectMake(240, 8, 16, 16);
        timeDistanceBg.image = [UIImage imageNamed:@"kota_time_gray"];
        timeDistanceLabel.frame = CGRectMake(260, 8, 100, kFont);
        dateLabel.hidden = NO;
        cinemaLabel.hidden = NO;

        dateLabel.text = self.ticketTime;
        cinemaLabel.text = self.cinemaName;
        movieLabel.frame = CGRectMake(70, 35, 200, kFont);
        movieLabel.text = [NSString stringWithFormat:@"买了一张电影票《%@》", self.movieName];

        msgShareBtn.frame = CGRectMake(265, 145 - 40, 40, 37);

        forwardNumLabel.frame = CGRectMake(301, 117, 51, kFont);
        forwardNumLabel.text = [NSString stringWithFormat:@"%d", [self.kotaShare.shareCount intValue]];

        ///////kotaStatus == 0 还没有申请 Kota  ==1 已经申请了
        if (self.kotaStatus == 0 && !(self.userId == [[DataEngine sharedDataEngine].userId intValue])) {

            applyButtonBg.hidden = NO;
            noApplyButtonBg.hidden = YES;
            emailButtonBg.hidden = NO;
            emailButtonBg.frame = CGRectMake(163, 103, 87, 26);
        } else if (self.kotaStatus == 1 && !(self.userId == [[DataEngine sharedDataEngine].userId intValue])) {
            applyButtonBg.hidden = YES;
            noApplyButtonBg.hidden = NO;
            emailButtonBg.frame = CGRectMake(163, 103, 87, 26);
            emailButtonBg.hidden = NO;
        } else {
            applyButtonBg.hidden = YES;
            noApplyButtonBg.hidden = YES;
            emailButtonBg.hidden = YES;
        }

    } else if (self.kotaType == 1) {

        timeDistanceBg.frame = CGRectMake(239, 5, 18, 18);
        timeDistanceBg.image = [UIImage imageNamed:@"kota_time_distance_gray"];
        timeDistanceLabel.frame = CGRectMake(260, 8, 100, kFont);
        dateLabel.hidden = YES;
        cinemaLabel.hidden = YES;

        movieLabel.frame = CGRectMake(70, 41, 200, kFont);
        movieLabel.text = [NSString stringWithFormat:@"想看《%@》", self.movieName];

        msgShareBtn.frame = CGRectMake(265, 110 - 40, 40, 37);

        forwardNumLabel.frame = CGRectMake(301, 115 - 34, 51, kFont);
        forwardNumLabel.text = [NSString stringWithFormat:@"%d", [self.kotaShare.shareCount intValue]];

        if (self.userId == [[DataEngine sharedDataEngine].userId intValue]) {
            emailButtonBg.hidden = YES;
        } else {
            emailButtonBg.hidden = NO;
        }

        applyButtonBg.hidden = YES;
        noApplyButtonBg.hidden = YES;
        emailButtonBg.frame = CGRectMake(66, 98 - 30, 87, 26);

    } else {
    }

    if (self.avatarUrl) {
        [avatarImageView loadImageWithURL:self.avatarUrl andSize:ImageSizeSmall];
    }

    if ([self.kota.shareSex intValue] == 1) {
        genderImage.highlighted = YES;
    } else {
        genderImage.highlighted = NO;
    }
    nameLabel.text = self.userName;

    //时间
    NSString *time = @"";
    if ([[[DateEngine sharedDateEngine] relativeDateStringFromDate:self.kota.createTime] isEqualToString:@"今天"]) {
        timeDistanceLabel.frame = CGRectMake(320 - 36 - 10, 8, 36, kFont);
        time = [NSString stringWithFormat:@"%@",
                                          [[DateEngine sharedDateEngine] shortTimeStringFromDate:self.kota.createTime]];
    } else {
        timeDistanceLabel.frame = CGRectMake(320 - 82 - 10, 8, 82, kFont);
        time = [NSString stringWithFormat:@"%@ %@",
                                          [[DateEngine sharedDateEngine] shortDateStringFromDate:self.kota.createTime],
                                          [[DateEngine sharedDateEngine] shortTimeStringFromDate:self.kota.createTime]];
    }
    timeDistanceLabel.text = time;

    timeDistanceBg.frame = CGRectMake(CGRectGetMinX(timeDistanceLabel.frame) - CGRectGetWidth(timeDistanceBg.frame),
                                      CGRectGetMinY(timeDistanceBg.frame), CGRectGetWidth(timeDistanceBg.frame), CGRectGetHeight(timeDistanceBg.frame));
}

- (void)shareMassage {
    if (![[NetworkUtil me] reachable]) {
        return;
    }

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];

    poplistview.userShareInfo = @"kota";

    NSString *shareUrl = nil;
    if ([DataEngine sharedDataEngine].userId && [[DataEngine sharedDataEngine].userId length]) {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&userId=%@&targetId=%@", kAppShareHTML5Url, @"9", [DataEngine sharedDataEngine].userId, [NSString stringWithFormat:@"%d", self.kotaId]];
    } else {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%@", kAppShareHTML5Url, @"9", [NSString stringWithFormat:@"%d", self.kotaId]];
    }

    UIImage *image = [UIImage imageNamed:@"kota_tip_share"];
    NSString *content = [NSString stringWithFormat:@"看电影没人陪？帅哥美女等着你。查看详情：%@。更多精彩，尽在【抠电影客户端】。", shareUrl];
    NSString *contentQQSpace = [NSString stringWithFormat:@"看电影没人陪？帅哥美女等着你"];
    NSString *contentWeChat = [NSString stringWithFormat:@"看电影没人陪？帅哥美女等着你"];

    [poplistview updateWithcontent:content
                     contentWeChat:contentWeChat
                    contentQQSpace:contentQQSpace
                             title:@"一起来KOTA"
                         imagePath:image
                          imageURL:nil
                               url:shareUrl
                          soundUrl:nil
                          delegate:appDelegate
                         mediaType:SSPublishContentMediaTypeNews
                    statisticsType:0
                         shareInfo:[NSString stringWithFormat:@"%d", self.kotaShare.kotaId]
                         sharedUid:[NSString stringWithFormat:@"%u", self.userId]];
    [poplistview show];
}

- (void)showMovieDetail {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnShowMovie:)]) {
        [self.delegate handleTouchOnShowMovie:self.kotaId];
    }
}

//申请与TA一起观影
- (void)applyKota {
    KotaShare *kota = [KotaShare getKotaShareWithId:self.kotaId];
    if ((kota.userId == [[DataEngine sharedDataEngine].userId intValue])) {
        [appDelegate showAlertViewForTitle:@"提示" message:@"不能向自己申请喔~" cancelButton:@"OK"];
        return;
    }

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{

    };

    RIButtonItem *done = [RIButtonItem itemWithLabel:@"申请"];
    done.action = ^{

        KotaTask *task = [[KotaTask alloc] initKotaShareApply:self.kotaId
                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                         [self kotaApplyFinished:userInfo status:succeeded];
                                                     }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"申请中"
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:YES
                                    andAutoHide:NO];
        }
    };

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"是否申请与TA一起观影？"
                                           cancelButtonItem:cancel
                                           otherButtonItems:done, nil];
    [alert show];
}

- (void)kotaApplyFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    if (succeeded) {
        [self updateLayout];
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnApplyKotaSuccess)]) {
            [self.delegate handleTouchOnApplyKotaSuccess];
        }

        self.kotaStatus = 1;

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark touch view delegate
- (void)touchAtPoint:(CGPoint)point {

    if (CGRectContainsPoint(userAvatarRect, point)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnUser:)]) {
            [self.delegate handleTouchOnUser:[NSString stringWithFormat:@"%u", self.userId]];
        }
        return;
    }

    if (self.kotaType == 0) {
        if (self.kotaStatus == 0) {
            if (CGRectContainsPoint(applyBtnRect, point)) {
                [self applyKota];

                return;
            }
            if (CGRectContainsPoint(CGRectMake(163, 95, 90, 40), point)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnMessage:userName:)]) {
                    [self.delegate handleTouchOnMessage:self.userId userName:self.userName];
                }
                return;
            }

        } else if (self.kotaStatus == 1) {
            if (CGRectContainsPoint(CGRectMake(163, 95, 90, 40), point)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnMessage:userName:)]) {
                    [self.delegate handleTouchOnMessage:self.userId userName:self.userName];
                }
                return;
            }
        }
        if (CGRectContainsPoint(CGRectMake(260, 75, 60, 60), point)) {
            [self shareMassage];
        }

    } else if (self.kotaType == 1) {

        if (CGRectContainsPoint(CGRectMake(65, 63, 90, 40), point)) {
            if (self.userId == [[DataEngine sharedDataEngine].userId intValue]) {

            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnMessage:userName:)]) {
                    [self.delegate handleTouchOnMessage:self.userId userName:self.userName];
                }
                return;
            }
        }

        if (CGRectContainsPoint(CGRectMake(260, 50, 60, 50), point)) {
            [self shareMassage];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {

    if (![[NetworkUtil me] reachable]) {
        return;
    }

    CGPoint point = [gesture locationInView:self];

    [TaskTypeUtils printCGRect:emailButtonBg.frame withString:@"私信"];
    CGRect newme = CGRectMake(emailButtonBg.frame.origin.x - 5, emailButtonBg.frame.origin.y - 5, emailButtonBg.frame.size.width + 10, emailButtonBg.frame.size.height + 10);

    if (CGRectContainsPoint(newme, point) && !emailButtonBg.hidden) {
        //私信
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnMessage:userName:)]) {
            [self.delegate handleTouchOnMessage:self.userId userName:self.userName];
        }
        return;
    }

    if (CGRectContainsPoint(applyButtonBg.frame, point) && !applyButtonBg.hidden) {
        //
        [self applyKota];
        return;
    }

    if (CGRectContainsPoint(CGRectMake(260, 50, 60, 50), point)) {
        [self shareMassage];
    }

    if (CGRectContainsPoint(userAvatarRect, point)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnUser:)]) {
            [self.delegate handleTouchOnUser:[NSString stringWithFormat:@"%u", self.userId]];
        }
        return;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
