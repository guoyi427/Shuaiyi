//
//  MyReplyView.m
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DateEngine.h"
#import "MyReplyView.h"

#define myReplyWordFont 17

#define myReplyWordLblColor [UIColor colorWithRed:76 / 255.0 green:76 / 255.0 blue:76 / 255.0 alpha:1]
#define titleColor appDelegate.kkzBlue
#define bgColor [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]

#define myReplyWordLblWidth (screentWith - marginX * 2 - marginVToLblX * 2)

#define marginX 15
#define marginY 0

#define marginVToLblX 10
#define marginVToLblY 10

#define replyDateFont 12

#define marginVHeight 5

#define marginVToDatelbl 7

@implementation MyReplyView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //评论信息的背景
        myReplyWordVBg = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, screentWith - marginX * 2, myReplyWordFont + marginVToLblY * 2 + marginVHeight)];
        [self addSubview:myReplyWordVBg];
        [myReplyWordVBg setBackgroundColor:bgColor];

        arrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(myReplyWordVBg.frame) - 50, CGRectGetMaxY(myReplyWordVBg.frame), 15, 10)];
        arrow.image = [UIImage imageNamed:@"downArrow"];
        [self addSubview:arrow];

        //评论信息的lbl
        myReplyWordLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginVToLblX, marginVToLblY, myReplyWordLblWidth, myReplyWordFont)];
        [myReplyWordVBg addSubview:myReplyWordLbl];
        myReplyWordLbl.textColor = myReplyWordLblColor;
        myReplyWordLbl.font = [UIFont systemFontOfSize:myReplyWordFont];
        myReplyWordLbl.numberOfLines = 0;

        //评论的时间
        replyDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(myReplyWordVBg.frame) + marginVToDatelbl, screentWith - marginX * 2, replyDateFont)];
        replyDateLbl.textColor = [UIColor lightGrayColor];
        replyDateLbl.text = self.replyDate;
        replyDateLbl.font = [UIFont systemFontOfSize:replyDateFont];
        replyDateLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:replyDateLbl];
    }
    return self;
}

/**
 * 更新数据
 */
- (void)upLoadData {
    NSString *noteLblText = [NSString stringWithFormat:@"我的回复：%@", self.myReplyWords];

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:myReplyWordFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };

    CGFloat contentW = myReplyWordLblWidth;

    CGRect tmpRect = [noteLblText boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil];

    CGSize s = tmpRect.size;

    myReplyWordVBg.frame = CGRectMake(marginX, marginY, screentWith - marginX * 2, s.height + marginVToLblY * 2 + marginVHeight);

    myReplyWordLbl.frame = CGRectMake(marginVToLblX, marginVToLblY, myReplyWordLblWidth, s.height);

    [self stringWithMyReplyWord:noteLblText andLabel:myReplyWordLbl andTextColor1:titleColor];

    replyDateLbl.text = self.replyDate;
    replyDateLbl.frame = CGRectMake(marginX, CGRectGetMaxY(myReplyWordVBg.frame) + marginVToDatelbl, screentWith - marginX * 2, replyDateFont);

    arrow.frame = CGRectMake(CGRectGetMaxX(myReplyWordVBg.frame) - 40, CGRectGetMaxY(myReplyWordVBg.frame) - 3, 15, 10);
}

/**
 *  修改部分文字的颜色
 */
- (void)stringWithMyReplyWord:(NSString *)myReplyStr andLabel:(UILabel *)label andTextColor1:(UIColor *)color1 {
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:myReplyStr];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"："].location);
    NSRange redRangeAll = NSMakeRange(0, noteStr.length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:color1 range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:myReplyWordFont] range:redRangeAll];

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:redRangeAll];
    [label setAttributedText:noteStr];
}
@end
