//
//  电影详情页面媒体库的电影剧照Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface MoviePictureCollectionViewCell : UICollectionViewCell {

    //影片背景图片
    UIImageView *imagePathView;
}

/**
 *  海报
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 *  更新数据
 */
- (void)upLoadData;

@end
