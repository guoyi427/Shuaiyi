//
//  电影详情页面列表Cell的Header
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieDetailHeader.h"

static const CGFloat kMarginX = 15;
static const CGFloat kHeaderHeight = 45;

static const CGFloat kTitleLabelFont = 15;

@implementation MovieDetailHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, kHeaderHeight)];
        whiteBg.backgroundColor = [UIColor clearColor];
        [self addSubview:whiteBg];

        self.backgroundColor = [UIColor whiteColor];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, (kHeaderHeight - kTitleLabelFont) * 0.5, screentWith, kTitleLabelFont)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor r:51 g:51 b:51];
        titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFont];
        titleLabel.text = @"剧情简介";
        [self addSubview:titleLabel];

        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight - 1, screentWith, 1)];
        bottomLine.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)updateLayout {
    headerLogoImg.image = self.image;
    titleLabel.text = self.titleStr;

    if (self.BtnHidden) {
        moreBtn.hidden = YES;
    } else {
        moreBtn.hidden = NO;
    }

    if (self.isBtmlineHidden) {
        bottomLine.hidden = YES;
    } else {
        bottomLine.hidden = NO;
    }
}

- (void)showMoreClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(MovieDetailShowMore:)]) {
        [self.delegate MovieDetailShowMore:self.sectionNum];
    }
}

@end
