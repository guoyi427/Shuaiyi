//
//  EditTextCell.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditTextCell.h"
#import "KKZUtility.h"
#import "UIColor+Hex.h"

#define DETAIL_NO_TITLE_TEXT @"这家伙很懒，什么都没留下"

@interface EditTextCell ()

/**
 *  姓名标签
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  子标题
 */
@property (nonatomic, strong) UILabel *detailLabel;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowImgV;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditTextCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        //名字标签
        [self addSubview:self.nameLabel];

        //子标题标签
        [self addSubview:self.detailLabel];

        //箭头视图
        [self addSubview:self.arrowImgV];

        //分割线
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect frame = self.lineView.frame;
    frame.origin.y = CGRectGetHeight(self.frame) - frame.size.height;
    self.lineView.frame = frame;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textCellTitleLeft, textCellTitleTop, textCellTitleWidth, textCellTitlelHeight)];
        _nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.numberOfLines = -1;
        _detailLabel.textColor = [UIColor colorWithHex:@"#999999"];
    }
    return _detailLabel;
}

- (UIImageView *)arrowImgV {
    if (!_arrowImgV) {
        _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _arrowImgV;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kCommonScreenWidth, 0.3f)];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _lineView;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _nameLabel.text = _titleStr;
}

- (void)setDetailTitleStr:(NSString *)detailTitleStr {
    _detailTitleStr = detailTitleStr;
    if ([KKZUtility stringIsEmpty:_detailTitleStr]) {
        _detailLabel.text = DETAIL_NO_TITLE_TEXT;
    } else {
        _detailLabel.text = _detailTitleStr;
    }
}

- (void)setLayout:(EditProfileLayout *)layout {
    _layout = layout;
    self.detailLabel.font = _layout.textCellDetailTitleFont;
    self.detailLabel.frame = layout.textCellDetailTitleFrame;
    self.arrowImgV.frame = layout.textCellArrowFrame;
    self.arrowImgV.image = layout.textCellArrowImg;
}

@end
