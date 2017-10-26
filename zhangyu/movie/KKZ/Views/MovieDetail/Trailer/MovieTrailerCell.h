//
//  电影详情 - 预告片列表的Cell
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MoviePlayerViewController.h"

@class Trailer;

@interface MovieTrailerCell : UICollectionViewCell <MoviePlayerViewControllerDataSource, MoviePlayerViewControllerDelegate> {

    UIImageView *imageView;

    MoviePlayerViewController *movieVC;
}

@property (nonatomic, strong) Trailer *trailer;

@property (nonatomic, copy) NSString *imagePath;

- (void)upLoadData;

@end
