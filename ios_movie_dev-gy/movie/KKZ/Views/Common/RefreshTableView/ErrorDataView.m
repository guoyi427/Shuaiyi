//
//  ErrorDataView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "ErrorDataView.h"

static const CGFloat errorLblHeight = 20.0f;

@interface ErrorDataView ()

/**
 *  错误图片视图
 */
@property (nonatomic, strong) UIImageView *errorImgView;

/**
 *   错误标签
 */
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation ErrorDataView

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        //错误视图
        [self addSubview:self.errorImgView];

        //错误标签
        self.errorLabel.text = title;
        [self addSubview:self.errorLabel];
    }
    return self;
}

- (UIImageView *)errorImgView {
    if (!_errorImgView) {
        //错误图片
        UIImage *errorImg = [UIImage imageNamed:@"failure"];
        _errorImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - errorImg.size.width) / 2.0f, (self.frame.size.height - errorImg.size.height) / 2.0f - errorLblHeight, errorImg.size.width,
                                                                      errorImg.size.height)];
        _errorImgView.image = errorImg;
    }
    return _errorImgView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        CGFloat errorLeft = 15.0f;
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(errorLeft, CGRectGetMaxY(self.errorImgView.frame), self.frame.size.width - errorLeft * 2, errorLblHeight)];
        _errorLabel.numberOfLines = 0;
        _errorLabel.textColor = [UIColor grayColor];
        _errorLabel.font = [UIFont boldSystemFontOfSize:14];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor clearColor];
    }
    return _errorLabel;
}

- (void)layoutSubviews {

    //修改表情图片尺寸
    CGRect imgFrame = self.errorImgView.frame;
    imgFrame.origin.y = (self.frame.size.height - imgFrame.size.height) / 2.0f - errorLblHeight;
    self.errorImgView.frame = imgFrame;

    //修改表情对应的文字
    CGRect labelFrame = self.errorLabel.frame;
    labelFrame.origin.y = CGRectGetMaxY(self.errorImgView.frame);
    self.errorLabel.frame = labelFrame;
}

@end
