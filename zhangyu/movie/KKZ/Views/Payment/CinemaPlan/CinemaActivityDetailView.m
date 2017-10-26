//
//  排期列表顶部优惠活动的列表View
//
//  Created by 艾广华 on 16/4/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaActivityDetailView.h"

#import "Promotion.h"
#import "KKZUtility.h"
#import "UIConstants.h"

/***************活动图片************/
static const CGFloat activityImgViewLeft = 15.0f;

/***************活动视图************/
static const CGFloat shortVieweOriginalTop = 370.0f;
static const CGFloat shortViewOriginalHeight = 65.0f;

/***************影院标题文字************/
static const CGFloat shortTitleLeft = 5.0f;
static const CGFloat shortTitleHeight = 20.0f;
static const CGFloat shortTitleFont = 11.0f;

/***************活动标题文字************/
static const CGFloat promotionLeft = 8.0f;
static const CGFloat promotionHeight = 20.0f;
static const CGFloat promotionFont = 15.0f;

/***************活动详情文字************/
static const CGFloat textViewLeft = 15.0f;
static const CGFloat textViewTop = 10.0f;
static const CGFloat textViewBottom = 10.0f;
static const CGFloat textViewFont = 15.0f;

@interface CinemaActivityDetailView ()

/**
 *  活动详情图片
 */
@property (nonatomic, strong) UIImageView *activityImgView;

/**
 *  活动文字视图
 */
@property (nonatomic, strong) UIView *shortTitleView;

/**
 *  活动短标题
 */
@property (nonatomic, strong) UILabel *shortTitleLabel;

/**
 *  活动的介绍
 */
@property (nonatomic, strong) UILabel *promotionTitleLabel;

/**
 *  文本输入框
 */
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CinemaActivityDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.activityImgView];
        [self.activityImgView addSubview:self.shortTitleView];
        [self.shortTitleView addSubview:self.shortTitleLabel];
        [self.shortTitleView addSubview:self.promotionTitleLabel];
        [self.activityImgView addSubview:self.textView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self updateSubViews];
}

- (void)updateSubViews {
    //计算影院短标题的尺寸
    if (![KKZUtility stringIsEmpty:self.shortTitleLabel.text]) {
        CGFloat shortMaxWidth = CGRectGetWidth(self.activityImgView.frame) * 0.5;
        CGSize shortSize = [KKZUtility customTextSize:self.shortTitleLabel.font
                                                 text:self.shortTitleLabel.text
                                                 size:CGSizeMake(shortMaxWidth, CGRectGetHeight(self.shortTitleLabel.frame))];
        CGRect shortFrame = self.shortTitleLabel.frame;
        shortFrame.size.width = shortSize.width + 15;
        self.shortTitleLabel.frame = shortFrame;
    } else {
        CGRect shortFrame = self.shortTitleLabel.frame;
        shortFrame.size.width = 0;
        self.shortTitleLabel.frame = shortFrame;
    }

    //计算活动标题的尺寸
    CGFloat promotioMaxWidth = CGRectGetWidth(self.activityImgView.frame) - CGRectGetWidth(self.shortTitleLabel.frame);
    CGSize promotionSize = [KKZUtility customTextSize:self.promotionTitleLabel.font
                                                 text:self.promotionTitleLabel.text
                                                 size:CGSizeMake(promotioMaxWidth, CGRectGetHeight(self.shortTitleLabel.frame))];
    CGRect promotionFrame = self.promotionTitleLabel.frame;
    promotionFrame.origin.x = CGRectGetMaxX(self.shortTitleLabel.frame) + promotionLeft;
    promotionFrame.size.width = promotionSize.width + 15;
    self.promotionTitleLabel.frame = promotionFrame;
}

- (void)tapGesture {
    [self removeFromSuperview];
}

#pragma mark - setter Method
- (void)setModel:(Promotion *)model {
    self.shortTitleLabel.text = model.shortTitle;
    self.promotionTitleLabel.text = model.promotionTitle;
    self.textView.text = model.remarks;
}

#pragma mark - getter Method
- (UIView *)shortTitleView {
    if (!_shortTitleView) {
        UIImage *image = self.activityImgView.image;
        CGFloat imageWidth = CGRectGetWidth(self.activityImgView.frame);
        CGFloat imageHeight = CGRectGetHeight(self.activityImgView.frame);
        CGFloat heightFactor = imageHeight / image.size.height;
        _shortTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, shortVieweOriginalTop * heightFactor, imageWidth, shortViewOriginalHeight * heightFactor)];
        _shortTitleView.backgroundColor = [UIColor clearColor];
    }
    return _shortTitleView;
}

- (UILabel *)shortTitleLabel {
    if (!_shortTitleLabel) {
        CGFloat width = (CGRectGetHeight(self.shortTitleView.frame) - shortTitleHeight) * 0.5;
        _shortTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(shortTitleLeft, width, 0, shortTitleHeight)];
        _shortTitleLabel.font = [UIFont systemFontOfSize:shortTitleFont];
        _shortTitleLabel.backgroundColor = [UIColor clearColor];
        _shortTitleLabel.textColor = kOrangeColor;
        _shortTitleLabel.layer.borderColor = kOrangeColor.CGColor;
        _shortTitleLabel.layer.borderWidth = 1.0f;
        _shortTitleLabel.layer.masksToBounds = YES;
        _shortTitleLabel.layer.cornerRadius = 2.0f;
        _shortTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shortTitleLabel;
}

- (UILabel *)promotionTitleLabel {
    if (!_promotionTitleLabel) {
        CGFloat y = (CGRectGetHeight(self.shortTitleView.frame) - promotionHeight) * 0.5f;
        _promotionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 0, promotionHeight)];
        _promotionTitleLabel.font = [UIFont systemFontOfSize:promotionFont];
        _promotionTitleLabel.textColor = [UIColor blackColor];
        _promotionTitleLabel.backgroundColor = [UIColor clearColor];
    }
    return _promotionTitleLabel;
}

- (UIImageView *)activityImgView {
    if (!_activityImgView) {
        UIImage *image = [UIImage imageNamed:@"kkzActivityBg"];
        CGFloat imageWidth = CGRectGetWidth(self.frame) - activityImgViewLeft * 2;
        CGFloat imageHeight = imageWidth * image.size.height / image.size.width;
        _activityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(activityImgViewLeft, (CGRectGetHeight(self.frame) - imageHeight) * 0.5f, imageWidth, imageHeight)];
        _activityImgView.image = image;
    }
    return _activityImgView;
}

- (UITextView *)textView {
    if (!_textView) {
        CGFloat y = CGRectGetMaxY(self.shortTitleView.frame) + textViewTop;
        CGFloat height = CGRectGetHeight(self.activityImgView.frame) - y - textViewBottom;
        CGFloat x = textViewLeft;
        CGFloat width = CGRectGetWidth(self.activityImgView.frame) - x * 2;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _textView.font = [UIFont systemFontOfSize:textViewFont];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

@end
