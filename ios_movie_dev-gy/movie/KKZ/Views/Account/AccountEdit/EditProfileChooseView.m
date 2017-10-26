//
//  EditProfileChooseView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileChooseView.h"

typedef enum : NSUInteger {
    cancelButtonTag = 2000,
    completeButtonTag,
} allButtonTag;

@interface EditProfileChooseView () <UIPickerViewDataSource, UIPickerViewDelegate>

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
@property (nonatomic, strong) UIPickerView *picker;

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

@end

@implementation EditProfileChooseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //添加透明视图
        [self addSubview:self.clearView];

        //日期选择器
        [self addSubview:self.picker];

        //添加工具条
        [self addSubview:self.toolBar];

        //添加工具条按钮
        [self.toolBar addSubview:self.leftItem];
        [self.toolBar addSubview:self.rightItem];
        [self.toolBar addSubview:self.titleItem];

        //添加工具条分割线
        [self.toolBar addSubview:self.topDivider];
        [self.toolBar addSubview:self.bottomDivider];

        UIWindow *widow = [[UIApplication sharedApplication].delegate window];
        [widow addSubview:self];
    }
    return self;
}

- (void)show {

    //更新需要显示的数据
    if ([self.dataArr containsObject:self.dataString]) {
        NSInteger row = [self.dataArr indexOfObject:self.dataString];
        [self.picker selectRow:row
                   inComponent:0
                      animated:NO];
    } else {
        [self.picker selectRow:0
                   inComponent:0
                      animated:NO];
        self.dataString = self.dataArr[0];
    }

    //显示动画
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.dataArr[row];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0f;
}
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if (self.dataArr.count > row) {
        self.dataString = self.dataArr[row];
    }
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case cancelButtonTag: {
            [self close];
            break;
        }
        case completeButtonTag: {
            if (self.chooseCallBack) {
                self.chooseCallBack(self.dataString);
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

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.frame = CGRectMake(0, kCommonScreenHeight - commonPickerHeight, kCommonScreenWidth, commonPickerHeight);
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.delegate = self;
        _picker.dataSource = self;
    }
    return _picker;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        //工具条
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight - commonPickerHeight - toolBarHeight, kCommonScreenWidth, toolBarHeight)];
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

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self.picker reloadAllComponents];
}

- (void)setCommonTitleItemString:(NSString *)commonTitleItemString {
    _commonTitleItemString = commonTitleItemString;
    _titleItem.text = _commonTitleItemString;
}

- (void)setDataString:(NSString *)dataString {
    _dataString = dataString;
}

- (void)setMethodBlock:(CAll_BACK)block {
    self.chooseCallBack = block;
}

@end
