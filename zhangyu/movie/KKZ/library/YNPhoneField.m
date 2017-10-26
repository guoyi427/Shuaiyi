//
//  YNPhoneField.m
//  KoMovie
//
//  Created by 艾广华 on 15/11/9.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "YNPhoneField.h"

@interface YNPhoneField ()

@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;

@end

@implementation YNPhoneField

/**
 *  初始化视图
 *
 *  @param frame
 *  @param isSecure 是否显示加密视图
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withShowSecure:(BOOL)isSecure{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isShowSecure = isSecure;
        
        //添加视图
        [self addSubview];
        
        //添加文本改变事件
        [self addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

/**
 *  添加视图
 */
- (void)addSubview {
    
    __weak YNPhoneField *weakSelf = self;
    
    //重置视图
    UIImage *clearImg = [UIImage imageNamed:@"iconfont-shanchu"];
    CGFloat clearRightMargin = 15.0f;
    CGFloat rescureWidth = 40.0f;
    if (!self.isShowSecure) {
        rescureWidth = 0.0f;
    }
    CGFloat clearWidth = clearImg.size.width + clearRightMargin*2;
    CGFloat resetViewWidth = clearWidth + rescureWidth;
    
    UIView *resetView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - resetViewWidth, 0,resetViewWidth,self.frame.size.height)];
    resetView.backgroundColor = [UIColor clearColor];
    [self addSubview:resetView];
    
    //清除按钮
    self.clearBtnYN = [[UIButton alloc] initWithFrame:CGRectMake(rescureWidth, 0, clearWidth,self.frame.size.height)];
    self.clearBtnYN.backgroundColor = [UIColor clearColor];
    [self.clearBtnYN setImage:clearImg forState:UIControlStateNormal];
    [self.clearBtnYN addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [resetView addSubview:self.clearBtnYN];
    
    //重新修改重置视图尺寸
    if (self.isShowSecure) {
        UIImage *eyeImg = [UIImage imageNamed:@"iconfont-bukejian"];
        UIImage *seeImg = [UIImage imageNamed:@"iconfont-kejian"];
        self.secureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rescureWidth, self.frame.size.height)];
        self.secureBtn.backgroundColor = [UIColor clearColor];
        self.secureBtn.contentMode = UIViewContentModeScaleAspectFit;
        [self.secureBtn addTarget:self action:@selector(changeSecure:) forControlEvents:UIControlEventTouchUpInside];
        [self.secureBtn setImage:eyeImg forState:UIControlStateNormal];
        [self.secureBtn setImage:seeImg forState:UIControlStateSelected];
        [resetView addSubview:self.secureBtn];
    }
    
    //设置文本框的右视图
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
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification
                                                                                  object:nil
                                                                                   queue:nil
                                                                              usingBlock:^(NSNotification *note){
        
        if (weakSelf == note.object) {
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
                if (weakSelf.isShowSecure) {
                    weakSelf.secureTextEntry = YES;
                }
            }
            weakSelf.secureBtn.hidden = YES;
            weakSelf.clearBtnYN.hidden = YES;
        }
    }];
}

/**
 *  改变文本的加密
 *
 *  @param btn
 */
- (void)changeSecure:(UIButton *)btn {
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

/**
 *  设置文本加密属性
 *
 *  @param secureTextEntry
 */
- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    [super setSecureTextEntry:secureTextEntry];
}

/**
 *  清空文本
 *
 *  @param btn
 */
- (void)clearText:(UIButton *)btn {
    self.text = @"";
    self.clearBtnYN.hidden = YES;
    if (runningOniOS7) {
        self.secureBtn.selected = NO;
        if (self.isShowSecure) {
            self.secureTextEntry = YES;
        }
    }
    self.secureBtn.hidden = YES;
}

/**
 *  文本变化的时候
 *
 *  @param textField
 */
- (void)textFieldDidChange:(UITextField *)textField {
    
    if (self.text.length == 0) {
        self.secureBtn.hidden = YES;
        self.clearBtnYN.hidden = YES;
    }
    else {
        self.secureBtn.hidden = NO;
        self.clearBtnYN.hidden = NO;
    }
}

/**
 *  变量释放
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}



@end
