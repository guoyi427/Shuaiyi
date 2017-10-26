//
//  ClubPostHeadViewVideo.h
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviePlayerViewController.h"
#import "VideoPostInfoView.h"

@interface ClubPostHeadViewVideo : UIView

/**
 *  初始化视图
 *
 *  @param frame    <#frame description#>
 *  @param videoUrl 视频播放的地址
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame
                withVideoUrl:(NSString *)videoUrl;

/**
 *  视频封面地址
 */
@property (nonatomic, strong) NSString *videoCoverPath;

/**
 *  表视图的y坐标
 */
@property (nonatomic, assign) CGFloat tablePointY;

@property (nonatomic, strong) ClubPost *clubPost;

@property(nonatomic,strong) VideoPostInfoView *videoPostInfoView;

-(void)uploadData;

@end
