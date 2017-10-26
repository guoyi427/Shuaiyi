//
//  MyReplyPostTypeTwoCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//
#import "ImageEngineNew.h"
#import "MyReplyPostTypeTwoCell.h"
#import "MyReplyTypeTwoPostThumbnailContentView.h"
#import "MyReplyView.h"
#import "UIConstants.h"

#define wordFont 17

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define twoTypeThumbnailContentViewHeight11 wordHeight1
#define twoTypeThumbnailContentViewHeight21 wordHeight1 + 15 + photosViewHeight

#define twoTypeThumbnailContentViewHeight12 wordHeight2
#define twoTypeThumbnailContentViewHeight22 wordHeight2 + 15 + photosViewHeight

#define photosViewHeight 85

#define marginY 15
#define cellMarginX 15
#define myReplyWordFont 17
#define marginMyReplyView (10 * 2 + 7 + 12 + 5)
#define myReplyWordLblWidth (screentWith - cellMarginX * 2 - 10 * 2)

#define marginTypeCell (marginY * 2 + 10 * 2 + 7 + 12 + 5)

@implementation MyReplyPostTypeTwoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载我的回复
        [self loadMyReply];
        //加载原贴信息
        [self loadPost];
        // cell的分割线
        bottomLine = [[UIView alloc]
                initWithFrame:CGRectMake(cellMarginX, 0, screentWith, 1)];
        [bottomLine setBackgroundColor:kUIColorDivider];
        [self addSubview:bottomLine];
    }
    return self;
}

/**
 *  加载我的回复
 */
- (void)loadMyReply {
    myReplyView = [[MyReplyView alloc]
            initWithFrame:CGRectMake(0, marginY, screentWith, marginY)];
    [self addSubview:myReplyView];
}

/**
 *  加载数据
 */
- (void)upLoadData {
    //我的回复信息以及回复时间
    myReplyView.myReplyWords = self.myReplyWords;
    myReplyView.replyDate = self.postDate;
    [myReplyView upLoadData];

    NSString *str =
            [NSString stringWithFormat:@"我的回复：%@", self.myReplyWords];

    //设置行间距

    NSMutableParagraphStyle *paragraphStyle =

            [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{

        NSFontAttributeName : [UIFont systemFontOfSize:myReplyWordFont],

        NSParagraphStyleAttributeName : paragraphStyle

    };

    CGFloat contentW = myReplyWordLblWidth;

    CGRect tmpRect =
            [str boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)

                                 options:NSStringDrawingUsesLineFragmentOrigin

                              attributes:attributes

                                 context:nil];

    CGSize s = tmpRect.size;

    CGFloat thumbnailContentViewHeight = 0;

    thumbnailContentView.postImgPaths = self.postImgPaths;

    NSString *postWordStr =
            [NSString stringWithFormat:@"原帖标题：%@", self.postWord];
    thumbnailContentView.postWord = postWordStr;
    thumbnailContentView.post = self.post;
    [thumbnailContentView upLoadData];

    NSDictionary *attributes1 = @{

        NSFontAttributeName : [UIFont systemFontOfSize:wordFont],

        NSParagraphStyleAttributeName : paragraphStyle

    };

    CGFloat contentW1 = screentWith - cellMarginX * 2;

    CGRect tmpRect1 =
            [postWordStr boundingRectWithSize:CGSizeMake(contentW1, MAXFLOAT)

                                      options:NSStringDrawingUsesLineFragmentOrigin

                                   attributes:attributes1

                                      context:nil];

    CGSize postS = tmpRect1.size;

    //    CGSize postS = [postWordStr sizeWithFont:[UIFont
    //    systemFontOfSize:wordFont] constrainedToSize:CGSizeMake(screentWith -
    //    cellMarginX * 2, CGFLOAT_MAX)];

    if (self.postImgPaths.count) { //上下结构 只有文字的情况

        if (postS.height >= wordH) {
            thumbnailContentViewHeight = twoTypeThumbnailContentViewHeight21;
        } else {
            thumbnailContentViewHeight = twoTypeThumbnailContentViewHeight22;
        }

    } else {
        if (postS.height >= wordH) {
            thumbnailContentViewHeight = twoTypeThumbnailContentViewHeight11;
        } else {
            thumbnailContentViewHeight = twoTypeThumbnailContentViewHeight12;
        }
    }
    thumbnailContentView.frame = CGRectMake(
            0, marginTypeCell + s.height, screentWith, thumbnailContentViewHeight);

    bottomLine.frame = CGRectMake(
            cellMarginX, CGRectGetMaxY(thumbnailContentView.frame) + marginY - 1,
            screentWith, 1);
}

/**
 *  加载原帖
 */
- (void)loadPost {

    thumbnailContentView = [[MyReplyTypeTwoPostThumbnailContentView alloc]
            initWithFrame:CGRectMake(0, CGRectGetMaxY(myReplyView.frame), screentWith,
                                     marginY)];

    [self addSubview:thumbnailContentView];
}

@end
