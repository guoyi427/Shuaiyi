//
//  电影详情页面媒体库的电影原声Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AudioCollectionViewCell.h"

#import "CommonViewController.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "SoundtrackViewController.h"
#import "UIConstants.h"
#import "Movie.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define imagePathViewWidth 97
#define imagePathViewHeight 72
#define roundVWidth 70

#define AudioBtnEdgeInsetsMakeX (imagePathViewWidth - 50 - 23) * 0.5
#define AudioBtnEdgeInsetsMakeY (imagePathViewHeight - 50 - 23) * 0.5

@implementation AudioCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *roundV = [[UIView alloc] initWithFrame:CGRectMake(imagePathViewWidth - 10 - 6 - roundVWidth, (imagePathViewHeight - roundVWidth) * 0.5, roundVWidth, roundVWidth)];
        [roundV setBackgroundColor:[UIColor blackColor]];
        roundV.layer.cornerRadius = roundVWidth * 0.5;
        roundV.clipsToBounds = YES;
        [self addSubview:roundV];

        imagePathView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imagePathViewWidth - 10 - 18, imagePathViewHeight)];
        [self addSubview:imagePathView];
        imagePathView.contentMode = UIViewContentModeScaleAspectFill;
        imagePathView.clipsToBounds = YES;

        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imagePathViewWidth - 10 - 18, imagePathViewHeight)];
        [cover setBackgroundColor:[UIColor r:0 / 255.0 g:0 / 255.0 b:0 / 255.0 alpha:0.6]];
        [imagePathView addSubview:cover];

        UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imagePathViewWidth - 10 - 18, imagePathViewHeight)];
        [videoBtn setImage:[UIImage imageNamed:@"musicIcon"] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [videoBtn setImageEdgeInsets:UIEdgeInsetsMake(AudioBtnEdgeInsetsMakeY, AudioBtnEdgeInsetsMakeX, AudioBtnEdgeInsetsMakeY, AudioBtnEdgeInsetsMakeX)];
        [self addSubview:videoBtn];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(imagePathViewWidth - 11, 0, 1, imagePathViewHeight)];
        [line setBackgroundColor:kUIColorDivider];
        [self addSubview:line];
    }
    return self;
}

- (void)upLoadData {
    [imagePathView sd_setImageWithURL:[NSURL URLWithString:self.imagePath]];
    
}

- (void)videoBtnClicked {
    SoundtrackViewController *swf = [[SoundtrackViewController alloc] init];
    swf.movie = self.movie;

    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:swf animation:CommonSwitchAnimationBounce];
}

@end
