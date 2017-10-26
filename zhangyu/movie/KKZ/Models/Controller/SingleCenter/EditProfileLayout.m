//
//  EditProfileLayout.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileLayout.h"
#import "KKZUtility.h"

static const CGFloat KDefalutTextCellHeight = 50.0f;

@implementation EditProfileLayout

- (id)init {
    self = [super init];
    if (self) {
        self.textCellHeight = KDefalutTextCellHeight;
    }
    return self;
}

- (void)caculationLayoutFrame:(UserInfo *)model {
    CGFloat textCellTextWidth = kCommonScreenWidth - textCellTitleLeft - textCellArrowImgRight - self.textCellArrowImg.size.width - textCellDetailTitleRight;
    CGSize size = [KKZUtility customTextSize:self.textCellDetailTitleFont
                                        text:model.signature
                                        size:CGSizeMake(textCellTextWidth, CGFLOAT_MAX)];
    if (size.height < 10.0f) {
        size.height = 20.0f;
    }
    self.textCellDetailTitleFrame = CGRectMake(textCellTitleLeft,textCellTitleTop + textCellTitlelHeight + textCellDetailTitleTop, textCellTextWidth, size.height);
    self.textCellHeight = CGRectGetMaxY(self.textCellDetailTitleFrame) + textCellDetailTitleBottom;
}

- (UIImage *)textCellArrowImg {
    if (!_textCellArrowImg) {
        _textCellArrowImg = [UIImage imageNamed:@"arrowRightGray"];
    }
    return _textCellArrowImg;
}

- (UIFont *)textCellDetailTitleFont {
    if (!_textCellDetailTitleFont) {
        _textCellDetailTitleFont = [UIFont systemFontOfSize:15.0f];
    }
    return _textCellDetailTitleFont;
}

- (CGRect)textCellArrowFrame {
    return CGRectMake(kCommonScreenWidth - self.textCellArrowImg.size.width - textCellArrowImgRight,(self.textCellHeight - self.textCellArrowImg.size.height)/2.0f, self.textCellArrowImg.size.width, self.textCellArrowImg.size.height);
}



@end
