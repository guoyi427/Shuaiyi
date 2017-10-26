//
//  EditAvatarCell.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditAvatarCell.h"
#import "UIColor+Hex.h"

/*****************cell的布局****************/
static const CGFloat cellHeight = 61.0f;
static const CGFloat titleLabelLeft = 15.0f;
static const CGFloat titleLabelWidth = 100.0f;
static const CGFloat titleLabelHeight = 16.0f;

/*****************cell右箭头****************/
static const CGFloat arrowImgRight = 15.0f;

/*****************cell头像****************/
static const CGFloat avatarImgRight = 10.0f;
static const CGFloat avatarImgWidth = 45.0f;

@interface EditAvatarCell ()

/**
 *  姓名标签
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowImgV;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        //名字标签
        [self addSubview:self.nameLabel];

        //右箭头
        [self addSubview:self.arrowImgV];

        //头像
        [self addSubview:self.avatarImgV];

        //分割线
        [self addSubview:self.lineView];
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

- (UIImageView *)arrowImgV {

    if (!_arrowImgV) {
        UIImage *arrowImg = [UIImage imageNamed:@"arrowRightGray"];
        _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth - arrowImg.size.width - arrowImgRight, (cellHeight - arrowImg.size.height) / 2.0f, arrowImg.size.width, arrowImg.size.height)];
        _arrowImgV.image = arrowImg;
    }
    return _arrowImgV;
}

- (UIImageView *)avatarImgV {

    if (!_avatarImgV) {
        _avatarImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_arrowImgV.frame) - avatarImgRight - avatarImgWidth, (cellHeight - avatarImgWidth) / 2.0f, avatarImgWidth, avatarImgWidth)];
        _avatarImgV.layer.cornerRadius = avatarImgWidth / 2.0f;
        _avatarImgV.layer.masksToBounds = YES;
        _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImgV;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabelLeft, cellHeight - 0.3f, kCommonScreenWidth - titleLabelLeft, 0.3f)];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _lineView;
}

- (UIImage *)defaultImg {
    if (!_defaultImg) {
        _defaultImg = [UIImage imageNamed:@"avatarRImg"];
    }
    return _defaultImg;
}

- (void)setAvatarImg:(UIImage *)avatarImg {
    _avatarImg = avatarImg;
    _avatarImgV.image = _avatarImg;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _nameLabel.text = _titleStr;
}

+ (CGFloat)cellHeight {
    return cellHeight;
}

@end
