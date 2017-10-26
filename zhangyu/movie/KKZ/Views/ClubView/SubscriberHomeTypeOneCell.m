//
//  SubscriberHomeTypeOneCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "SubscriberHomeTypeOneCell.h"

#import "SubscriberHomeCellBottom.h"
#import "UIConstants.h"
#import "ImageEngineNew.h"

#import "TypeOnePostThumbnailContentView.h"

#define bottomHeight 15

#define cellMarginY 15
#define cellMarginX 15
#define cellHeight 147

#define thumbnailContentViewHeight 118

@implementation SubscriberHomeTypeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //加载帖子内容
        [self loadPost];

        //用户信息
        subscriberHomeCellBottom = [[SubscriberHomeCellBottom alloc]
                initWithFrame:CGRectMake(0, cellHeight - bottomHeight - cellMarginY,
                                         screentWith, bottomHeight)];
        [subscriberHomeCellBottom setBackgroundColor:[UIColor clearColor]];
        [self addSubview:subscriberHomeCellBottom];

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
    subscriberHomeCellBottom.supportNum = self.supportNum;
    subscriberHomeCellBottom.commentNum = self.commentNum;
    subscriberHomeCellBottom.postDate = self.postDate;
    [subscriberHomeCellBottom upLoadData];
}

- (void)loadPost {
    thumbnailContentView = [[TypeOnePostThumbnailContentView alloc]
            initWithFrame:CGRectMake(0, cellMarginY, screentWith,
                                     thumbnailContentViewHeight)];
    [self addSubview:thumbnailContentView];
}

@end
