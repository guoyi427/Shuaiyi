//
//  排期列表顶部影院基本信息的View
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaTitleHeader.h"

#import "KKZUtility.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"

/****************影院标题*************/
static const CGFloat cinemaLabelLeft = 15.0f;
static const CGFloat cinemaLabelTop = 15.0f;
static const CGFloat cinemaLabelHeight = 15.0f;
static const CGFloat cinemaLabelFont = 15.0f;

/****************影院地址*************/
static const CGFloat addressLabelTop = 12.0f;
static const CGFloat addressLabelFont = 12.0f;
static const CGFloat addressLabelHeight = 11.0f;

/****************影院标签*************/
static const CGFloat labelHeight = 15.0f;
static const CGFloat labelFont = 10.0f;
static const CGFloat labelTop = 8.0f;
static const CGFloat labelRight = 3.0f;

/****************分割线*************/
static const CGFloat lineViewTop = 15.0f;
static const CGFloat lineViewHeight = 0.3f;

@interface CinemaTitleHeader ()

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  地址标签
 */
@property (nonatomic, strong) UILabel *addressLabel;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  标签视图数组
 */
@property (nonatomic, strong) NSMutableArray *labelsViewArray;

@end

@implementation CinemaTitleHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(tapView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
    //  icon
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanList_CinemaAddress_icon"]];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cinemaLabelLeft);
        make.centerY.equalTo(self.addressLabel);
    }];
    
    //  map
    UIImageView *map = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanList_CinemaAddress_map"]];
    [self addSubview:map];
    [map mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-cinemaLabelLeft);
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self addSubview:self.lineView];
}

- (void)tapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCinemaTitleHeaderView)]) {
        [self.delegate didSelectCinemaTitleHeaderView];
    }
}

- (void)setLabelArray:(NSArray *)labelArray {
    _labelArray = labelArray;
    if (_labelArray.count == 0) {
        return;
    }
    [self removeAllLabelsView];
    [self.labelsViewArray removeAllObjects];
    [self initWithLabelsView];
}

- (void)setCinemaAddress:(NSString *)cinemaAddress {
    _cinemaAddress = cinemaAddress;
    self.addressLabel.text = cinemaAddress;
    [self initWithViewFrame:CGRectGetMaxY(self.addressLabel.frame)];
}

- (void)setCinemaName:(NSString *)cinemaName {
    _cinemaName = cinemaName;
    self.titleLabel.text = cinemaName;
}

- (void)initWithViewFrame:(CGFloat)height {

    //设置视图的尺寸
    CGFloat minHeight = cinemaLabelTop + cinemaLabelHeight + addressLabelTop + addressLabelHeight + lineViewTop;
    CGRect frame = self.frame;
    if (self.labelArray.count > 0) {
        frame.size.height = minHeight + labelTop + labelHeight;
    } else {
        frame.size.height = minHeight;
    }
    self.frame = frame;

    //设置视图分割线的尺寸
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.y = frame.size.height - lineFrame.size.height;
    self.lineView.frame = lineFrame;

    //通知代理对象
    if ([self.delegate respondsToSelector:@selector(cinemaTitleHeaderChangeHeight:)]) {
        [self.delegate cinemaTitleHeaderChangeHeight:CGRectGetMaxY(self.frame)];
    }
}

- (void)removeAllLabelsView {
    for (int i = 0; i < _labelsViewArray.count; i++) {
        UILabel *label = _labelsViewArray[i];
        [label removeFromSuperview];
    }
}

- (void)initWithLabelsView {
    CGFloat left = cinemaLabelLeft;
    for (int i = 0; i < _labelArray.count; i++) {
        CGSize size = [KKZUtility customTextSize:[UIFont systemFontOfSize:labelFont]
                                            text:_labelArray[i]
                                            size:CGSizeMake(kCommonScreenWidth, CGFLOAT_MAX)];
        CGFloat labelWidth = size.width + 6;
        if (left + labelWidth > kCommonScreenWidth) {
            break;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, CGRectGetMaxY(self.addressLabel.frame) + labelTop, labelWidth, labelHeight)];
        label.font = [UIFont systemFontOfSize:labelFont];
        label.text = _labelArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:@"#6b8499"];
        label.layer.borderWidth = 0.5f;
        label.layer.borderColor = label.textColor.CGColor;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 2.0f;
        [self addSubview:label];
        left += label.frame.size.width + labelRight;
        [self.labelsViewArray addObject:label];
    }
    [self initWithViewFrame:CGRectGetMaxY(self.addressLabel.frame) + labelTop + labelHeight];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat titleWidth = kCommonScreenWidth - cinemaLabelLeft * 2;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cinemaLabelLeft, cinemaLabelTop, titleWidth, cinemaLabelHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:cinemaLabelFont];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat titleWidth = kCommonScreenWidth - cinemaLabelLeft * 2;
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(cinemaLabelLeft + 12, CGRectGetMaxY(self.titleLabel.frame) + addressLabelTop, titleWidth, addressLabelHeight)];
        _addressLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _addressLabel.font = [UIFont systemFontOfSize:addressLabelFont];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.backgroundColor = [UIColor clearColor];
    }
    return _addressLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(cinemaLabelLeft, 0, kCommonScreenWidth - cinemaLabelLeft, lineViewHeight)];
        _lineView.backgroundColor = kDividerColor;
    }
    return _lineView;
}

- (NSMutableArray *)labelsViewArray {
    if (!_labelsViewArray) {
        _labelsViewArray = [[NSMutableArray alloc] init];
    }
    return _labelsViewArray;
}

@end
