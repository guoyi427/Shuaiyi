//
//  TypeTwoPostThumbnailContentView.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPhotoView.h"
#import "ImageEngineNew.h"
#import "TypeTwoPostThumbnailContentView.h"
#import "UIConstants.h"

#define bottomHeight 15
#define cellMarginY 0
#define cellMarginX 15

#define marginImgToWord 15

#define wordFont 17
#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define photosViewHeight 85

@implementation TypeTwoPostThumbnailContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载帖子内容
        [self loadPost];
    }
    return self;
}

/**
 *  更新用户信息
 */
- (void)upLoadData {

    //加载帖子文字内容
    postWordLbl.text = self.postWord;

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };

    CGFloat contentW = screentWith - cellMarginX * 2;

    CGRect tmpRect = [postWordLbl.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];

    // 高度H
    CGFloat contentH = tmpRect.size.height;

    CGFloat wordHeight = wordHeight1;
    if (contentH >= wordH) {
        wordHeight = wordHeight1;
    } else {
        wordHeight = wordHeight2;
    }
    postWordLbl.frame = CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX * 2, wordHeight);

    postWordLbl.attributedText = [[NSAttributedString alloc] initWithString:postWordLbl.text
                                                                 attributes:attributes];

    photosView.frame = CGRectMake(cellMarginX, CGRectGetMaxY(postWordLbl.frame) + marginImgToWord,
                                  screentWith - cellMarginX,
                                  photosViewHeight);

    if (self.postImgPaths.count) {
        //加载帖子图片缩略图
        photosView.photos = self.postImgPaths;
        photosView.post = self.post;
        [photosView reloadData];

        photosView.hidden = NO;

    } else {
        photosView.hidden = YES;
    }
}

/**
 *  帖子内容
 */
- (void)loadPost {
    //帖子中的文字
    postWordLbl = [[UILabel alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX * 2, wordHeight1)];
    postWordLbl.numberOfLines = 0;
    postWordLbl.textColor = [UIColor blackColor];
    postWordLbl.font = [UIFont systemFontOfSize:wordFont];
    [self addSubview:postWordLbl];

    //帖子中的图片缩略图
    photosView = [[ClubPhotoView
            alloc] initWithFrame:CGRectMake(cellMarginX,
                                            CGRectGetMaxY(postWordLbl.frame) + marginImgToWord,
                                            screentWith - cellMarginX,
                                            photosViewHeight)];
    photosView.clipsToBounds = YES;
    photosView.backgroundColor = [UIColor clearColor];
    [self addSubview:photosView];
}

@end
