//
//  ClubPosterCommentCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPosterCommentCell.h"
#import "DateEngine.h"
#import "ImageEngineNew.h"
#import "ClubTask.h"
#import "TaskQueue.h"
#import "ClubPostComment.h"
#import "UIConstants.h"

#define marginX 15
#define marginY 15
#define marginHeadImgToNickName 10
#define marginText 18
#define marginNickNameTop 18
#define headImgVWidth 30
#define userNickNameWidth 180
#define useNickNameFont 13
#define useNickNameHeight 17
#define commentFloorFont 13
#define commentFloorWidth 80
#define commentTextFont 14
#define commentDateFont 12
#define commentDateLblWidth 120
#define commentSupportNumFont 12
#define commentIconWidth 12
#define commentFloorColor [UIColor r:153 g:153 b:153]
#define commentDateColor [UIColor r:153 g:153 b:153]
#define commentSupportNumColor [UIColor r:153 g:153 b:153]

@implementation ClubPosterCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加用户头像
        [self addUserHeadImgV];

        //添加评论楼层
        //        [self addCommentFloor];

        //添加用户昵称
        [self addUserNickName];

        //用户评论内容
        [self addCommentText];

        //添加评论日期
        [self addCommentDate];

        //添加点赞区域
        [self addSupportView];

        line = [[UIView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(supportIconV.frame) + marginY, screentWith - marginX, 1)];
        [line setBackgroundColor:kUIColorDivider];
        [self addSubview:line];
    }
    return self;
}

/**
 * 添加用户头像
 */
- (void)addUserHeadImgV {
    userHeadImgV = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, headImgVWidth, headImgVWidth)];
    userHeadImgV.layer.cornerRadius = headImgVWidth * 0.5;
    userHeadImgV.clipsToBounds = YES;
    [self addSubview:userHeadImgV];
}

/**
 *  添加评论楼层
 */
- (void)addCommentFloor {
    commentFloorLbl = [[UILabel alloc] init];
    commentFloorLbl.textColor = commentFloorColor;
    commentFloorLbl.font = [UIFont systemFontOfSize:commentFloorFont];
    [self addSubview:commentFloorLbl];
}

/**
 *  添加用户昵称
 */
- (void)addUserNickName {
    userNickNameLbl = [[UILabel alloc] init];
    userNickNameLbl.textColor = [UIColor blackColor];
    userNickNameLbl.font = [UIFont systemFontOfSize:useNickNameFont];
    [self addSubview:userNickNameLbl];
}

/**
 *  添加评论内容
 */
- (void)addCommentText {
    commentTextLbl = [[UILabel alloc] init];
    commentTextLbl.numberOfLines = 0;
    commentTextLbl.textColor = [UIColor blackColor];
    commentTextLbl.font = [UIFont systemFontOfSize:commentTextFont];
    [self addSubview:commentTextLbl];
}

/**
 *  添加评论日期
 */
- (void)addCommentDate {
    commentDateLbl = [[UILabel alloc] init];
    commentDateLbl.textColor = commentDateColor;
    commentDateLbl.font = [UIFont systemFontOfSize:commentDateFont];
    [self addSubview:commentDateLbl];
}

/**
 *  添加点赞区域
 */
- (void)addSupportView {

    //添加点赞数量
    supportNumLbl = [[UILabel alloc] init];
    supportNumLbl.textColor = commentSupportNumColor;
    supportNumLbl.font = [UIFont systemFontOfSize:commentSupportNumFont];
    supportNumLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:supportNumLbl];

    //添加点赞图标
    supportIconV = [[UIImageView alloc] init];
    [supportIconV setImage:[UIImage imageNamed:@"supportIcon"]];
    [self addSubview:supportIconV];

    supportBtn = [[UIButton alloc] init];
    [self addSubview:supportBtn];
    [supportBtn addTarget:self action:@selector(supportBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    //    [supportBtn setBackgroundColor:[UIColor redColor]];
    //
}

/**
 *  加载数据
 */
- (void)upLoadData {
    if (self.commont.isUp) {
        [supportIconV setImage:[UIImage imageNamed:@"ic_bbs_supported"]];
    } else {
        [supportIconV setImage:[UIImage imageNamed:@"supportIcon"]];
    }
    //加载用户头像
    [userHeadImgV loadImageWithURL:self.commont.commentor.head  andSize:ImageSizeOrign];

    //加载评论楼层数据
    commentFloorLbl.text = [NSString stringWithFormat:@"%@楼", self.commentFloor];
    CGSize s = [commentFloorLbl.text sizeWithFont:[UIFont systemFontOfSize:commentFloorFont]];
    commentFloorLbl.frame = CGRectMake(screentWith - s.width - marginX, marginNickNameTop, s.width, commentFloorFont);

    //加载用户昵称
    userNickNameLbl.text = self.commont.commentor.nickname;
    userNickNameLbl.frame = CGRectMake(CGRectGetMaxX(userHeadImgV.frame) + marginHeadImgToNickName, marginNickNameTop, screentWith - (CGRectGetMaxX(userHeadImgV.frame) + marginHeadImgToNickName) - marginX - commentFloorLbl.frame.size.width, useNickNameHeight);

    //加载评论内容
    commentTextLbl.text = self.commont.content;
    s = [self.commont.content sizeWithFont:[UIFont systemFontOfSize:commentTextFont] constrainedToSize:CGSizeMake(screentWith - CGRectGetMinX(userNickNameLbl.frame) - marginX, CGFLOAT_MAX)];
    commentTextLbl.frame = CGRectMake(CGRectGetMinX(userNickNameLbl.frame), CGRectGetMaxY(userNickNameLbl.frame) + marginText, screentWith - CGRectGetMinX(userNickNameLbl.frame) - marginX, s.height);

    //加载评论时间
    commentDateLbl.text = self.commont.createTime;
    commentDateLbl.frame = CGRectMake(CGRectGetMinX(userNickNameLbl.frame), CGRectGetMaxY(commentTextLbl.frame) + marginText, commentDateLblWidth, commentDateFont);

    //加载点赞数目
    supportNumLbl.text = self.commont.upNum.stringValue;
    s = [supportNumLbl.text sizeWithFont:[UIFont systemFontOfSize:commentSupportNumFont]];
    supportNumLbl.frame = CGRectMake(screentWith - marginX - s.width - 3, CGRectGetMinY(commentDateLbl.frame), s.width + 3, commentSupportNumFont);

    supportIconV.frame = CGRectMake(CGRectGetMinX(supportNumLbl.frame) - commentIconWidth, CGRectGetMinY(supportNumLbl.frame), commentIconWidth, commentIconWidth);

    supportBtn.frame = CGRectMake(screentWith - 50, CGRectGetMaxY(supportIconV.frame) + marginY - 30, 50, 30);

    line.frame = CGRectMake(marginX, CGRectGetMaxY(supportIconV.frame) + marginY, screentWith - marginX, 0.8);
}

/**
 *  给回复的点赞
 */
-(void)supportBtnClicked
{
    ClubTask *task = [[ClubTask alloc] initUpCommentWithCommentId:self.commont.commentId.integerValue
                                                         Finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self supportFinish:userInfo andSucced:succeeded];
    }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)supportFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed {
    if (succeed) {
        self.commont.upNum = [NSNumber numberWithInteger:self.commont.upNum.integerValue + 1];
        supportNumLbl.text = self.commont.upNum.stringValue;
        [appDelegate showAlertViewForTitle:@"" message:@"已赞" cancelButton:@"OK"];

        self.commont.isUp = 1;

        if (self.commont.isUp) {
            [supportIconV setImage:[UIImage imageNamed:@"ic_bbs_supported"]];
        } else {
            [supportIconV setImage:[UIImage imageNamed:@"supportIcon"]];
        }
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

@end
