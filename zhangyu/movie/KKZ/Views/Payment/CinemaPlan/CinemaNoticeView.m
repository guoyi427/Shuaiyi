//
//  排期列表页面的影院通知View
//
//  Created by 艾广华 on 16/4/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaNoticeView.h"

#import "KKZUtility.h"
#import <Category_KKZ/UIColor+Hex.h>

/****************标签*************/
static const CGFloat noticeLabelTop = 8.0f;
static const CGFloat noticeLabelBottom = 8.0f;
static const CGFloat noticeLabelLeft = 15.0f;
static const CGFloat noticeLabelFont = 12.0f;
static const CGFloat noticeLabelMaxHeight = 95.0f;

@interface CinemaNoticeView ()

/**
 *  影院通知标签
 */
@property (nonatomic, strong) UILabel *noticeLabel;

@end

@implementation CinemaNoticeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //视图的背景颜色
        self.backgroundColor = [UIColor colorWithHex:@"#fffbde"];

        //添加影院通知
        [self addSubview:self.noticeLabel];
    }
    return self;
}

- (void)setNoticeString:(NSString *)noticeString {
    _noticeString = noticeString;
    self.noticeLabel.text = _noticeString;
}

- (void)updateLayout {
    CGSize size = [KKZUtility customTextSize:self.noticeLabel.font
                                        text:self.noticeLabel.text
                                        size:CGSizeMake(self.noticeLabel.frame.size.width, CGFLOAT_MAX)];
    CGRect noticeFrame = self.noticeLabel.frame;
    if (noticeFrame.size.height > noticeLabelMaxHeight) {
        noticeFrame.size.height = noticeLabelMaxHeight;
    }
    noticeFrame.size.height = size.height;
    self.noticeLabel.frame = noticeFrame;

    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.noticeLabel.frame) + noticeLabelBottom;
    self.frame = frame;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(noticeLabelLeft, noticeLabelTop, kCommonScreenWidth - noticeLabelLeft * 2, 0)];
        _noticeLabel.font = [UIFont systemFontOfSize:noticeLabelFont];
        _noticeLabel.textColor = [UIColor colorWithHex:@"#977D46"];
        _noticeLabel.backgroundColor = [UIColor clearColor];
        _noticeLabel.numberOfLines = -1;
    }
    return _noticeLabel;
}

@end
