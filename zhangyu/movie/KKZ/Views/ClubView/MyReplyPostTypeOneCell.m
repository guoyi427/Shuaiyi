//
//  MyReplyPostTypeOneCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//


#import "ImageEngineNew.h"
#import "MyReplyPostTypeOneCell.h"
#import "MyReplyView.h"
#import "TypeOnePostThumbnailContentView.h"
#import "UIConstants.h"

#define marginY 15
#define thumbnailContentViewHeight 85
#define cellMarginX 15

#define cellMarginX 15
#define myReplyWordFont 17
#define marginMyReplyView (10 * 2 + 7 + 12 + 5)
#define myReplyWordLblWidth (screentWith - cellMarginX * 2 - 10 * 2)

@implementation MyReplyPostTypeOneCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载我的回复
        [self loadMyReply];
        //加载原贴信息
        [self loadPost];
        //cell的分割线
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(cellMarginX, 0, screentWith, 1)];
        [bottomLine setBackgroundColor:kUIColorDivider];
        [self addSubview:bottomLine];
    }

    return self;
}

/**
 *  加载我的回复
 */
- (void)loadMyReply {
    myReplyView = [[MyReplyView alloc] initWithFrame:CGRectMake(0, marginY, screentWith, marginY)];
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

    NSString *str = [NSString stringWithFormat:@"我的回复：%@", self.myReplyWords];

    //设置行间距

    NSMutableParagraphStyle *paragraphStyle =

            [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{

        NSFontAttributeName : [UIFont systemFontOfSize:myReplyWordFont],

        NSParagraphStyleAttributeName : paragraphStyle

    };

    CGFloat contentW = myReplyWordLblWidth;

    CGRect tmpRect = [str boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)

                                       options:NSStringDrawingUsesLineFragmentOrigin

                                    attributes:attributes

                                       context:nil];

    CGSize s = tmpRect.size;

    thumbnailContentView.frame = CGRectMake(0, marginY + marginMyReplyView + s.height + marginY, screentWith, thumbnailContentViewHeight);

    //加载缩略帖子内容
    thumbnailContentView.postImgPath = self.postImgPath;

    thumbnailContentView.postWord = [NSString stringWithFormat:@"原帖标题：%@", self.postWord];

    thumbnailContentView.post = self.post;

    [thumbnailContentView UpLoadData];

    [thumbnailContentView setBackgroundColor:[UIColor clearColor]];

    bottomLine.frame = CGRectMake(cellMarginX, CGRectGetMaxY(thumbnailContentView.frame) + marginY - 1, screentWith, 1);
}

/**
 *  加载原帖
 */
- (void)loadPost

{

    thumbnailContentView = [[TypeOnePostThumbnailContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myReplyView.frame), screentWith, thumbnailContentViewHeight)];

    [self addSubview:thumbnailContentView];
}
@end
