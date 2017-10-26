//
//  电影详情页面媒体库Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class Movie;

@interface MovieMediaStoreCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource> {

    //显示的表视图
    UICollectionView *moviePictureCollectionView;

    //表视图尺寸
    CGRect moviePictureCollectionFrame;

    UICollectionViewFlowLayout *flowLauout;
}

/**
 *  显示的海报
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  电影列表
 */
@property (nonatomic, strong) NSMutableArray *movieTrailerArray;

/**
 *  电影数量
 */
@property (nonatomic, assign) NSInteger movieTrailerTotal;

/**
 *  电影音乐列表
 */
@property (nonatomic, strong) NSMutableArray *movieSongArray;

/**
 *  电影音乐数量
 */
@property (nonatomic, assign) NSInteger movieSongTotal;

/**
 *  剧照列表
 */
@property (nonatomic, strong) NSMutableArray *movieGalleryArray;

/**
 *  电影剧照数量
 */
@property (nonatomic, assign) NSInteger movieGalleryTotal;

/**
 *  电影Id
 */
@property (nonatomic, strong) Movie *movie;

/**
 *  更新表视图
 */
- (void)reloadTableData;

@end
