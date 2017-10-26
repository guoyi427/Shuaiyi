//
//  首页电影列表Cell中活动信息的View
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieListActivityView.h"

#import "Banner.h"
#import "UIConstants.h"

#define discribeWidth (screentWith - 82 - 12)
#define bottomLineWidth (screentWith - 82)

/*****************活动标题****************/
static const CGFloat titleFont = 10.0f;
static const CGFloat titleLeft = 39.0f;
static const CGFloat titleTop = 15.0f;
static const CGFloat titleWidth = 30.0f;
static const CGFloat titleHeight = 15.0f;

/*****************活动描述****************/
static const CGFloat discribeFont = 13.0f;
static const CGFloat discribeLeft = 82.0f;
static const CGFloat discribeTop = 15.0f;
static const CGFloat discribeHeight = 15.0f;

/*****************下划线****************/
static const CGFloat bottomLineLeft = 82.0f;

@interface MovieListActivityView ()

/**
 *  活动标题
 */
@property (nonatomic, strong) UILabel *activityTitleLbl;

/**
 *  活动描述
 */
@property (nonatomic, strong) UILabel *activityDiscribeLbl;

/**
 *  下分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation MovieListActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //加载活动标题
        [self addSubview:self.activityTitleLbl];

        //加载活动详情
        [self addSubview:self.activityDiscribeLbl];

        //加载下划线
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)setBanner:(Banner *)banner {
    if (banner) {
        _banner = banner;
    }

    self.activityTitleLbl.text = _banner.tag;
    self.activityDiscribeLbl.text = _banner.title;
}

/**
 *  活动标题
 */
- (UILabel *)activityTitleLbl {
    if (!_activityTitleLbl) {
        _activityTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)];
        _activityTitleLbl.font = [UIFont systemFontOfSize:titleFont];
        _activityTitleLbl.textColor = kUIColorOrange;
        _activityTitleLbl.layer.borderWidth = 2.0f / appDelegate.kkzScale;
        _activityTitleLbl.layer.borderColor = kUIColorOrange.CGColor;
        _activityTitleLbl.textAlignment = NSTextAlignmentCenter;
        _activityTitleLbl.layer.cornerRadius = 5.0f / 3.0f;
    }
    return _activityTitleLbl;
}

/**
 *  活动描述
 */
- (UILabel *)activityDiscribeLbl {
    if (!_activityDiscribeLbl) {
        _activityDiscribeLbl = [[UILabel alloc] initWithFrame:CGRectMake(discribeLeft, discribeTop, discribeWidth, discribeHeight)];
        _activityDiscribeLbl.font = [UIFont systemFontOfSize:discribeFont];
        _activityDiscribeLbl.textColor = [UIColor grayColor];
    }
    return _activityDiscribeLbl;
}

/**
 *  下划线
 */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(bottomLineLeft, 0, bottomLineWidth, 0.5)];
        [_bottomLine setBackgroundColor:kUIColorDivider];
    }
    return _bottomLine;
}

@end
