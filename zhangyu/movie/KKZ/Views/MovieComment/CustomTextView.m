//
//  CustomTextView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CustomTextView.h"
#import "UIColor+Hex.h"

@interface CustomTextView ()

/**
 *  用户未输入文字的标签
 */
@property (nonatomic, strong) UILabel *placeLabel;

@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        //工具条
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 45)];
        [topView setBarStyle:UIBarStyleDefault];
        topView.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnToolBar.frame = CGRectMake(2, 7, 50, 30);
        [btnToolBar addTarget:self
                       action:@selector(dismissKeyBoard)
             forControlEvents:UIControlEventTouchUpInside];
        [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];
        [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btnToolBar];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
        [topView setItems:buttonsArray];
        [self setInputAccessoryView:topView];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //设置输入框的placeHolder的文字
    if (textView.text.length == 0) {
        self.placeLabel.hidden = NO;
    }else {
        self.placeLabel.hidden = YES;
    }
    
//    //获取文本框的文字
//    NSString  *nsTextContent = textView.text;
//    NSInteger existTextNum = nsTextContent.length;
//    if (existTextNum > self.maxWordCount && self.maxWordCount > 0)
//    {
//        //截取到最大位置的字符
//        NSString *s = [nsTextContent substringToIndex:self.maxWordCount];
//        [textView setText:s];
//    }
}

- (void)setCustomText:(NSString *)customText {
    [self setText:customText];
    [self textViewDidChange:self];
}

- (void)dismissKeyBoard {
    [self resignFirstResponder];
}

- (UILabel *)placeLabel {
    
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.0f, 7.0f, self.frame.size.width - 16.0f, 17.0f)];
        _placeLabel.textColor = [UIColor colorWithHex:@"#bdbdbd"];
        _placeLabel.font = [UIFont systemFontOfSize:15.0f];
        _placeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeLabel];
    }
    return _placeLabel;
}

- (void)setPlaceHoder:(NSString *)placeHoder {
    _placeHoder = placeHoder;
    self.placeLabel.text = _placeHoder;
}

@end
