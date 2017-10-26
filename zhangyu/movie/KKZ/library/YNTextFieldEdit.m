//
//  YNTextFieldEdit.m
//  KoMovie
//
//  Created by avatar on 15/7/1.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "YNTextFieldEdit.h"

@interface YNTextFieldEdit()

@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;

@end


@implementation YNTextFieldEdit

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview];
        
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}


- (void)addSubview {
    
    __weak YNTextFieldEdit *weakSelf = self;
    
    UIView *resetView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 0, 80, self.frame.size.height)];
    [self addSubview:resetView];
    
    self.secureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
    self.secureBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.secureBtn addTarget:self action:@selector(changeSecure:) forControlEvents:UIControlEventTouchUpInside];
    [self.secureBtn setImage:[UIImage imageNamed:@"secureSel"] forState:UIControlStateNormal];
    [self.secureBtn setImage:[UIImage imageNamed:@"secure"] forState:UIControlStateSelected];
    [resetView addSubview:self.secureBtn];
    
    self.clearBtnYN = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, self.frame.size.height)];
    self.clearBtnYN.contentMode = UIViewContentModeScaleAspectFit;
    [self.clearBtnYN setImage:[UIImage imageNamed:@"clearBtnYN"] forState:UIControlStateNormal];
    [self.clearBtnYN addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [resetView addSubview:self.clearBtnYN];
    
    self.rightView = resetView;
    
    if (runningOniOS7) {
        self.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    else {
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    self.secureBtn.hidden = YES;
    self.clearBtnYN.hidden = YES;
    
    // 获取焦点
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                                                      
        if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
            if (self.text.length) {
                weakSelf.secureBtn.hidden = NO;
                weakSelf.clearBtnYN.hidden = NO;
            }
            else {
                weakSelf.secureBtn.hidden = YES;
                weakSelf.clearBtnYN.hidden = YES;
            }
        }
    }];
    
    // 失去焦点
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (weakSelf == note.object) {
            if (runningOniOS7) {
                weakSelf.secureBtn.selected =  NO;
                weakSelf.secureTextEntry = YES;
            }
            weakSelf.secureBtn.hidden = YES;
            weakSelf.clearBtnYN.hidden = YES;
        }
    }];
}


- (void)changeSecure:(UIButton *)btn {
    DLog(@"btn.selected =====  %d",btn.selected);
    
    btn.selected = !btn.selected;
    
    if (runningOniOS7) {
        self.secureTextEntry = !btn.selected;
        BOOL isFirstResponder = self.isFirstResponder;
        if (isFirstResponder) {
            [self becomeFirstResponder];
        }
    }
    else {
        BOOL isFirstResponder = self.isFirstResponder;
        self.enabled = false; // iOS6.1Bug fix
        self.secureTextEntry = !btn.selected;
        self.enabled = true;
        if (isFirstResponder) {
            [self becomeFirstResponder];
        }
    }
    
    self.font = [UIFont systemFontOfSize:[self.font pointSize]];
}


- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    [super setSecureTextEntry:secureTextEntry];
}


- (void)clearText:(UIButton *)btn {
    self.text = @"";
    self.clearBtnYN.hidden = YES;
    if (runningOniOS7) {
        self.secureBtn.selected = NO;
        self.secureTextEntry = YES;
    }
    self.secureBtn.hidden = YES;
}


- (void)textFieldDidChange:(UITextField *)textField {
    
    if (self.text.length == 0) {
        self.secureBtn.hidden = YES;
        self.clearBtnYN.hidden = YES;
    }
    else {
        self.secureBtn.hidden = NO;
        self.clearBtnYN.hidden = NO;
    }
    
    // TODO 添加限制输入长度和限制内容的逻辑
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}


@end

