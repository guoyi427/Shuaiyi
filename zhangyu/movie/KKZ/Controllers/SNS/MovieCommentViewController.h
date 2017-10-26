//
//  MovieCommentViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/27.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "MovieSelectHeader.h"
#import "MovieSelectView.h"
#import "RecordAudioView.h"
#import "CameraHelperView.h"
#import "MovieCommentViewModel.h"

typedef enum : NSUInteger {
    movieCommentViewType,
    addImageViewType,
} ViewType;

@interface MovieCommentViewController : CommonViewController


/**
 *  照相机视图
 */
@property (nonatomic, strong) CameraHelperView *cameraHelperView;

/**
 *  录制音频视图
 */
@property (nonatomic, strong) RecordAudioView *recordAudioView;

/**
 *  电影评论页面的ViewModel模型
 */
@property (nonatomic, strong) MovieCommentViewModel *movieCommentViewModel;

/**
 *  选择的显示类型
 */
@property (nonatomic, assign) chooseType type;

/**
 *  当前的页面类型
 */
@property (nonatomic, assign) ViewType viewType;

@end
