//
//  SingleCenterTableViewCell.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SingleCenterTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "KKZUtility.h"

@interface SingleCenterTableViewCell () {
    //白色背景视图
    UIView *whiteView;
}

/**
 *  图标视图
 */
@property (nonatomic, strong) UIImageView *iconImgV;

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowImgV;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView *sepetateLine;

/**
 *  数量标签
 */
@property (nonatomic, strong) UILabel *countLabel;

/**
 *  底部视图
 */
@property (nonatomic, strong) UIView *footerView;

@end

@implementation SingleCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        //添加白色背景视图
        whiteView = [[UIView alloc] initWithFrame:CGRectZero];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];

        //icon图标
        _iconImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_iconImgV];

        //更多箭头
        UIImage *arrowImg = [UIImage imageNamed:@"arrowRightGray"];
        _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImgV.image = arrowImg;
        [self addSubview:_arrowImgV];

        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHex:@"#666666"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];

        //分割线
        _sepetateLine = [[UIView alloc] initWithFrame:CGRectZero];
        _sepetateLine.backgroundColor = [UIColor colorWithHex:@"#e5e5e5"];
        [self addSubview:_sepetateLine];

        //数量标签
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_countLabel setTextColor:[UIColor whiteColor]];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.layer.cornerRadius = 7.0f;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.layer.masksToBounds = YES;
        [self addSubview:_countLabel];

        //底脚视图
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, TABLEVIEW_CELL_HEIGHT, CGRectGetWidth(self.frame), TABLEVIEW_FOOTER_HEIGHT)];
        _footerView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
        [self addSubview:_footerView];
    }
    return self;
}

/**
 *  更新子视图
 */
- (void)layoutSubviews {

    //白色背景视图
    whiteView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    //底脚视图
    CGRect footerFrame = _footerView.frame;
    footerFrame.size.width = CGRectGetWidth(self.frame);
    _footerView.frame = footerFrame;
}

- (void)updateModel:(SingleCenterModel *)model
        modelLayout:(SingleCenterLayout *)layout {
    _model = model;

    //图标
    _iconImgV.frame = layout.iconFrame;
    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:model.icon]];

    //设置标题
    _titleLabel.text = model.name;
    _titleLabel.font = layout.titleFont;
    _titleLabel.frame = layout.titleLabelFrame;

    //是否画分割线
    _sepetateLine.frame = layout.sepLineFrame;
    if (self.model.isLast) {
        _sepetateLine.hidden = YES;
        _footerView.hidden = NO;
    } else {
        _sepetateLine.hidden = NO;
        _footerView.hidden = YES;
    }

    //箭头
    _arrowImgV.frame = layout.arrowFrame;

    //评价个数
    if (model.waitEvalueCount <= 0) {
        self.countLabel.hidden = TRUE;
    } else {
        self.countLabel.hidden = FALSE;
        if (model.waitEvalueCount > 99) {
            self.countLabel.text = [NSString stringWithFormat:@"99+"];
        } else {
            self.countLabel.text = [NSString stringWithFormat:@"%d", model.waitEvalueCount];
        }
    }
    self.countLabel.font = layout.countLabelFont;
    self.countLabel.frame = layout.countLabelFrame;
}

@end
