//
//  TypeTwoPostThumbnailContentView.h
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubPhotoView;

@interface TypeTwoPostThumbnailContentView : UIView {
    //帖子中的图片列表
    ClubPhotoView *photosView;
    //帖子中的文字
    UILabel *postWordLbl;
}

/**
 * 图片地址
 */
@property (nonatomic, strong) NSArray *postImgPaths;

/**
 *  帖子文字
 */
@property (nonatomic, copy) NSString *postWord;

/**
 *  帖子
 */
@property (nonatomic, strong) ClubPost *post;

/**
 *  更新用户信息
 */
- (void)upLoadData;

@end
