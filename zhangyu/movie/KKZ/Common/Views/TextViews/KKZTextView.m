//
//  带有PlaceHolder的UITextView
//
//  Created by wuzhen on 16/8/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//
//  TODO improve: placeHolder文字过长不能换行

#import "KKZTextView.h"

#import "KKZKeyboardTopView.h"
#import "UIColor+Hex.h"

#define DEFAULT_PLACE_HOLDER_COLOR HEX(@"#BDBDBD")

@interface KKZTextView ()

/**
 * 用户未输入文字的标签。
 */
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, copy) void (^textChangeCallback)();
@end

@implementation KKZTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWordCount = -1;

        CGRect topFrame = CGRectMake(0, 0, frame.size.width, 38);
        KKZKeyboardTopView *topView = [[KKZKeyboardTopView alloc] initWithFrame:topFrame];
        [self setInputAccessoryView:topView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged {
    // 根据文字多少判断是否显示placeHolder
    self.placeLabel.hidden = (self.text.length > 0);

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
    
    if (self.textChangeCallback) {
        self.textChangeCallback();
    }
}

- (void) textChange:(void(^)())a_block
{
    self.textChangeCallback = [a_block copy];
}

- (void)setText:(NSString *)text {
    [super setText:text];

    [self textChanged];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];

    CGRect frame = self.placeLabel.frame;
    frame.origin.x = textContainerInset.left + 5;
    frame.origin.y = textContainerInset.top;
    frame.size.width = self.frame.size.width - textContainerInset.left - textContainerInset.right - 10;
    self.placeLabel.frame = frame;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        UIEdgeInsets insets = self.textContainerInset;

        _placeLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(insets.left + 5, insets.top,
                                         self.frame.size.width - insets.left - insets.right - 10, 17.0f)];
        _placeLabel.textColor = (self.placeHolderTextColor ? self.placeHolderTextColor : DEFAULT_PLACE_HOLDER_COLOR);
        _placeLabel.font = self.font;
        _placeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeLabel];
    }
    return _placeLabel;
}

- (void)setPlaceHoderText:(NSString *)placeHoder {
    _placeHoderText = placeHoder;
    self.placeLabel.text = _placeHoderText;
}

@end
