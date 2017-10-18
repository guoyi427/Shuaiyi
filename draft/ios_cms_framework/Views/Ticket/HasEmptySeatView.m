//
//  HasEmptySeatView.m
//  CIASMovie
//
//  Created by cias on 2017/3/1.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "HasEmptySeatView.h"

@implementation HasEmptySeatView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        self.layer.cornerRadius = 5;
        
        UIImageView *noSeatWarn = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 171-40, 140-60)];
        noSeatWarn.contentMode = UIViewContentModeScaleAspectFit;
        noSeatWarn.backgroundColor = [UIColor clearColor];
        noSeatWarn.image = [UIImage imageNamed:@"seatwarn"];
        [self addSubview:noSeatWarn];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = @"座位中间不要留空";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.width.equalTo(self);
            make.height.equalTo(@(15));
        }];

//        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        _overlayView.backgroundColor = [UIColor clearColor];
//        _overlayView.alpha = 0.8;
//        [_overlayView addTarget:self
//                         action:@selector(dismiss)
//               forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}




#pragma mark - animations
- (void)fadeIn
{
        self.transform = CGAffineTransformMakeTranslation(0.1, 0.1);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 0.7;
            self.transform = CGAffineTransformMakeTranslation(1, 1);
        }];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
}

- (void)fadeOut
{
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.1, 0.1);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}




@end
