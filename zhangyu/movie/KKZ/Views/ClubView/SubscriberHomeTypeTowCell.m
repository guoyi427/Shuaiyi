//
//  SubscriberHomeTypeTowCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ImageEngineNew.h"
#import "SubscriberHomeCellBottom.h"
#import "SubscriberHomeTypeTowCell.h"
#import "TypeTwoPostThumbnailContentView.h"
#import "UIConstants.h"

#define bottomHeight 15
#define cellMarginY 15
#define cellMarginX 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 206
#define cellHeight2 181

#define cellOnlyWordHeight1 106
#define cellOnlyWordHeight2 81

#define marginImgToWord 15

#define wordFont 17
//#define wordHeight 40

#define photosViewHeight 85

@implementation SubscriberHomeTypeTowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载帖子内容
        [self loadPost];

        //用户信息
        subscriberHomeCellBottom = [[SubscriberHomeCellBottom alloc] initWithFrame:CGRectMake(0, cellHeight1 - bottomHeight - cellMarginY, screentWith, bottomHeight)];
        [subscriberHomeCellBottom setBackgroundColor:[UIColor clearColor]];
        [self addSubview:subscriberHomeCellBottom];

        //cell的分割线
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(cellMarginX, cellHeight1 - 1, screentWith, 1)];
        [bottomLine setBackgroundColor:kUIColorDivider];
        [self addSubview:bottomLine];
    }
    return self;
}

/**
 *  更新用户信息
 */
- (void)upLoadData {

    thumbnailContentView.postImgPaths = self.postImgPaths;
    thumbnailContentView.postWord = self.postWord;
    thumbnailContentView.post = self.post;
    [thumbnailContentView upLoadData];

    //    CGSize s = [self.postWord sizeWithFont:[UIFont systemFontOfSize:wordFont] constrainedToSize:CGSizeMake(screentWith - cellMarginX * 2, CGFLOAT_MAX)];

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };

    CGFloat contentW = screentWith - cellMarginX * 2;

    CGRect tmpRect = [self.postWord boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];

    CGSize s = tmpRect.size;

    if (self.postImgPaths.count) { //上下结构 只有文字的情况
        CGFloat wordHeight = wordHeight1;
        if (s.height >= wordH) {
            wordHeight = wordHeight1;
        } else {
            wordHeight = wordHeight2;
        }

        thumbnailContentView.frame = CGRectMake(0, cellMarginY, screentWith, wordHeight + cellMarginY + photosViewHeight);

    } else {
        CGFloat wordHeight = wordHeight1;
        if (s.height >= wordH) {
            wordHeight = wordHeight1;
        } else {
            wordHeight = wordHeight2;
        }

        thumbnailContentView.frame = CGRectMake(0, cellMarginY, screentWith, wordHeight);
    }

    subscriberHomeCellBottom.frame = CGRectMake(0, CGRectGetMaxY(thumbnailContentView.frame) + cellMarginY, screentWith, bottomHeight);
    bottomLine.frame = CGRectMake(cellMarginX, CGRectGetMaxY(subscriberHomeCellBottom.frame) + cellMarginY - 1, screentWith, 1);

    //加载用户信息
    subscriberHomeCellBottom.supportNum = self.supportNum;
    subscriberHomeCellBottom.commentNum = self.commentNum;
    subscriberHomeCellBottom.postDate = self.postDate;
    [subscriberHomeCellBottom upLoadData];
}

/**
 *  帖子内容
 */
- (void)loadPost {
    thumbnailContentView = [[TypeTwoPostThumbnailContentView alloc] initWithFrame:CGRectMake(0, cellMarginY, screentWith, cellOnlyWordHeight1)];
    [self addSubview:thumbnailContentView];
}

@end
