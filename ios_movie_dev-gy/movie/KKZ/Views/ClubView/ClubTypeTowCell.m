//
//  ClubTypeTowCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubTypeTowCell.h"
#import "ClubCellBottom.h"
#import "UIConstants.h"
#import "ImageEngineNew.h"
#import "TypeTwoPostThumbnailContentView.h"

#define bottomHeight 33
#define cellMarginY 15
#define cellMarginX 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 226
#define cellHeight2 201

#define cellOnlyWordHeight1 126
#define cellOnlyWordHeight2 100

#define marginImgToWord 15

#define wordFont 17
//#define wordHeight 40

#define photosViewHeight 85

@implementation ClubTypeTowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载帖子内容
        [self loadPost];

        //用户信息
        clubCellBottom = [[ClubCellBottom alloc] initWithFrame:CGRectMake(0, cellHeight1 - bottomHeight - cellMarginY, screentWith, bottomHeight)];
        [clubCellBottom setBackgroundColor:[UIColor clearColor]];
        [self addSubview:clubCellBottom];

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

    CGFloat thumbnailContentViewHeight = 0;

    if (self.postImgPaths.count) { //上下结构 只有文字的情况
        CGFloat cellHeight = cellHeight1;
        if (s.height >= wordH) {
            cellHeight = cellHeight1;
        } else {
            cellHeight = cellHeight2;
        }

        thumbnailContentViewHeight = cellHeight - bottomHeight - marginImgToWord - cellMarginY;

        clubCellBottom.frame = CGRectMake(0, cellHeight - bottomHeight - cellMarginY, screentWith, bottomHeight);
        bottomLine.frame = CGRectMake(cellMarginX, cellHeight - 1, screentWith, 1);
    } else {
        CGFloat cellOnlyWordHeight = cellOnlyWordHeight1;
        if (s.height >= wordH) {
            cellOnlyWordHeight = cellOnlyWordHeight1;
        } else {
            cellOnlyWordHeight = cellOnlyWordHeight2;
        }

        thumbnailContentViewHeight = cellOnlyWordHeight - bottomHeight - marginImgToWord - cellMarginY;

        clubCellBottom.frame = CGRectMake(0, cellOnlyWordHeight - bottomHeight - cellMarginY, screentWith, bottomHeight);
        bottomLine.frame = CGRectMake(cellMarginX, cellOnlyWordHeight - 1, screentWith, 1);
    }

    thumbnailContentView.frame = CGRectMake(0, cellMarginY, screentWith, thumbnailContentViewHeight);

    //加载用户信息
    clubCellBottom.clubPost = self.post;
    clubCellBottom.supportNum = self.supportNum;
    clubCellBottom.commentNum = self.commentNum;
    clubCellBottom.postDate = self.postDate;
    [clubCellBottom upLoadData];

    [clubCellBottom setBackgroundColor:[UIColor clearColor]];
}

/**
 *  帖子内容
 */
- (void)loadPost {
    thumbnailContentView = [[TypeTwoPostThumbnailContentView alloc] initWithFrame:CGRectMake(0, cellMarginY, screentWith, cellOnlyWordHeight1)];
    [self addSubview:thumbnailContentView];
}

@end
