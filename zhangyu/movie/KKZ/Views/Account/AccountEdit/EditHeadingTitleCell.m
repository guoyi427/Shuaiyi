//
//  EditHeadingTitleCell.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditHeadingTitleCell.h"
#import "KKZUtility.h"

/*****************cell的布局****************/
static const CGFloat cellHeight = 93.0f;
static const CGFloat titleLabelLeft = 15.0f;
static const CGFloat titleLabelWidth = 110.0f;
static const CGFloat titleLabelHeight = 16.0f;

static const CGFloat headingHeight = 43.0f;
static const CGFloat bottomHeight = 50.0f;

/*****************cell右箭头****************/
static const CGFloat arrowImgRight = 15.0f;

/*****************cell子标题****************/
static const CGFloat detailLabelRight = 10.0f;

#define DETAIL_TITLE_COLOR [UIColor colorWithHex:@"#999999"]
#define DETAIL_NO_TITLE_COLOR [UIColor colorWithHex:@"#ff6900"]
#define DETAIL_NO_TITLE_TEXT @"请填写"

@interface EditHeadingTitleCell ()

/**
 *  姓名标签
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  子标题
 */
@property (nonatomic, strong) UILabel *detailLabel;

/**
 *  底部视图
 */
@property (nonatomic, strong) UIView *topView;

/**
 *  顶端视图标签
 */
@property (nonatomic, strong) UILabel *headingLabel;

/**
 *  底部视图
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowImgV;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditHeadingTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        //添加顶端视图
        [self addSubview:self.topView];

        //添加顶端标签
        [self.topView addSubview:self.headingLabel];

        //添加底部视图
        [self addSubview:self.bottomView];

        //名字标签
        [self.bottomView addSubview:self.nameLabel];

        //右箭头
        [self.bottomView addSubview:self.arrowImgV];

        //添加子标题
        [self.bottomView addSubview:self.detailLabel];

        //分割线
        [self addSubview:self.lineView];
    }
    return self;
}

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelLeft, (bottomHeight - titleLabelHeight) / 2.0f, titleLabelWidth, titleLabelHeight)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _nameLabel;
}

- (UIImageView *)arrowImgV {

    if (!_arrowImgV) {
        UIImage *arrowImg = [UIImage imageNamed:@"arrowRightGray"];
        _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth - arrowImg.size.width - arrowImgRight, (bottomHeight - arrowImg.size.height) / 2.0f, arrowImg.size.width, arrowImg.size.height)];
        _arrowImgV.image = arrowImg;
    }
    return _arrowImgV;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
        CGFloat detailWidth = kCommonScreenWidth - titleLabelLeft - titleLabelWidth - CGRectGetWidth(_arrowImgV.frame) - arrowImgRight - detailLabelRight;
        CGRect frame = CGRectMake(CGRectGetMinX(_arrowImgV.frame) - detailLabelRight - detailWidth, (bottomHeight - titleLabelHeight) / 2.0f, detailWidth, titleLabelHeight);
        _detailLabel = [[UILabel alloc] initWithFrame:frame];
        _detailLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _detailLabel;
}

- (UILabel *)headingLabel {

    if (!_headingLabel) {
        CGRect frame = CGRectMake(titleLabelLeft, 0, kCommonScreenWidth, headingHeight);
        _headingLabel = [[UILabel alloc] initWithFrame:frame];
        _headingLabel.font = [UIFont systemFontOfSize:15.0f];
        _headingLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _headingLabel.backgroundColor = CELL_BACKGROUND_COLOR;
    }
    return _headingLabel;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabelLeft, cellHeight - 0.3f, kCommonScreenWidth - titleLabelLeft, 0.3f)];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
    }
    return _lineView;
}

- (UIView *)bottomView {

    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headingHeight, kCommonScreenWidth, bottomHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, headingHeight)];
        _topView.backgroundColor = CELL_BACKGROUND_COLOR;
    }
    return _topView;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _nameLabel.text = _titleStr;
}

- (void)setHeadingStr:(NSString *)headingStr {
    _headingStr = headingStr;
    _headingLabel.text = _headingStr;
}

- (void)setDetailTitleStr:(NSString *)detailTitleStr {
    _detailTitleStr = detailTitleStr;
    if ([KKZUtility stringIsEmpty:_detailTitleStr]) {
        _detailLabel.text = DETAIL_NO_TITLE_TEXT;
        _detailLabel.textColor = DETAIL_NO_TITLE_COLOR;
    } else {
        _detailLabel.text = _detailTitleStr;
        _detailLabel.textColor = DETAIL_TITLE_COLOR;
    }
}

@end
