//
//  影院详情显示特色信息的详细信息蒙层
//
//  Created by gree2 on 14/12/17.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaSpecialInfoView.h"

#import <QuartzCore/QuartzCore.h>

#import "KKZTextUtility.h"

@implementation CinemaSpecialInfoView

- (id)initWithFrame:(CGRect)frame withInfo:(NSString *)cinemaInfo {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = TRUE;
        self.backgroundColor = [UIColor whiteColor];
        self.cinemaInfo = cinemaInfo;

        CGSize infoSize = [KKZTextUtility
                measureText:self.cinemaInfo
                       size:CGSizeMake(frame.size.width - 20 * 2, MAXFLOAT)
                       font:[UIFont systemFontOfSize:18]];
        CGFloat top = (frame.size.height - infoSize.height) / 2;

        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, top, screentWith - 20 * 2, infoSize.height)];
        infoLabel.text = self.cinemaInfo;
        infoLabel.numberOfLines = 0;
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:18];
        infoLabel.textColor = appDelegate.kkzTextColor;
        [self addSubview:infoLabel];

        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self
                          action:@selector(dismiss)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    [keyWindow addSubview:_overlayView];

    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.alpha = 0;
    [UIView animateWithDuration:.35
                     animations:^{
                         self.alpha = 1;
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:.35
            animations:^{
                self.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.alpha = 0.0;
            }
            completion:^(BOOL finished) {
                if (finished) {
                    [_overlayView removeFromSuperview];
                    [self removeFromSuperview];
                }
            }];
}

@end
