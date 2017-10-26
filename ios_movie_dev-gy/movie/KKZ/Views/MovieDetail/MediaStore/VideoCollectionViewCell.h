//
//  电影详情页面媒体库的电影预告片Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class Movie;

@interface VideoCollectionViewCell : UICollectionViewCell {

    //影片背景图片
    UIImageView *imagePathView;
}

/**
 *  海报
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 *  影片数组
 */
@property (nonatomic, strong) NSArray *videoSource;

@property (nonatomic, strong) Movie *movie;

/**
 *  更新数据
 */
- (void)upLoadData;

@end
