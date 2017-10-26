//
//  EditMutipleChooseCell.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditMutipleChooseCell.h"
#import "UIColor+Hex.h"

/*****************cell的布局****************/
static const CGFloat cellHeight = 46.0f;
static const CGFloat titleLabelLeft = 15.0f;
static const CGFloat titleLabelWidth = 110.0f;
static const CGFloat titleLabelHeight = 16.0f;

static const CGFloat checkImgRight = 15.0f;

@interface EditMutipleChooseCell ()

/**
 *  姓名标签
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  选中图片视图
 */
@property (nonatomic, strong) UIImageView *checkImgV;

/**
 *  选中图片
 */
@property (nonatomic, strong) UIImage *chooseImg;

/**
 *  未选中图片
 */
@property (nonatomic, strong) UIImage *unchooseImg;

@end

@implementation EditMutipleChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        //名字标签

        [self addSubview:self.nameLabel];

        //分割线
        [self addSubview:self.lineView];

        //添加勾选视图
        [self addSubview:self.checkImgV];
    }
    return self;
}

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelLeft, (cellHeight - titleLabelHeight) / 2.0f, titleLabelWidth, titleLabelHeight)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _nameLabel;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 0.3f, kCommonScreenWidth, 0.3f)];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _lineView;
}

- (UIImageView *)checkImgV {

    if (!_checkImgV) {
        _checkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth - self.chooseImg.size.width - checkImgRight, (cellHeight - self.chooseImg.size.height) / 2.0f, self.chooseImg.size.width, self.chooseImg.size.height)];
        _checkImgV.image = self.chooseImg;
    }
    return _checkImgV;
}

- (UIImage *)chooseImg {
    if (!_chooseImg) {
        _chooseImg = [UIImage imageNamed:@"coupon_select_icon"];
    }
    return _chooseImg;
}

- (UIImage *)unchooseImg {
    if (!_unchooseImg) {
        _unchooseImg = [UIImage imageNamed:@"unselect_method_icon"];
    }
    return _unchooseImg;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _nameLabel.text = _titleStr;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (_checked) {
        self.checkImgV.image = self.chooseImg;
    } else {
        self.checkImgV.image = self.unchooseImg;
    }
}

+ (CGFloat)cellHeight {
    return cellHeight;
}

@end
