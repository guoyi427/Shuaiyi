//
//  ClubPostHeadViewAudio.h
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "VideoPostInfoView.h"
#import <UIKit/UIKit.h>

@interface ClubPostHeadViewAudio : UIView
/**
 *  初始化视图
 *
 *  @param frame    视图尺寸
 *  @param audioUrl 音频的地址
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                 withAudioUrl:(NSString *)audioUrl;

@property (nonatomic, strong) ClubPost *clubPost;

@property (nonatomic, copy) NSString *postImgPath;

@property (nonatomic, strong) VideoPostInfoView *videoPostInfoView;

- (void)uploadData;
@end
