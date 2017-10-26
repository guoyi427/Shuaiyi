//
//  影院详情页面列表的每个Section的Header
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaTableSectionView.h"

#import "UIColor+Hex.h"
#import "UIConstants.h"

/****************区域的名字********************/
const static CGFloat titleLabelLeft = 13.0f;
const static CGFloat titleLabelTop = 12.0f;
const static CGFloat titleLabelHeight = 15.0f;
const static CGFloat titleLabelWidth = 100.0f;
const static CGFloat titleLabelFont = 15.0f;

/****************区域********************/
const static CGFloat whiteBackViewHeight = 40.0f;

/****************更多按钮********************/
const static CGFloat moreBtnHeight = 40.0f;
const static CGFloat moreBtnFont = 14.0f;

/****************分割线********************/
const static CGFloat lineViewTop = 39.0f;
const static CGFloat lineViewHeight = 1.0f;

@interface CinemaTableSectionView ()

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  白色背景视图
 */
@property (nonatomic, strong) UIView *whiteBackView;

/**
 *  更多按钮
 */
@property (nonatomic, strong) UIButton *moreBtn;

/**
 *  分割线视图
 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CinemaTableSectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //标题和箭头的背景视图
        [self addSubview:self.whiteBackView];

        //section标题
        [self.whiteBackView addSubview:self.titleLabel];

        //section箭头按钮
        [self.whiteBackView addSubview:self.moreBtn];

        //分割线
        [self.whiteBackView addSubview:self.lineView];
    }
    return self;
}

- (void)updateLayout {

    //section标题赋值
    self.titleLabel.text = self.titleStr;

    //更多按钮显示还是隐藏
    if (self.BtnHidden) {
        self.moreBtn.hidden = YES;
    } else {
        self.moreBtn.hidden = NO;
    }

    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.whiteBackView.frame);
    self.frame = frame;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelLeft, titleLabelTop, titleLabelWidth, titleLabelHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HEX(@"#969696");
        _titleLabel.font = [UIFont systemFontOfSize:titleLabelFont];
    }
    return _titleLabel;
}

- (UIView *)whiteBackView {
    if (!_whiteBackView) {
        _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, whiteBackViewHeight)];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        UIImage *arrowImg = [UIImage imageNamed:@"arrowRightGray"];
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.backgroundColor = [UIColor clearColor];
        CGFloat moreButtonRight = 10.0f;
        CGFloat moreButtonWidth = self.whiteBackView.frame.size.width;
        _moreBtn.frame = CGRectMake(screentWith - moreButtonWidth, 0, moreButtonWidth, moreBtnHeight);
        _moreBtn.contentMode = UIViewContentModeCenter;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:moreBtnFont];
        [_moreBtn setImage:arrowImg
                  forState:UIControlStateNormal];
        [_moreBtn setTitleColor:HEX(@"#969696")
                       forState:UIControlStateNormal];
        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, moreButtonWidth - moreButtonRight - arrowImg.size.width, 0, moreButtonRight)];
        _moreBtn.hidden = YES;
        [_moreBtn addTarget:self
                          action:@selector(showMoreClick)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lineViewTop, kCommonScreenWidth, lineViewHeight)];
        _lineView.backgroundColor = kDividerColor;
    }
    return _lineView;
}

- (void)showMoreClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CinemaDetailShowMore:)]) {
        [self.delegate CinemaDetailShowMore:self.sectionNum];
    }
}

@end
