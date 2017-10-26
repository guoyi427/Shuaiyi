//
//  电影详情页面媒体库的电影原声Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//
@class Movie;

@interface AudioCollectionViewCell : UICollectionViewCell {

    //影片背景图片
    UIImageView *imagePathView;
}

/**
 *  海报
 */
@property (nonatomic, strong) NSString *imagePath;

@property (nonatomic, strong) Movie *movie;

/**
 *  更新数据
 */
- (void)upLoadData;

@end
