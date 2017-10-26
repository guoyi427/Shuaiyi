//
//  TypeOnePostThumbnailContentView.h
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeOnePostThumbnailContentView : UIView {
    //帖子中的图片缩略图
    //    UIImageView *postImgView;
    UIImageView *postImgViewText, *postImgViewVideo, *postImgViewAudio;
    //帖子中的文字
    UILabel *postWordLbl;
    //音频帖子中的图片遮层
    UIButton *audioPostImgViewCover;
    //视频帖子中的图片遮层
    UIButton *videoPostImgViewCover;
    //视频Icon
    UIImageView *videoIcon;
    //音频Icon
    UIImageView *audioIcon;
    //图片帖子中的图片遮层
    UIButton *photoPostImgViewCover;
}

/**
 *  帖子文字
 */
@property (nonatomic, copy) NSString *postWord;

/**
 * 图片地址
 */
@property (nonatomic, copy) NSString *postImgPath;

/**
 *  视频路径
 */
@property (nonatomic, copy) NSString *videoPath;

/**
 *  音频路径
 */
@property (nonatomic, copy) NSString *audioPath;



@property (nonatomic, strong) ClubPost *post;

/**
 *  更新用户信息
 */
- (void)UpLoadData;

@end
