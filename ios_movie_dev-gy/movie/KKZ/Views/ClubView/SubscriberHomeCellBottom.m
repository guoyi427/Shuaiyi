//
//  SubscriberHomeCellBottom.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DateEngine.h"
#import "SubscriberHomeCellBottom.h"

#define marginX 15

#define SupportIconWith 13
#define SupportIconHeight 15

#define WordSupportNumHeight 15

#define WordDateLabelHeight 15

#define DateFont 12

#define SubscriberHomeCellBottomHeight 15

#define marginImgToWord 3

#define marginIconToIcon 10

@implementation SubscriberHomeCellBottom

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {

        //发帖的日期
        postDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, screentWith - marginX * 2, WordDateLabelHeight)];
        postDateLbl.textAlignment = NSTextAlignmentLeft;
        postDateLbl.font = [UIFont systemFontOfSize:DateFont];
        postDateLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:postDateLbl];

        //点赞
        supportLbl = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - marginX, 0, WordSupportNumHeight, WordSupportNumHeight)];
        supportLbl.font = [UIFont systemFontOfSize:DateFont];
        supportLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:supportLbl];

        supportIconV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(supportLbl.frame) - marginImgToWord, 0, SupportIconWith, SupportIconHeight)];
        [self addSubview:supportIconV];
        supportIconV.contentMode = UIViewContentModeScaleAspectFit;
        supportIconV.image = [UIImage imageNamed:@"supportIcon"]; //supportIcon

        //评论
        commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(supportIconV.frame) - marginIconToIcon, 0, WordSupportNumHeight, WordSupportNumHeight)];
        commentLbl.font = [UIFont systemFontOfSize:DateFont];
        commentLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:commentLbl];

        commentIconV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(commentLbl.frame) - marginImgToWord, 0, SupportIconWith, SupportIconWith)];
        [self addSubview:commentIconV];
        commentIconV.contentMode = UIViewContentModeScaleAspectFit;
        commentIconV.image = [UIImage imageNamed:@"commentIcon"];
    }

    return self;
}

//更新用户信息
- (void)upLoadData {

    //点赞的用户数
    if (self.supportNum.integerValue) {
        supportLbl.text = [NSString stringWithFormat:@"%@", self.supportNum];
    } else {
        supportLbl.text = [NSString stringWithFormat:@"0"];
    }
    NSString *supportNumStr = [NSString stringWithFormat:@"%@", self.supportNum];
    CGSize supportNumSize = [supportNumStr sizeWithFont:[UIFont systemFontOfSize:DateFont]];

    supportLbl.frame = CGRectMake(screentWith - marginX - supportNumSize.width, 0, supportNumSize.width, WordSupportNumHeight);
    supportIconV.frame = CGRectMake(CGRectGetMinX(supportLbl.frame) - marginImgToWord - SupportIconWith, 0, SupportIconWith, SupportIconHeight);

    //评论的用户
    if (self.commentNum.integerValue) {
        commentLbl.text = [NSString stringWithFormat:@"%@", self.commentNum];
    } else {
        commentLbl.text = [NSString stringWithFormat:@"0"];
    }
    NSString *commentNumStr = [NSString stringWithFormat:@"%@", self.commentNum];
    CGSize commentNumSize = [commentNumStr sizeWithFont:[UIFont systemFontOfSize:DateFont]];
    commentLbl.frame = CGRectMake(CGRectGetMinX(supportIconV.frame) - marginIconToIcon - commentNumSize.width, 0, commentNumSize.width, WordSupportNumHeight);
    commentIconV.frame = CGRectMake(CGRectGetMinX(commentLbl.frame) - marginImgToWord - SupportIconWith, 0, SupportIconWith, SupportIconHeight);

    //发帖的日期
    //    NSString *timeStr =  [[DateEngine sharedDateEngine] stringFromDate:self.postDate withFormat:@"MM月dd日 HH:mm"];
    postDateLbl.text = self.postDate;
}

@end
