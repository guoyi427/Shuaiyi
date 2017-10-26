//
//  首页开屏的广告
//
//  Created by KKZ on 16/4/12.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AdvertiseView.h"

#import "Banner.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "UrlOpenUtility.h"
#import "WebViewController.h"

/*****************广告的长宽比****************/
static const CGFloat viewScale = 1.35f;

/*****************广告位的左边距****************/
static const CGFloat imgVLeft = 40.0f;

/*****************关闭按钮的宽度****************/
static const CGFloat closeImgVWidth = 40.0f;

/*****************广告位和关闭按钮之间的距离****************/
static const CGFloat marginImgV = 30.0f;

@interface AdvertiseView ()

/**
 *  广告位
 */
@property (nonatomic, strong) UIImageView *advImgV;

@end

@implementation AdvertiseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        [viewBg setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.5]];
        [self addSubview:viewBg];

        CGFloat advImgVWidth = screentWith - imgVLeft * 2;
        CGFloat advImgVHeight = advImgVWidth * viewScale;
        CGFloat advImgVY = (screentHeight - advImgVHeight - closeImgVWidth - marginImgV) * 0.5;

        self.advImgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgVLeft, advImgVY, advImgVWidth, advImgVHeight)];
        [viewBg addSubview:self.advImgV];

        UIImageView *closeImgV = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 40) * 0.5, CGRectGetMaxY(self.advImgV.frame) + marginImgV, closeImgVWidth, closeImgVWidth)];
        [viewBg addSubview:closeImgV];
        closeImgV.image = [UIImage imageNamed:@"advClose"];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setBanner:(Banner *)banner {
    if (banner) {
        _banner = banner;
    }
}

- (void)setAdvertiseImage:(UIImage *)image {
    self.advImgV.image = image;
}

- (void)advImgVClicked {
    if (![UrlOpenUtility handleOpenAppUrl:[NSURL URLWithString:self.banner.targetUrl]]) {
        WebViewController *ctr = [[WebViewController alloc] initWithTitle:self.banner.title];
        [ctr loadURL:self.banner.targetUrl];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

#pragma mark touch view delegate
- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.advImgV.frame, point)) {
        [self advImgVClicked];
        [self removeFromSuperview];
        if (appDelegate.appdelegateAlert.visible) {
            NSInteger index = appDelegate.appdelegateAlert.cancelButtonIndex;
            [appDelegate.appdelegateAlert dismissWithClickedButtonIndex:index animated:NO];
            self.appdelegateAlertDismiss(YES);
        } else if (appDelegate.locationAlert.visible) {

            if (appDelegate.appdelegateAlert) {
                NSInteger index = appDelegate.appdelegateAlert.cancelButtonIndex;
                [appDelegate.appdelegateAlert dismissWithClickedButtonIndex:index animated:NO];
                self.appdelegateAlertDismiss(YES);
            }

            NSInteger index = appDelegate.locationAlert.cancelButtonIndex;
            [appDelegate.locationAlert dismissWithClickedButtonIndex:index animated:NO];
            self.appdelegateAlertDismiss(YES);
        }
    } else {
        [self removeFromSuperview];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 8.0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertView" object:nil userInfo:nil];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

@end
