//
//  排期列表没有排期数据时显示提示信息的View
//
//  Created by 艾广华 on 16/4/14.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaPlanTableFooterView.h"
#import "UIColor+Hex.h"

/***************开始时间标签************/
static const CGFloat titleLabelTop = 66.0f;
static const CGFloat titleLabelHeight = 14.0f;
static const CGFloat titleLabelFont = 13.0f;

/***************场次按钮************/
static const CGFloat planButtonTop = 20.0f;
static const CGFloat planButtonWidth = 168.0f;
static const CGFloat planButtonHeight = 35.0f;
static const CGFloat planButtonFont = 13.0f;

@interface CinemaPlanTableFooterView ()

/**
 *  表底部视图
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  场次按钮
 */
@property (nonatomic, strong) UIButton *planButton;

@end

@implementation CinemaPlanTableFooterView

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
    [self addSubview:self.titleLabel];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    if (_buttonTitle) {
        [self.planButton setTitle:_buttonTitle
                         forState:UIControlStateNormal];
        [self addSubview:self.planButton];
    } else {
        [_planButton removeFromSuperview];
    }
}

- (void)didMoveToSuperview {
    CGRect frame = self.frame;
    if (_buttonTitle) {
        frame.size.height = CGRectGetMaxY(self.planButton.frame) + CGRectGetMinY(self.planButton.frame);
    } else {
        frame.size.height = CGRectGetMaxY(self.titleLabel.frame) + titleLabelTop;
    }
    self.frame = frame;
}

- (void)commonBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTomorrowEventButton)]) {
        [self.delegate onClickTomorrowEventButton];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabelTop, kCommonScreenWidth, titleLabelHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:titleLabelFont];
        _titleLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)planButton {
    if (!_planButton) {
        _planButton = [UIButton buttonWithType:0];
        _planButton.frame = CGRectMake((kCommonScreenWidth - planButtonWidth) * 0.5, CGRectGetMaxY(self.titleLabel.frame) + planButtonTop, planButtonWidth, planButtonHeight);
        _planButton.titleLabel.font = [UIFont systemFontOfSize:planButtonFont];
        [_planButton setTitleColor:[UIColor colorWithHex:@"#666666"]
                          forState:UIControlStateNormal];
        _planButton.layer.borderColor = [UIColor colorWithHex:@"#666666"].CGColor;
        _planButton.layer.borderWidth = 1.0f;
        _planButton.layer.masksToBounds = YES;
        _planButton.layer.cornerRadius = planButtonHeight * 0.5f;
        [_planButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _planButton;
}

@end
