//
//  电影详情 - 预告片列表页面
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
@class Movie;

@interface MovieTrailerListViewController : CommonViewController <UICollectionViewDataSource, UICollectionViewDelegate> {

    UICollectionView *movieTrailerView;

    NSInteger currentPage;
}

/**
 *  影片数组
 */
@property (nonatomic, strong) NSMutableArray *videoSource;

@property (nonatomic, strong) Movie *movie;
@end
