//
//  ClubPostHeadViewText.m
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//
#import "ClubCellBottom.h"
#import "ClubPostHeadViewText.h"
#import "MovieStillScrollViewController.h"

#import "KKZUtility.h"
#import "ClubPost.h"

#define marginX 15
#define marginY 15

//用户头像和文字之间的距离
#define marginHeadImgToWord 20
//图片和文字之间的距离
#define marginWordToPicture 25

#define userInfoViewHeight 33

#define postTextColor [UIColor blackColor]
#define postTextFont 14
#define postPictureWith (screentWith - marginX * 2)

@implementation ClubPostHeadViewText
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载用户信息
        [self loadUserInfoView];
    }

    return self;
}

/**
 *  加载用户信息
 */
- (void)loadUserInfoView {
    userInfoView = [[ClubCellBottom alloc] initWithFrame:CGRectMake(0, marginHeadImgToWord, screentWith, userInfoViewHeight)];
    [self addSubview:userInfoView];

    //加载用户信息
    [userInfoView setBackgroundColor:[UIColor clearColor]];
}

/**
 *  加载帖子内容
 */
- (void)loadPostText {
    postText = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userInfoView.frame), screentWith - marginX * 2, 0)];
    postText.numberOfLines = 0;
    postText.textColor = postTextColor;
    postText.font = [UIFont systemFontOfSize:postTextFont];

    if (self.clubPost.content.length) {
        postText.text = self.clubPost.content;
    } else if (self.clubPost.title.length) {
        postText.text = self.clubPost.title;
    } else {
        postText.text = @"暂未获取到帖子内容";
    }

    if (postText.text.length) {
        CGSize postTextStr = [postText.text sizeWithFont:[UIFont systemFontOfSize:postTextFont] constrainedToSize:CGSizeMake(screentWith - marginX * 2, CGFLOAT_MAX)];
        postText.frame = CGRectMake(marginX, CGRectGetMaxY(userInfoView.frame) + marginHeadImgToWord, screentWith - marginX * 2, postTextStr.height);
        [self addSubview:postText];
    }
}

/**
 *  加载帖子图片
 */
- (void)loadPostPicture {

    //加载帖子图片
    for (int i = 0; i < self.clubPhotos.count; i++) {
        [self addPicturesWithIndex:i andImagePath:self.clubPhotos[i]];
    }

    if (self.clubPhotos.count) {
        self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(postText.frame) + self.clubPhotos.count * (marginY + postPictureWith / 122 * 85) + marginWordToPicture + marginWordToPicture - marginY);

    } else {
        if (postText.text.length) {
            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(postText.frame) + marginY);

        } else {
            self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(userInfoView.frame));
        }
    }

    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, self.frame.size.height - 1, screentWith - marginX * 2, 1)];
    [self addSubview:line];

    [KKZUtility drawDashLine:line lineLength:3 lineSpacing:1 lineColor:[UIColor r:235 g:235 b:235]];
}

/**
 *  根据数组加载图片的方法
 */
- (void)addPicturesWithIndex:(NSInteger)index andImagePath:(NSString *)iamgePath {
#warning 需要提供图片的宽高比
    UIImageView *postPictureV = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(postText.frame) + index * (marginY + postPictureWith / 122 * 85) + marginWordToPicture, postPictureWith, postPictureWith / 122 * 85)];
    [postPictureV setBackgroundColor:[UIColor clearColor]];
    postPictureV.contentMode = UIViewContentModeScaleAspectFill;
    postPictureV.clipsToBounds = YES;

    UIButton *postPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, postPictureWith, postPictureWith / 122 * 85)];
    postPictureBtn.tag = index + 200;
    [postPictureBtn addTarget:self action:@selector(postPictureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [postPictureV addSubview:postPictureBtn];
    [self addSubview:postPictureV];
    //网络加载图片
    [postPictureV loadImageWithURL:iamgePath andSize:ImageSizeOrign imgNameDefault:@"clubPostImage"];
}

/**
 *  点击帖子中的图片查看大图
 */
- (void)postPictureBtnClicked:(UIButton *)btn {
    MovieStillScrollViewController *ctr = [[MovieStillScrollViewController alloc] init];
    ctr.isMovie = NO;
    ctr.index = btn.tag - 200;
    ctr.gallerys = self.clubPhotos;

    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

/**
 *  加载数据
 */
- (void)uploadData {
    userInfoView.clubPost = self.clubPost;
    userInfoView.supportNum = self.clubPost.upNum;
    userInfoView.commentNum = self.clubPost.replyNum;

    userInfoView.postDate = self.clubPost.publishTime;
    userInfoView.postId = [self.clubPost.articleId intValue];
    [userInfoView upLoadData];

    //加载帖子内容
    [self loadPostText];

    self.clubPhotos = [self.clubPost.filesImage mutableCopy];

    //加载帖子图片
    [self loadPostPicture];

    if (self.delegate && [self.delegate respondsToSelector:@selector(addTableViewHeaderWithClubPostHeadViewHeight:)]) {
        [self.delegate addTableViewHeaderWithClubPostHeadViewHeight:self.frame.size.height];
        DLog(@"clubHeaderView.frame.size.height == %f", clubHeaderView.frame.size.height + marginY);
    }
}

@end
