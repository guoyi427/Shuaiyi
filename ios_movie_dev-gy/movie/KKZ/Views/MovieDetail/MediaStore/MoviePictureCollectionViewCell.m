//
//  电影详情页面媒体库的电影剧照Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MoviePictureCollectionViewCell.h"

#import "ImageEngineNew.h"

#define imagePathViewWidth 87
#define imagePathViewHeight 72

@implementation MoviePictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imagePathView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imagePathViewWidth, imagePathViewHeight)];
        [self addSubview:imagePathView];
        imagePathView.contentMode = UIViewContentModeScaleAspectFill;
        imagePathView.clipsToBounds = YES;
    }
    return self;
}

- (void)upLoadData {
    [imagePathView loadImageWithURL:self.imagePath andSize:ImageSizeOrign];
}

@end
