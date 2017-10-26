//
//  EditProfileAgeChooseView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileBirthChooseView.h"
#import "KKZUtility.h"

typedef enum : NSUInteger {
    cancelButtonTag = 1000,
    completeButtonTag,
} allButtonTag;

@interface EditProfileBirthChooseView ()

/**
 *  选择按钮之后的回调
 */
@property (nonatomic, strong) CAll_BACK chooseCallBack;

/**
 *  透明的视图
 */
@property (nonatomic, strong) UIView *clearView;

/**
 *  选择器
 */
@property (nonatomic, strong) UIDatePicker *datePicker;

/**
 *  工具条
 */
@property (nonatomic, strong) UIView *toolBar;

/**
 *  工具条上分割线
 */
@property (nonatomic, strong) UIView *topDivider;

/**
 *  工具条下分割线
 */
@property (nonatomic, strong) UIView *bottomDivider;

/**
 *  工具条左边按钮
 */
@property (nonatomic, strong) UIButton *leftItem;

/**
 *  工具条右边按钮
 */
@property (nonatomic, strong) UIButton *rightItem;

/**
 *  工具条的标题
 */
@property (nonatomic, strong) UILabel *titleItem;

/**
 *  日期格式化
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation EditProfileBirthChooseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //添加透明视图
        [self addSubview:self.clearView];

        //日期选择器
        [self addSubview:self.datePicker];

        //添加工具条
        [self addSubview:self.toolBar];

        //添加工具条按钮
        [self.toolBar addSubview:self.leftItem];
        [self.toolBar addSubview:self.rightItem];
        [self.toolBar addSubview:self.titleItem];

        //添加工具条分割线
        [self.toolBar addSubview:self.topDivider];
        [self.toolBar addSubview:self.bottomDivider];

        //获取初始化
        //        self.dateString = [self.dateFormatter stringFromDate:self.datePicker.date];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.5f
            animations:^{
                if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    self.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                }
            }
            completion:^(BOOL finished) {
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            }];
}
- (void)close {
    [UIView animateWithDuration:0.5f
            animations:^{
                if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    self.frame = CGRectMake(0, kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
                }
            }
            completion:^(BOOL finished) {
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            }];
}

- (void)dataChanged:(id)sender {
    UIDatePicker *control = (UIDatePicker *) sender;
    self.datePicker.date = control.date;
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case cancelButtonTag: {
            [self close];
            break;
        }
        case completeButtonTag: {
            if (self.chooseCallBack) {
                self.chooseCallBack([self.dateFormatter stringFromDate:self.datePicker.date]);
            }
            [self close];
            break;
        }
        default:
            break;
    }
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _clearView.backgroundColor = [UIColor clearColor];
    }
    return _clearView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, kCommonScreenHeight - datePickerHeight, kCommonScreenWidth, datePickerHeight);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor clearColor];
        //日期格式符
        NSDate *minDate = [self.dateFormatter dateFromString:@"1900-01-01"];
        NSDate *maxDate = [self.dateFormatter dateFromString:@"2010-01-01"];
        [_datePicker setMinimumDate:minDate];
        [_datePicker setMaximumDate:maxDate];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self
                          action:@selector(dataChanged:)
                forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        //工具条
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight - datePickerHeight - toolBarHeight, kCommonScreenWidth, toolBarHeight)];
        _toolBar.backgroundColor = [UIColor colorWithHex:@"#f6f6f6"];
    }
    return _toolBar;
}

- (UIButton *)leftItem {
    if (!_leftItem) {
        _leftItem = [UIButton buttonWithType:0];
        _leftItem.frame = CGRectMake(0, 0, leftItemLeft * 2 + leftItemWidth, toolBarHeight);
        [_leftItem setTitleColor:[UIColor colorWithHex:@"#999999"]
                        forState:UIControlStateNormal];
        [_leftItem setTitle:@"取消"
                   forState:UIControlStateNormal];
        _leftItem.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_leftItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _leftItem.tag = cancelButtonTag;
        [_leftItem addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItem;
}

- (UIButton *)rightItem {
    if (!_rightItem) {
        _rightItem = [UIButton buttonWithType:0];
        CGFloat width = rightItemRight * 2 + leftItemWidth;
        _rightItem.frame = CGRectMake(kCommonScreenWidth - width, 0, width, toolBarHeight);
        [_rightItem setTitleColor:[UIColor colorWithHex:@"#ff5e00"]
                         forState:UIControlStateNormal];
        [_rightItem setTitle:@"完成"
                    forState:UIControlStateNormal];
        _rightItem.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _rightItem.tag = completeButtonTag;
        [_rightItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_rightItem addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

- (UILabel *)titleItem {
    if (!_titleItem) {
        _titleItem = [[UILabel alloc] initWithFrame:CGRectMake((kCommonScreenWidth - titleItemWidth) / 2.0f, 0, titleItemWidth, toolBarHeight)];
        _titleItem.font = [UIFont systemFontOfSize:17.0f];
        _titleItem.textColor = [UIColor blackColor];
        _titleItem.textAlignment = NSTextAlignmentCenter;
    }
    return _titleItem;
}

- (UIView *)topDivider {
    if (!_topDivider) {
        _topDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, dividerHeight)];
        _topDivider.backgroundColor = [UIColor colorWithHex:@"#d9d9d9"];
    }
    return _topDivider;
}

- (UIView *)bottomDivider {
    if (!_bottomDivider) {
        _bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(0, toolBarHeight - dividerHeight, kCommonScreenWidth, dividerHeight)];
        _bottomDivider.backgroundColor = [UIColor colorWithHex:@"#d9d9d9"];
    }
    return _bottomDivider;
}

- (void)setTitleItemString:(NSString *)titleItemString {
    _titleItemString = titleItemString;
    _titleItem.text = _titleItemString;
}

- (void)setMethodBlock:(CAll_BACK)block {
    self.chooseCallBack = block;
}

@end
