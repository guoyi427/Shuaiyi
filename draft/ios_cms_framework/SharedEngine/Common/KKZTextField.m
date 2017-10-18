//
//  KKZTextField.m
//  Cinephile
//
//  Created by wuzhen on 16/11/22.
//  Copyright © 2016年 Kokozu. All rights reserved.
//

#import "KKZTextField.h"

#import "KKZKeyboardTopView.h"

@interface KKZTextField () {

    UIColor *beganBorderColor;
    UIColor *beganBackgroundColor;
}

@property (nonatomic, strong) UIView *fieldRightView;

@property (nonatomic, strong) UIButton *secretButton;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, weak) id beginEditingObserver;

@property (nonatomic, weak) id endEditingObserver;

@end

static const CGFloat kButtonWidth = 40.f;

@implementation KKZTextField

#pragma mark - Lifecycle methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        _maxWordCount = -1;
        _fieldType = KKZTextFieldNormal;
        _showKeyboardTopView = NO;
        _rightViewHeight = self.frame.size.height;

        [self addTarget:self
                          action:@selector(textFieldChanged)
                forControlEvents:UIControlEventEditingChanged];

        __weak KKZTextField *weakSelf = self;

        // 获取焦点
        self.beginEditingObserver = [[NSNotificationCenter defaultCenter]
                addObserverForName:UITextFieldTextDidBeginEditingNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {

                            if (weakSelf == note.object) {
                                [weakSelf handleBeginEditing];
                            }
                        }];

        // 失去焦点
        self.endEditingObserver = [[NSNotificationCenter defaultCenter]
                addObserverForName:UITextFieldTextDidEndEditingNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {

                            if (weakSelf == note.object) {
                                [weakSelf handleEndEditing];
                            }
                        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}

#pragma mark Handle observers
- (void)handleBeginEditing {
    if (self.isSecureTextEntry) {
        [self settingButtonVisibility];
    }

    if (self.focusedBorderColor) {
        CGColorRef cgColorRef = self.layer.borderColor;
        beganBorderColor = [UIColor colorWithCGColor:cgColorRef];
        self.layer.borderColor = self.focusedBorderColor.CGColor;
    } else {
        beganBorderColor = nil;
    }

    if (self.focusedBackgroundColor) {
        beganBackgroundColor = self.backgroundColor;
        self.backgroundColor = self.focusedBackgroundColor;
    } else {
        beganBackgroundColor = nil;
    }
}

- (void)handleEndEditing {
    if (self.secretButton && self.fieldType == KKZTextFieldWithClearAndSecret) {
        if (self.secretButton) {
            self.secretButton.selected = NO;
            self.secureTextEntry = YES;
            self.secretButton.hidden = YES;
        }
        if (self.clearButton) {
            self.clearButton.hidden = YES;
        }
    }

    if (beganBorderColor) {
        self.layer.borderColor = beganBorderColor.CGColor;
    }
    if (beganBackgroundColor) {
        self.backgroundColor = beganBackgroundColor;
    }
}

#pragma mark - Override methods
- (void)deleteBackward {
    [super deleteBackward];

    if (self.kkzDelegate && [self.kkzDelegate respondsToSelector:@selector(kkzTextFieldDeleteBackward:)]) {
        [self.kkzDelegate kkzTextFieldDeleteBackward:self];
    }
}

#pragma mark - Init views
- (UIView *)fieldRightView {
    if (!_fieldRightView) {
        _fieldRightView = [[UIView alloc] init];
    }

    CGFloat width = 0;
    if (self.fieldType == KKZTextFieldWithClear) {
        width = kButtonWidth;
    } else if (self.fieldType == KKZTextFieldWithClearAndSecret) {
        width = kButtonWidth * 2;
    }
    _fieldRightView.frame = CGRectMake(0, 0, width, _rightViewHeight);
    return _fieldRightView;
}

- (UIButton *)secretButton {
    if (!_secretButton) {
        _secretButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, _rightViewHeight)];
        _secretButton.contentMode = UIViewContentModeScaleAspectFit;
        [_secretButton addTarget:self
                          action:@selector(changeSecretEnable)
                forControlEvents:UIControlEventTouchUpInside];

        if (self.secretVisibleImage) {
            [_secretButton setImage:self.secretVisibleImage forState:UIControlStateNormal];
        } else {
            [_secretButton setImage:[UIImage imageNamed:@"secureSel"] forState:UIControlStateNormal];
        }
        if (self.secretInvisibleImage) {
            [_secretButton setImage:self.secretInvisibleImage forState:UIControlStateSelected];
        } else {
            [_secretButton setImage:[UIImage imageNamed:@"secure"] forState:UIControlStateSelected];
        }
    }
    return _secretButton;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        _clearButton.contentMode = UIViewContentModeScaleAspectFit;
        [_clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];

        if (self.clearImage) {
            [_clearButton setImage:self.clearImage forState:UIControlStateNormal];
        } else {
            [_clearButton setImage:[UIImage imageNamed:@"clearBtnYN"] forState:UIControlStateNormal];
        }
    }

    CGFloat left = (self.fieldType == KKZTextFieldWithClearAndSecret ? kButtonWidth : 0);
    _clearButton.frame = CGRectMake(left, 0, kButtonWidth, _rightViewHeight);
    return _clearButton;
}

#pragma mark - Public methods
- (void)setRightViewHeight:(NSInteger)rightViewHeight {
    _rightViewHeight = rightViewHeight;
    _fieldRightView.frame = CGRectMake(0, 0, _fieldRightView.frame.size.width, rightViewHeight);

    if (_secretButton) {
        _secretButton.frame = CGRectMake(0, 0, kButtonWidth, rightViewHeight);
    }

    if (_clearButton) {
        CGFloat left = (self.fieldType == KKZTextFieldWithClearAndSecret ? kButtonWidth : 0);
        _clearButton.frame = CGRectMake(left, 0, kButtonWidth, _rightViewHeight);
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];

    [self textFieldChanged];
}

- (void)setFieldType:(KKZTextFieldType)type {
    _fieldType = type;
    if (type == KKZTextFieldWithClear) {
        [self.fieldRightView addSubview:self.clearButton];

        self.rightView = self.fieldRightView;
    } else if (type == KKZTextFieldWithClearAndSecret) {
        [self.fieldRightView addSubview:self.secretButton];
        [self.fieldRightView addSubview:self.clearButton];

        self.rightView = self.fieldRightView;
    } else {
        self.rightView = nil;
    }

    self.rightViewMode = UITextFieldViewModeWhileEditing;

    [self settingButtonVisibility];
}

- (void)setClearImage:(UIImage *)clearImage {
    _clearImage = clearImage;

    if (_clearButton) {
        [_clearButton setImage:clearImage forState:UIControlStateNormal];
    }
}

- (void)setSecretVisibleImage:(UIImage *)secretVisibleImage {
    _secretVisibleImage = secretVisibleImage;

    if (_secretButton) {
        [_secretButton setImage:secretVisibleImage forState:UIControlStateNormal];
    }
}

- (void)setSecretInvisibleImage:(UIImage *)secretInvisibleImage {
    _secretInvisibleImage = secretInvisibleImage;

    if (_secretButton) {
        [_secretButton setImage:secretInvisibleImage forState:UIControlStateSelected];
    }
}

- (void)setShowKeyboardTopView:(BOOL)showKeyboardTopView {
    _showKeyboardTopView = showKeyboardTopView;

    if (showKeyboardTopView) {
        CGRect topFrame = CGRectMake(0, 0, self.frame.size.width, 38);
        KKZKeyboardTopView *topView = [[KKZKeyboardTopView alloc] initWithFrame:topFrame];
        [self setInputAccessoryView:topView];
    } else {
        [self setInputAccessoryView:nil];
    }
}

#pragma mark - Self methods
- (void)settingButtonVisibility {
    if (_clearButton) {
        _clearButton.hidden = (self.text.length == 0);
    }
    if (_secretButton) {
        _secretButton.hidden = (self.text.length == 0);
    }
}

- (void)textFieldChanged {
    [self settingButtonVisibility];

    if (self.maxWordCount > 0) {
        NSString *toBeString = self.text;
        NSString *language = [self.textInputMode primaryLanguage]; //判断语言

        if ([language isEqualToString:@"zh-Hans"]) { //是中文
            UITextRange *range = [self markedTextRange];
            //获取高亮的位置
            UITextPosition *position = [self positionFromPosition:range.start offset:0];
            if (!position) { //没有高亮选择的字体，则对一输入的文字进行统计和限制
                if (toBeString.length > self.maxWordCount) {
                    self.text = [self.text substringToIndex:self.maxWordCount];
                }
            }
        } else if (toBeString.length > self.maxWordCount) { //非中文
            self.text = [self.text substringToIndex:self.maxWordCount];
        }
    }
}

- (void)changeSecretEnable {
    if (_secretButton) {
        _secretButton.selected = !_secretButton.selected;

        self.secureTextEntry = !_secretButton.selected;
        BOOL isFirstResponder = self.isFirstResponder;
        if (isFirstResponder) {
            [self becomeFirstResponder];
        }
        self.text = self.text; //Fixed:字体不一致
    }
}

- (void)clearText {
    self.text = @"";
    self.clearButton.hidden = YES;
    self.secretButton.hidden = YES;

    if (self.fieldType == KKZTextFieldWithClearAndSecret) {
        self.secretButton.selected = NO;
        self.secureTextEntry = YES;
    }

    if (self.kkzDelegate && [self.kkzDelegate respondsToSelector:@selector(kkzTextFieldClear:)]) {
        [self.kkzDelegate kkzTextFieldClear:self];
    }
}

@end
