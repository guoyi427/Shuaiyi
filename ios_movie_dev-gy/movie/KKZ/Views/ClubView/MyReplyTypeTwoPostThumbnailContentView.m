//
//  MyReplyTypeTwoPostThumbnailContentView.m
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MyReplyTypeTwoPostThumbnailContentView.h"

#import "UIConstants.h"
#import "ImageEngineNew.h"
#import "ClubPhotoView.h"

#define cellMarginY 0
#define cellMarginX 15

#define marginImgToWord 15

#define wordFont 17

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define photosViewHeight 85

@implementation MyReplyTypeTwoPostThumbnailContentView
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
    //      CGSize s = [self.postWord sizeWithFont:[UIFont systemFontOfSize:wordFont] constrainedToSize:CGSizeMake(screentWith - cellMarginX * 2, CGFLOAT_MAX)];

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

    postWordLbl.attributedText = [[NSAttributedString alloc] initWithString:postWordLbl.text
                                                                 attributes:attributes];

    CGFloat wordHeight = wordHeight1;
    if (s.height >= wordH) {
        wordHeight = wordHeight1;
    } else {
        wordHeight = wordHeight2;
    }

    if (self.postImgPaths.count) {
        //加载帖子图片缩略图
        photosView.photos = self.postImgPaths;
        photosView.post = self.post;
        [photosView reloadData];

        photosView.hidden = NO;

        postWordLbl.frame = CGRectMake(cellMarginX, CGRectGetMaxY(photosView.frame) + marginImgToWord, screentWith - cellMarginX * 2, wordHeight);

    } else {
        photosView.hidden = YES;
        postWordLbl.frame = CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX * 2, wordHeight);
    }
}

/**
 *  帖子内容
 */
- (void)loadPost {
    //帖子中的图片缩略图
    photosView = [[ClubPhotoView
            alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX,
                                            photosViewHeight)];
    photosView.clipsToBounds = YES;
    photosView.backgroundColor = [UIColor clearColor];
    [self addSubview:photosView];

    //帖子中的文字
    postWordLbl = [[UILabel alloc] initWithFrame:CGRectMake(cellMarginX, CGRectGetMaxY(photosView.frame) + marginImgToWord, screentWith - cellMarginX * 2, wordHeight1)];
    postWordLbl.numberOfLines = 0;
    postWordLbl.textColor = [UIColor blackColor];
    postWordLbl.font = [UIFont systemFontOfSize:wordFont];
    [self addSubview:postWordLbl];
}

@end
