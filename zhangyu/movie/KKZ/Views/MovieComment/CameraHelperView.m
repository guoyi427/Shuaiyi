//
//  CameraHelperView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CameraHelperView.h"
#import "MovieCommentViewController.h"
#import "UIColor+Hex.h"
#import "KKZUtility.h"

@implementation CameraHelperView

- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        
        //判断一下是否初始化视频设备成功
        NSString *result = [self.cameraImageHelper instantiationVideoDevice];
        if ([KKZUtility stringIsEmpty:result]) {
            
            //设置捕捉视频的尺寸
            CGRect helpFrame =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);;
            helpFrame.origin.y = 0;
            [self.cameraImageHelper embedPreviewInView:self
                                             WithFrame:helpFrame];
            
        }else {
            
            //未成功弹出提示框，页面消失
            MovieCommentViewController *responder = (MovieCommentViewController *)controller;
            [responder.movieCommentViewModel dismissViewControllerWhenMeidiaInitFail:result];
        }
    }
    return self;
}

- (CameraImageHelper *)cameraImageHelper {
    
    if (!_cameraImageHelper) {
        _cameraImageHelper = [[CameraImageHelper alloc] init];
    }
    return _cameraImageHelper;
}

- (void)dealloc {
    if (_cameraImageHelper) {
        [_cameraImageHelper stopRunning];
    }
}

@end
