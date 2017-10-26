//
//  AlertViewY.m
//  KoMovie
//
//  Created by avatar on 14-12-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "AlertViewY.h"

@implementation AlertViewY

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSBundle *mjbundleFrame = [NSBundle bundleWithIdentifier:@"org.cocoapods.MJRefresh-KKZ"];
        
        self.vBg = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 55) * 0.5,0, 52, 52)];
        self.vBg.image = [UIImage imageNamed:@"MJRefresh.bundle/prl_pull_header_hint_progress"
                                    inBundle:mjbundleFrame
               compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        [self addSubview:self.vBg];
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 55) * 0.5,0, 52, 52)];
        v.image = [UIImage imageNamed:@"MJRefresh.bundle/prl_pull_header_hint_indeterminate"
                             inBundle:mjbundleFrame
        compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        [self addSubview:v];
        self.alertView = v;
        [self startAnimation];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(v.frame),screentWith - 15 * 2,20)];
        lbl.numberOfLines = 0;
        lbl.textColor = [UIColor grayColor];
        lbl.text = @"亲，正在查询，请稍候~";
        lbl.font = [UIFont boldSystemFontOfSize:14];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        [self addSubview:lbl];
        self.alertLabel = lbl;
    }
    return self;
}

// 开始动画
- (void)startAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    
    // 设置动画属性
    
    [animation setToValue:@(2 * M_PI)];
    
    
    
    [animation setDuration:0.8];
    
    
    
    animation.repeatCount = HUGE_VALF;
    
    
    
    animation.fillMode = kCAFillModeForwards;
    
    
    
    [self.alertView.layer addAnimation:animation forKey:@"rotationAnim"];
    
    
}

-(void)setAlertLabelText:(NSString *)alertLabelText{
    _alertLabelText = alertLabelText;
    
    self.alertLabel.text = self.alertLabelText;

}

-(void)setAlertViewImage:(NSString *)name{
    self.vBg.image = [UIImage imageNamed:name];
    self.alertLabel.textColor = [UIColor r:172 g:172 b:172];
}

-(void)layoutSubviews
{
//    CGSize s = [self.alertLabelText sizeWithFont:[UIFont systemFontOfSize:14]
//                          constrainedToSize:CGSizeMake(290, MAXFLOAT)
//                              lineBreakMode:NSLineBreakByTruncatingTail];
//    self.alertLabel.frame = CGRectMake(0, CGRectGetMaxY(self.alertView.frame), 290,s.height);
}

@end
