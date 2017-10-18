//
//  软键盘上带有完成ToolBar的UITextField
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZTextField.h"

#import "KKZKeyboardTopView.h"

@interface KKZTextField () {
    
    UIColor *beganBorderColor;
    UIColor *beganBackgroundColor;
}

@property (nonatomic, strong) KKZKeyboardTopView *keyboardTopView;

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
    return [self initWithFrame:frame andFieldType:KKZTextFieldNormal];
}

- (id)initWithFrame:(CGRect)frame andFieldType:(KKZTextFieldType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWordCount = -1;
        self.fieldType = type;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self setInputAccessoryView:self.keyboardTopView];

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
    }
    else {
        beganBorderColor = nil;
    }
    
    if (self.focusedBackgroundColor) {
        beganBackgroundColor = self.backgroundColor;
        self.backgroundColor = self.focusedBackgroundColor;
    }
    else {
        beganBackgroundColor = nil;
    }
}

- (void)handleEndEditing {
    if (self.secretButton && self.fieldType == KKZTextFieldWithClearAndSecret) {
        if (self.secretButton) {
//            if (runningOniOS7) {
//                self.secretButton.selected = NO;
//                self.secureTextEntry = YES;
//            }
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
- (KKZKeyboardTopView *)keyboardTopView {
    if (!_keyboardTopView) {
        CGRect topFrame = CGRectMake(0, 0, self.frame.size.width, 38);
        
        _keyboardTopView = [[KKZKeyboardTopView alloc] initWithFrame:topFrame];
    }
    return _keyboardTopView;
}

- (UIView *)fieldRightView {
    if (!_fieldRightView) {
        _fieldRightView = [[UIView alloc] init];
    }

    CGFloat left = 0;
    CGFloat width = 0;
    if (self.fieldType == KKZTextFieldWithClear) {
        width = kButtonWidth;
        left = self.frame.size.width - width;
    } else if (self.fieldType == KKZTextFieldWithClearAndSecret) {
        width = kButtonWidth * 2;
        left = self.frame.size.width - width;
    }
    _fieldRightView.frame = CGRectMake(left, 0, width, self.frame.size.height);
    return _fieldRightView;
}

- (UIButton *)secretButton {
    if (!_secretButton) {
        _secretButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, self.frame.size.height)];
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

    CGFloat left = 0;
    if (self.fieldType == KKZTextFieldWithClear) {
        left = 0;
    } else if (self.fieldType == KKZTextFieldWithClearAndSecret) {
        left = kButtonWidth;
    }
    _clearButton.frame = CGRectMake(left, 0, kButtonWidth, self.frame.size.height);
    return _clearButton;
}

#pragma mark - Public methods
- (void)setKeyboardDelegate:(id<KKZKeyboardTopViewDelegate>)keyboardDelegate {
    self.keyboardTopView.keyboardDelegate = keyboardDelegate;
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

//    if (runningOniOS7) {
//        self.rightViewMode = UITextFieldViewModeWhileEditing;
//    } else {
        self.rightViewMode = UITextFieldViewModeAlways;
//    }

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
        NSString *language = [self.textInputMode primaryLanguage]; // 判断语言
        if ([language isEqualToString:@"zh-Hans"]) { // 是中文
            UITextRange *range = [self markedTextRange];
            // 获取高亮的位置
            UITextPosition *position = [self positionFromPosition:range.start offset:0];
            if (!position) { // 没有高亮选择的字体，则对一输入的文字进行统计和限制
                if (toBeString.length > self.maxWordCount) {
                    self.text = [self.text substringToIndex:self.maxWordCount];
                }
            }
        } else if (toBeString.length > self.maxWordCount) { // 非中文
            self.text = [self.text substringToIndex:self.maxWordCount];
        }
    }
}

- (void)changeSecretEnable {
    if (_secretButton) {
        _secretButton.selected = !_secretButton.selected;

//        if (runningOniOS7) {
//            self.secureTextEntry = !_secretButton.selected;
//            BOOL isFirstResponder = self.isFirstResponder;
//            if (isFirstResponder) {
//                [self becomeFirstResponder];
//            }
//        } else {
            BOOL isFirstResponder = self.isFirstResponder;
            self.enabled = false; // iOS6.1Bug fix
            self.secureTextEntry = !_secretButton.selected;
            self.enabled = true;
            if (isFirstResponder) {
                [self becomeFirstResponder];
            }
//        }
        self.text = self.text; // Fixed: 字体不一致
    }
}

- (void)clearText {
    self.text = @"";
    self.clearButton.hidden = YES;
//    if (runningOniOS7) {
//        if (self.fieldType == KKZTextFieldWithClearAndSecret) {
//            self.secretButton.selected = NO;
//            self.secureTextEntry = YES;
//        }
//    }
    self.secretButton.hidden = YES;
    
    if (self.kkzDelegate && [self.kkzDelegate respondsToSelector:@selector(kkzTextFieldClear:)]) {
        [self.kkzDelegate kkzTextFieldClear:self];
    }
}

@end
