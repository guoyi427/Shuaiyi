//
//  ImageReviewView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/21.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ImageReviewView.h"

@interface ImageReviewView ()<UIScrollViewDelegate>

/**
 *  显示的视图
 */
@property (nonatomic,strong) UIImageView *originalImageV;

@end

@implementation ImageReviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    CGFloat widthRate = originalImage.size.width/ self.frame.size.width;
    CGFloat height = originalImage.size.height / widthRate;
    self.originalImageV.frame = CGRectMake(0,(self.frame.size.height - height) / 2.0f, self.frame.size.width,height);
    self.originalImageV.image = originalImage;
    [self.contentScroll addSubview:self.originalImageV];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _originalImageV;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if(CGRectGetHeight(self.originalImageV.frame) > kCommonScreenHeight && CGRectGetWidth(self.originalImageV.frame) > kCommonScreenWidth) {
        self.originalImageV.frame = CGRectMake(0.0f,0.0f, self.originalImageV.frame.size.width,self.originalImageV.frame.size.height);
    }else if(CGRectGetHeight(self.originalImageV.frame) > kCommonScreenHeight) {
        self.originalImageV.frame=CGRectMake((kCommonScreenHeight - CGRectGetWidth(self.originalImageV.frame))/2.0f,0.0f,self.originalImageV.frame.size.width,self.originalImageV.frame.size.height);
    }else if (CGRectGetWidth(self.originalImageV.frame) > kCommonScreenWidth) {
        self.originalImageV.frame=CGRectMake(0.0f,(kCommonScreenHeight - CGRectGetHeight(self.originalImageV.frame))/2.0f,self.originalImageV.frame.size.width,self.originalImageV.frame.size.height);
    }else{
        self.originalImageV.frame=CGRectMake((kCommonScreenWidth - CGRectGetWidth(self.originalImageV.frame))/2.0f,(kCommonScreenHeight - CGRectGetHeight(self.originalImageV.frame))/2.0f,self.originalImageV.frame.size.width,self.originalImageV.frame.size.height);
    }
}

- (void)zoomRectForScale:(float)scale
              withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.contentScroll.frame.size.height / scale;
    zoomRect.size.width  =self.contentScroll.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    [self.contentScroll zoomToRect:zoomRect
                          animated:YES];
}

-(void)scrollViewBackToOriginState{
    CGRect zoomRect;
    zoomRect.size.height =self.contentScroll.frame.size.height;
    zoomRect.size.width  =self.contentScroll.frame.size.width;
    zoomRect.origin.x = 0.0f;
    zoomRect.origin.y = 0.0f;
    [self.contentScroll zoomToRect:zoomRect
                          animated:YES];
}

-(void)doubleView:(UIGestureRecognizer *)gesture {
    if(self.contentScroll.zoomScale > 1.0f){
        [self scrollViewBackToOriginState];
    }else{
        float newScale = self.contentScroll.zoomScale * 2.0;
        [self zoomRectForScale:newScale
                    withCenter:[gesture locationInView:gesture.view]];
    }
}

- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        _contentScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        _contentScroll.showsHorizontalScrollIndicator=YES;
        _contentScroll.showsVerticalScrollIndicator=YES;
        _contentScroll.delegate=self;
        _contentScroll.minimumZoomScale=1.0;
        _contentScroll.maximumZoomScale=2.0;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        [self addSubview:_contentScroll];
    }
    return _contentScroll;
}

- (UIImageView *)originalImageV {
    
    if (!_originalImageV) {
        _originalImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        //双击手势
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleView:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_originalImageV addGestureRecognizer:doubleTapGestureRecognizer];
    }
    return _originalImageV;
}

@end
