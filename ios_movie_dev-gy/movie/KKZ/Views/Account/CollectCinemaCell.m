//
//  收藏影院列表的Cell
//
//  Created by KKZ on 15/12/15.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CollectCinemaCell.h"

#import "RoundCornersButton.h"
#import "UIConstants.h"

static const CGFloat kMargin = 15;

@interface CollectCinemaCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) RoundCornersButton *cancelCollectButton;

@property (nonatomic, strong) UIView *divider;

@end

@implementation CollectCinemaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cinemaDistance = -1;

        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.distanceLabel];
        [self addSubview:self.cancelCollectButton];
        [self addSubview:self.divider];

        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(handleTapped:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGRect frame = CGRectMake(kMargin, 12, screentWith - kMargin * 2 - 100, 19);

        _nameLabel = [[UILabel alloc] initWithFrame:frame];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = HEX(@"#434343");
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGRect frame = CGRectMake(kMargin, 12 + 19 + 7, screentWith - kMargin * 2 - 90, 16);

        _addressLabel = [[UILabel alloc] initWithFrame:frame];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = HEX(@"#999999");
    }
    return _addressLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        CGRect frame = CGRectMake(kMargin, 12 + 19 + 7 + 16 + 4, screentWith - kMargin * 2 - 100, 16);

        _distanceLabel = [[UILabel alloc] initWithFrame:frame];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = HEX(@"#999999");
    }
    return _distanceLabel;
}

- (RoundCornersButton *)cancelCollectButton {
    if (!_cancelCollectButton) {
        CGRect frame = CGRectMake(screentWith - 12 - 75, 27, 74, kDimensButtonHeight);

        _cancelCollectButton = [[RoundCornersButton alloc] initWithFrame:frame];
        _cancelCollectButton.userInteractionEnabled = NO;
        _cancelCollectButton.backgroundColor = [UIColor whiteColor];
        _cancelCollectButton.titleColor = kOrangeColor;
        _cancelCollectButton.titleFont = [UIFont systemFontOfSize:14];
        _cancelCollectButton.titleName = @"取消收藏";
        _cancelCollectButton.cornerNum = kButtonCornerNum;
        _cancelCollectButton.rimWidth = 1;
        _cancelCollectButton.rimColor = kOrangeColor;
    }
    return _cancelCollectButton;
}

- (UIView *)divider {
    if (!_divider) {
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 84, screentWith, 1)];
        _divider.backgroundColor = kDividerColor;
    }
    return _divider;
}

- (void)updateLayout {
    self.nameLabel.text = self.cinemaName;
    self.addressLabel.text = self.cinemaAddr;

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        self.cinemaDistance < 0 || self.cinemaDistance > 100000000) {

        self.distanceLabel.hidden = YES;

        self.nameLabel.frame = CGRectMake(kMargin, 20, screentWith - kMargin * 2 - 100, 19);
        self.addressLabel.frame = CGRectMake(kMargin, 20 + 19 + 7, screentWith - kMargin * 2 - 90, 16);
    } else {
        self.distanceLabel.hidden = NO;

        self.nameLabel.frame = CGRectMake(kMargin, 12, screentWith - kMargin * 2 - 100, 19);
        self.addressLabel.frame = CGRectMake(kMargin, 12 + 19 + 7, screentWith - kMargin * 2 - 90, 16);
        self.distanceLabel.frame = CGRectMake(kMargin, 12 + 19 + 7 + 16 + 4, screentWith - kMargin * 2 - 100, 16);

        if (self.cinemaDistance < 1000) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%dm", (int) self.cinemaDistance];
        } else {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", self.cinemaDistance / 1000.f];
        }
    }
}

- (void)handleTapped:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (CGRectContainsPoint(self.cancelCollectButton.frame, point)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnCancelCollectAtRow:)]) {
            [self.delegate handleTouchOnCancelCollectAtRow:self.rowNum];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnDetailAtRow:)]) {
            [self.delegate handleTouchOnDetailAtRow:self.rowNum];
        }
    }
}

@end
