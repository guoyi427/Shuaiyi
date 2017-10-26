//
//  KKZHorizonCollectionViewCell.m
//
//  Created by 艾广华 on 16/3/11.
//  Copyright © 2016年 艾广华. All rights reserved.
//

#import "KKZHorizonCollectionViewCell.h"
#import "UIColor+Hex.h"

/****************底部视图*************/
static const CGFloat bottomViewHeight = 2.0f;

@interface KKZHorizonCollectionViewCell ()

/**
 *  底部视图
 */
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *offerIcon;
@end

@implementation KKZHorizonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconLbel];
    }
    return self;
}

- (UILabel *)iconLbel {
    if (!_iconLbel) {
        _iconLbel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_iconLbel setTextAlignment:NSTextAlignmentLeft];
        _iconLbel.backgroundColor = [UIColor clearColor];
    }
    return _iconLbel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, bottomViewHeight)];
    }
    return _bottomView;
}

- (void)setShowBottomView:(BOOL)showBottomView {
    _showBottomView = showBottomView;
    if (_showBottomView) {
        CGRect bottomFrame = self.bottomView.frame;
        bottomFrame.origin.y = self.frame.size.height - bottomViewHeight;
        bottomFrame.size.width = self.frame.size.width;
        self.bottomView.frame = bottomFrame;
        [self addSubview:self.bottomView];
    } else {
        [_bottomView removeFromSuperview];
    }
    _bottomView.backgroundColor = _iconLbel.textColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconLbel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void) setShowOfferIcon:(BOOL)showOfferIcon
{
    _showOfferIcon = showOfferIcon;
    
    if (showOfferIcon == YES && self.offerIcon == nil) {
        self.offerIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"offer_icon"]];
        [self addSubview:self.offerIcon];
        [self.offerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    
    self.offerIcon.hidden = !showOfferIcon;
    
}

@end
