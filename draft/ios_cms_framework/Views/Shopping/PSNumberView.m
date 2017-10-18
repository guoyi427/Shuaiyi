//
//  PSNumberView.m
//  CIASMovie
//
//  Created by cias on 2017/1/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PSNumberView.h"

@implementation PSNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        decreaseBtn.backgroundColor = [UIColor clearColor];
        decreaseBtn.frame = CGRectMake(0, 0, 33, 30);
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_clickable"] forState:UIControlStateNormal];
        [decreaseBtn addTarget:self action:@selector(decreaseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:decreaseBtn];
        
        increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        increaseBtn.backgroundColor = [UIColor clearColor];
        increaseBtn.frame = CGRectMake(self.frame.size.width-30, 0, 33, 30);
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_clickable"] forState:UIControlStateNormal];
        [increaseBtn addTarget:self action:@selector(increaseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:increaseBtn];
        
        UIView *textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(33+5, 0, 35, 30)];
        textFieldBg.backgroundColor = [UIColor clearColor];
        textFieldBg.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        textFieldBg.layer.borderWidth = 0.5;
        [self addSubview:textFieldBg];
        
        //数量展示/输入框
        numberTextField = [[UITextField alloc] init];
        numberTextField.text = self.goodsNumString;
        numberTextField.userInteractionEnabled = NO;
        numberTextField.frame = CGRectMake(2, 5, 31, 20);
//        numberTextField.delegate = self;
        numberTextField.textColor = [UIColor colorWithHex:@"#333333"];
        numberTextField.font = [UIFont systemFontOfSize:14];
        numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        numberTextField.textAlignment = NSTextAlignmentCenter;
        numberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        numberTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [textFieldBg addSubview:numberTextField];

    }
    return self;
}


- (void)decreaseBtn{
    [numberTextField resignFirstResponder];
    NSInteger number = [numberTextField.text integerValue] - 1;
    numberTextField.text.length == 0 ? numberTextField.text = @"0" : nil;
    numberTextField.text = [NSString stringWithFormat:@"%ld", number];

    if ([numberTextField.text integerValue] <= 0) {
        numberTextField.text = @"0";
    }
    
    if ([numberTextField.text integerValue] < self.minNumber) {
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_clickable"] forState:UIControlStateNormal];
    }else{
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_invalid"] forState:UIControlStateNormal];
    }

    if ([numberTextField.text isEqualToString:@"0"]) {
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_invalid"] forState:UIControlStateNormal];
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_clickable"] forState:UIControlStateNormal];

    }else{
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_clickable"] forState:UIControlStateNormal];

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(PSTextFieldNumber:indexPath:)]) {
        [self.delegate PSTextFieldNumber:numberTextField.text indexPath:self.index];
    };

}

- (void)increaseBtn{
    [numberTextField resignFirstResponder];

    numberTextField.text.length == 0 ? numberTextField.text = @"0" : nil;
    if ([numberTextField.text integerValue] <= 0) {
        numberTextField.text = @"0";
    }
    if ([numberTextField.text integerValue] >= self.minNumber) {
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_invalid"] forState:UIControlStateNormal];
    }else{
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_clickable"] forState:UIControlStateNormal];
    }
    if ([numberTextField.text integerValue] == self.minNumber) {
        return;
    }
    NSInteger number = [numberTextField.text integerValue] + 1;
    if (number >= self.minNumber) {
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_invalid"] forState:UIControlStateNormal];
    }else{
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_clickable"] forState:UIControlStateNormal];
    }

    numberTextField.text = [NSString stringWithFormat:@"%ld", number];
    if ([numberTextField.text isEqualToString:@"0"]) {
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_invalid"] forState:UIControlStateNormal];
    }else{
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_clickable"] forState:UIControlStateNormal];

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(PSTextFieldNumber:indexPath:)]) {
        [self.delegate PSTextFieldNumber:numberTextField.text indexPath:self.index];
    };

}

- (void)setGoodsNumString:(NSString *)goodsNumString{
    numberTextField.text = goodsNumString;
    if ([numberTextField.text isEqualToString:@"0"]) {
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_invalid"] forState:UIControlStateNormal];
    }else{
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_clickable"] forState:UIControlStateNormal];
    }

}

- (void)updateLayout{
    if (self.isCancelTap) {
        [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_minus_invalid"] forState:UIControlStateNormal];
        [increaseBtn setBackgroundImage:[UIImage imageNamed:@"goods_plus_invalid"] forState:UIControlStateNormal];
    }
}
#pragma mark - UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    textField.text.length == 0 || textField.text.integerValue <= 0 ? numberTextField.text = @"1" : nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(PSTextFieldNumber:indexPath:)]) {
//        [self.delegate PSTextFieldNumber:textField.text indexPath:self.index];
//    };
//}
//

@end
