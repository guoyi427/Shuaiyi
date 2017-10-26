//
//  ClubTypeOneCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubCellBottom.h"
#import "ClubTypeOneCell.h"
#import "ImageEngineNew.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "MovieStillScrollViewController.h"
#import "TypeOnePostThumbnailContentView.h"
#import "UIConstants.h"

#define bottomHeight 33
#define cellMarginY 15
#define cellMarginX 15
#define cellHeight 165

#define postImgWith 122
#define postImgHeight 85
#define marginImgToWord 10
#define wordTopMargin 20

#define wordFont 15
#define wordHeight 75
#define postImgCoverHeight 117

#define videoIconWith 25
#define audioIconWith 25

#define thumbnailContentViewHeight 118

@implementation ClubTypeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //加载帖子内容
        [self loadPost];

        //用户信息
        clubCellBottom = [[ClubCellBottom alloc]
                initWithFrame:CGRectMake(0, cellHeight - bottomHeight - cellMarginY,
                                         screentWith, bottomHeight)];
        [clubCellBottom setBackgroundColor:[UIColor clearColor]];
        [self addSubview:clubCellBottom];

        // cell的分割线
        UIView *bottomLine = [[UIView alloc]
                initWithFrame:CGRectMake(cellMarginX, cellHeight - 1, screentWith, 1)];
        [bottomLine setBackgroundColor:kUIColorDivider];
        [self addSubview:bottomLine];
    }
    return self;
}

/**
 *  更新用户信息
 */
- (void)upLoadData {

    //加载缩略帖子内容

    thumbnailContentView.postImgPath = self.postImgPath;
    thumbnailContentView.postWord = self.postWord;
    thumbnailContentView.post = self.post;
    [thumbnailContentView UpLoadData];

    //加载用户信息
    clubCellBottom.supportNum = self.supportNum;
    clubCellBottom.commentNum = self.commentNum;
    clubCellBottom.postDate = self.postDate;
    clubCellBottom.clubPost = self.post;
    [clubCellBottom upLoadData];
}

/**
 *  帖子内容
 */
- (void)loadPost {
    thumbnailContentView = [[TypeOnePostThumbnailContentView alloc]
            initWithFrame:CGRectMake(0, cellMarginY, screentWith,
                                     thumbnailContentViewHeight)];
    [self addSubview:thumbnailContentView];
}

@end
