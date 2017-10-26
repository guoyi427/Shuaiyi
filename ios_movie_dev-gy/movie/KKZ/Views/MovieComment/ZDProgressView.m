//
//  ZDProgressView.m
//  PE
//
//  Created by 杨志达 on 14-6-20.
//  Copyright (c) 2014年 PE. All rights reserved.
//

#import "ZDProgressView.h"

@interface ZDProgressView()

/**
 *  进度条背景视图
 */
@property (nonatomic,strong) UIView *bgView;

/**
 *  进度条
 */
@property (nonatomic,strong) UIView *progressView;

@end

@implementation ZDProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zdInit];
        [self zdFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self zdFrame:frame];
}

- (void)zdFrame:(CGRect)frame
{
    self.bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.progressView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)zdInit
{
    //初始化视图
    self.bgView = [[UIView alloc] init];
    [self addSubview:self.bgView];
    
    self.progressView = [[UIView alloc] init];
    [self addSubview:self.progressView];
}

#pragma property set or get
- (void)setNoColor:(UIColor *)noColor
{
    self.bgView.backgroundColor = noColor;
}

- (void)setPrsColor:(UIColor *)prsColor
{
    self.layer.borderColor = prsColor.CGColor;
    self.progressView.backgroundColor = prsColor;
}

- (void)setProgress:(CGFloat)progress
{
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * progress, self.frame.size.height);
}

@end
