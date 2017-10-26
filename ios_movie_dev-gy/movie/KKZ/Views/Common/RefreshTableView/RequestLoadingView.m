//
//  RequestLoadingView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "RequestLoadingView.h"

static const CGFloat centerLblHeight = 20.0f;

@interface RequestLoadingView () {
    //外围视图
    UIImageView *centerImgV;

    //中间视图
    UIImageView *roundImgV;

    //中心视图文字
    UILabel *centerLbl;
}

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RequestLoadingView

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        NSBundle *mjbundleFrame = [NSBundle bundleWithIdentifier:@"org.cocoapods.MJRefresh-KKZ"];
        //中心图片视图
        UIImage *centerImg = [UIImage imageNamed:@"MJRefresh.bundle/prl_pull_header_hint_progress"
                                        inBundle:mjbundleFrame
                   compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        centerImgV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - centerImg.size.width) / 2.0f, (frame.size.height - centerImg.size.height) / 2.0f - centerLblHeight, centerImg.size.width, centerImg.size.height)];
        centerImgV.image = centerImg;
        [self addSubview:centerImgV];

        //中心图片外边的圆圈
        roundImgV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - centerImg.size.width) / 2.0f, (frame.size.height - centerImg.size.height) / 2.0f - centerLblHeight, centerImg.size.width, centerImg.size.height)];
        roundImgV.image =  [UIImage imageNamed:@"MJRefresh.bundle/prl_pull_header_hint_indeterminate"
                                      inBundle:mjbundleFrame
                 compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        [self addSubview:roundImgV];

        //圆圈下面的文字
        CGFloat lblOriginX = 15.0f;
        centerLbl = [[UILabel alloc] initWithFrame:CGRectMake(lblOriginX, CGRectGetMaxY(centerImgV.frame), frame.size.width - lblOriginX * 2, centerLblHeight)];
        centerLbl.numberOfLines = 0;
        centerLbl.textColor = [UIColor grayColor];
        centerLbl.text = title;
        centerLbl.font = [UIFont boldSystemFontOfSize:14];
        centerLbl.textAlignment = NSTextAlignmentCenter;
        centerLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:centerLbl];
    }
    return self;
}

- (void)layoutSubviews {
    centerImgV.frame = CGRectMake((self.frame.size.width - centerImgV.frame.size.width) / 2.0f, (self.frame.size.height - centerImgV.frame.size.height) / 2.0f - centerLblHeight, centerImgV.frame.size.width, centerImgV.frame.size.height);
    roundImgV.frame = centerImgV.frame;
    centerLbl.frame = CGRectMake(CGRectGetMinX(centerLbl.frame), CGRectGetMaxY(centerImgV.frame), self.frame.size.width - CGRectGetMinX(centerLbl.frame) * 2, CGRectGetHeight(centerLbl.frame));
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设置动画属性
    [animation setToValue:@(2 * M_PI)];
    [animation setDuration:0.8];
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [roundImgV.layer addAnimation:animation forKey:@"rotationAnim"];
}

- (void)stopAnimation {
    [roundImgV.layer removeAllAnimations];
}

- (void)setCenterLblColor:(UIColor *)centerLblColor {
    centerLbl.textColor = centerLblColor;
}

@end
