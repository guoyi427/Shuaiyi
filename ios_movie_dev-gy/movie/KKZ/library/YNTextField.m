//
//  YNTextField.m
//  KoMovie
//
//  Created by avatar on 15/7/1.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "YNTextField.h"

@interface YNTextField()

@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;

@end


@implementation YNTextField

/**
 *  初始化视图
 *
 *  @param frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加视图
        [self addSubview];
        
        //添加文本改变事件
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}


- (void)addSubview {
    
    __weak YNTextField *weakSelf = self;
    
   
    
    UIView *resetView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 0, 100, self.frame.size.height)];
    resetView.backgroundColor = [UIColor clearColor];
    [self addSubview:resetView];
    
    /*
     eyeButton.frame = CGRectMake(CGRectGetWidth(inputBgImgV.frame) - eyeImg.size.width - eyeRightMargin,bottomViewCenterY - eyeImg.size.height/2.0f - 6.0f,eyeImg.size.width,eyeImg.size.height + 12.0f);*/
    
    
    //清除按钮
    CGFloat clearRightMargin = 15.0f;
    CGFloat clearLeftMargin = 5.0f;
    UIImage *clearImg = [UIImage imageNamed:@"iconfont-shanchu"];
    self.clearBtnYN = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(resetView.frame) - clearImg.size.width - clearRightMargin - clearLeftMargin, 0, clearImg.size.width + clearRightMargin + clearLeftMargin,self.frame.size.height)];
    self.clearBtnYN.backgroundColor = [UIColor clearColor];
    [self.clearBtnYN setImage:clearImg forState:UIControlStateNormal];
    [self.clearBtnYN setImageEdgeInsets:UIEdgeInsetsMake(0, clearLeftMargin, 0, clearRightMargin)];
    [self.clearBtnYN addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [resetView addSubview:self.clearBtnYN];
    
    //安全按钮
    UIImage *eyeImg = [UIImage imageNamed:@"iconfont-bukejian"];
    UIImage *seeImg = [UIImage imageNamed:@"iconfont-kejian"];
    self.secureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(resetView.frame) - 40.0f - CGRectGetWidth(self.clearBtnYN.frame), 0, 40, self.frame.size.height)];
    self.secureBtn.backgroundColor = [UIColor clearColor];
    self.secureBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.secureBtn addTarget:self action:@selector(changeSecure:) forControlEvents:UIControlEventTouchUpInside];
    [self.secureBtn setImage:eyeImg forState:UIControlStateNormal];
    [self.secureBtn setImage:seeImg forState:UIControlStateSelected];
    [resetView addSubview:self.secureBtn];
    
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

