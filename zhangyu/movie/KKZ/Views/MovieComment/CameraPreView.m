//
//  CameraPreView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CameraPreView.h"
#import "KKZUtility.h"
#import "CameraEditorViewController.h"

@interface CameraPreView ()<UIScrollViewDelegate>

/**
 *  图片编辑控制器
 */
@property (nonatomic, weak) CameraEditorViewController *controller;

@end

@implementation CameraPreView


- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = (CameraEditorViewController *)controller;
        [self addSubview:self.contentScroll];
        [self.contentScroll addSubview:self.originalImgV];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _originalImgV;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {

    //获取图片的尺寸
    CGRect imageFrame = _originalImgV.frame;
    CGRect cropFrame = [self.controller getCropRect];
    [_contentScroll setContentSize:CGSizeMake(CGRectGetWidth(imageFrame),kCommonScreenHeight + CGRectGetHeight(imageFrame) - CGRectGetHeight(cropFrame))];
}

- (void)setOriginalImg:(UIImage *)originalImg {
    _originalImg = originalImg;
    CGRect imageFrame = [self.controller getCropImageRect];
    CGRect cropFrame = [self.controller getCropRect];
    
    //修改当前滚动条的垂直方向的滚动距离
    CGFloat topDiff = 0.0f;
    if (CGRectGetMinY(imageFrame) < CGRectGetMinY(cropFrame)) {
        topDiff = CGRectGetMinY(cropFrame) - CGRectGetMinY(imageFrame);
        CGRect frame = imageFrame;
        frame.origin.y = frame.origin.y + topDiff;
        imageFrame = frame;
    }
    
    //修改当前滚动条的水平方向的滚动距离
    CGFloat leftDiff = 0.0f;
    if (CGRectGetMinX(imageFrame) < CGRectGetMinX(cropFrame)) {
        leftDiff = CGRectGetMinX(cropFrame) - CGRectGetMinX(imageFrame);
        CGRect frame = imageFrame;
        frame.origin.x = leftDiff + frame.origin.x;
        imageFrame = frame;
    }
        
    _originalImgV.frame = imageFrame;
    _originalImgV.image = _originalImg;
    [_contentScroll setContentSize:CGSizeMake(CGRectGetWidth(imageFrame), kCommonScreenHeight + CGRectGetHeight(imageFrame) - CGRectGetHeight(cropFrame))];
    [_contentScroll setContentOffset:CGPointMake(leftDiff,topDiff)];

}

- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        _contentScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,kCommonScreenWidth,kCommonScreenHeight)];
        _contentScroll.showsHorizontalScrollIndicator=YES;
        _contentScroll.showsVerticalScrollIndicator=YES;
        _contentScroll.backgroundColor=[UIColor blackColor];
        _contentScroll.delegate=self;
        _contentScroll.minimumZoomScale=1.0;
        _contentScroll.maximumZoomScale=2.0;
        _contentScroll.alwaysBounceHorizontal = YES;
        _contentScroll.alwaysBounceVertical = YES;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
    }
    return _contentScroll;
}

- (UIImageView *)originalImgV {
    
    if (!_originalImgV) {
        _originalImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _originalImgV.backgroundColor = [UIColor redColor];
    }
    return _originalImgV;
}

@end
