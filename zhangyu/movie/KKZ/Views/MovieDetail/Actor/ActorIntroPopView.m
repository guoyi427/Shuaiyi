//
//  显示演员简介信息的PopView
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActorIntroPopView.h"

#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <QuartzCore/QuartzCore.h>

#import "UIColor+Hex.h"

@interface ActorIntroPopView ()

@property (nonatomic, strong) UITextView *titleView;

@property (nonatomic, strong) UIControl *overlayView;

@end

@implementation ActorIntroPopView

#pragma mark - Init methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = TRUE;

        UIView *showBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        showBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:showBg];

        UIImageView *closeView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 25 - 8, 8, 25, 25)];
        closeView.image = [UIImage imageNamed:@"mCancel"];
        [self addSubview:closeView];

        self.titleView = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, frame.size.width - 20 * 2, frame.size.height - 50)];
        self.titleView.backgroundColor = [UIColor clearColor];
        self.titleView.textColor = HEX(@"#323232");
        self.titleView.font = [UIFont systemFontOfSize:15];
        self.titleView.editable = NO;
        self.titleView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];

        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.5;
        [self.overlayView addTarget:self
                             action:@selector(dismiss)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Public methods
- (void)setContent:(NSString *)content {
    self.titleView.text = content;
}

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];

    [self fadeIn];
}

- (void)dismiss {
    [self fadeOut];
}

#pragma mark - Handle GestureRecognizer
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(_titleView.frame, point)) {
        return;
    }
    [self dismiss];
}

#pragma mark - Animations
- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.alpha = 0;

    [UIView animateWithDuration:0.3
                     animations:^{

                         self.alpha = 1;
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

- (void)fadeOut {
    [UIView animateWithDuration:.4
            animations:^{

                self.transform = CGAffineTransformMakeScale(0.3, 0.3);
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
