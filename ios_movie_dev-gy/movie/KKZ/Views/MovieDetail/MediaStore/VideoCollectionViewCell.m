//
//  电影详情页面媒体库的电影预告片Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "VideoCollectionViewCell.h"

#import "CommonViewController.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "MovieTrailerListViewController.h"
#import "Movie.h"

#define videoPicturesCellWidth 133
#define imagePathViewHeight 72

#define VideoBtnEdgeInsetsMakeX (videoPicturesCellWidth - 50) * 0.5
#define VideoBtnEdgeInsetsMakeY (imagePathViewHeight - 50) * 0.5

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imagePathView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, videoPicturesCellWidth - 10, imagePathViewHeight)];
        [self addSubview:imagePathView];
        imagePathView.contentMode = UIViewContentModeScaleAspectFill;
        imagePathView.clipsToBounds = YES;

        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoPicturesCellWidth - 10, imagePathViewHeight)];
        [cover setBackgroundColor:[UIColor r:0 / 255.0 g:0 / 255.0 b:0 / 255.0 alpha:0.6]];
        [imagePathView addSubview:cover];

        UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, videoPicturesCellWidth - 10, imagePathViewHeight)];
        [videoBtn setImage:[UIImage imageNamed:@"videoStopIcon"] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [videoBtn setImageEdgeInsets:UIEdgeInsetsMake(VideoBtnEdgeInsetsMakeY, VideoBtnEdgeInsetsMakeX, VideoBtnEdgeInsetsMakeY, VideoBtnEdgeInsetsMakeX)];
        [self addSubview:videoBtn];
    }
    return self;
}

- (void)upLoadData {
    [imagePathView loadImageWithURL:self.imagePath andSize:ImageSizeOrign];
}

- (void)videoBtnClicked {
    DLog(@"点击进入视频播放页面");

    MovieTrailerListViewController *ctr = [[MovieTrailerListViewController alloc] init];
    ctr.videoSource = [self.videoSource mutableCopy];
    ctr.movie = self.movie;
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
}

@end
