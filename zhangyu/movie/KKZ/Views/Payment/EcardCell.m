//
//  优惠券/兑换券列表的Cell
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "DateEngine.h"
#import "EcardCell.h"

#define kMarginX 15

@implementation EcardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        eCardNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 14, screentWith - 15 * 2, 15)];
        eCardNameLabel.backgroundColor = [UIColor clearColor];
        eCardNameLabel.textColor = [UIColor r:55 g:197 b:1];
        eCardNameLabel.numberOfLines = 0;
        eCardNameLabel.textAlignment = NSTextAlignmentLeft;
        eCardNameLabel.font = [UIFont systemFontOfSize:14];
        eCardNameLabel.text = eCardId;
        [self addSubview:eCardNameLabel];

        eCardIdLabel = [[UILabel alloc] init];
        eCardIdLabel.backgroundColor = [UIColor clearColor];
        eCardIdLabel.textColor = [UIColor r:149 g:149 b:149];
        eCardIdLabel.textAlignment = NSTextAlignmentLeft;
        eCardIdLabel.font = [UIFont systemFontOfSize:13];
        eCardIdLabel.text = eCardId;
        [self addSubview:eCardIdLabel];

        eCardExpiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 51, screentWith - 15 * 2, 15)];
        eCardExpiredLabel.backgroundColor = [UIColor clearColor];
        eCardExpiredLabel.textColor = [UIColor r:149 g:149 b:149];
        eCardExpiredLabel.textAlignment = NSTextAlignmentLeft;
        eCardExpiredLabel.font = [UIFont systemFontOfSize:13];
        eCardExpiredLabel.text = eCardId;
        [self addSubview:eCardExpiredLabel];

        selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 55, 30, 20, 20)];
        selectImg.image = [UIImage imageNamed:@"coupon_no_select"];
        selectImg.hidden = YES;
        [self addSubview:selectImg];

        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor r:234 g:234 b:234];
        [self addSubview:line];
    }
    return self;
}

- (void)updateLayoutYN {
    if (self.isShow) {
        selectImg.hidden = NO;
    } else {
        selectImg.hidden = YES;
    }

    NSDate *dd = [[DateEngine sharedDateEngine] dateFromString:self.expiredDate];
    CGSize s = [self.maskName sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];
    eCardNameLabel.frame = CGRectMake(kMarginX, 15, screentWith - 15 * 2, s.height);
    eCardNameLabel.text = self.maskName;
    if (self.segmentIndex == 0) {
        if ([self.remainCount intValue] > 0) {
            NSDate *lateDate = [NSDate date];
            result = [dd compare:lateDate];
            if (result == NSOrderedDescending) {
                eCardNameLabel.textColor = [UIColor r:55 g:197 b:1];
            } else { //过期，灰色
                eCardNameLabel.textColor = [UIColor r:149 g:149 b:149];
            }
        } else {
            eCardNameLabel.textColor = [UIColor r:149 g:149 b:149];
        }
    } else {
        eCardNameLabel.textColor = [UIColor r:149 g:149 b:149];
    }

    eCardIdLabel.frame = CGRectMake(kMarginX, CGRectGetMaxY(eCardNameLabel.frame) + 3, screentWith - 15 * 2, 15);
    eCardIdLabel.text = [NSString stringWithFormat:@"券号：%@", self.couponId];
    eCardExpiredLabel.frame = CGRectMake(kMarginX, CGRectGetMaxY(eCardIdLabel.frame) + 2, screentWith - 15 * 2, 15);
    eCardExpiredLabel.text = [NSString stringWithFormat:@"有效期至：%@", [[DateEngine sharedDateEngine] shortDateStringFromDateNYR:dd]];

    selectImg.frame = CGRectMake(screentWith - 55, (CGRectGetMaxY(eCardExpiredLabel.frame) + 15) * 0.5 - 10, 20, 20);

    line.frame = CGRectMake(0, CGRectGetMaxY(eCardExpiredLabel.frame) + 15, screentWith, 1);
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;

    if (_isSelect) {
        selectImg.image = [UIImage imageNamed:@"coupon_select_icon"];
    } else {
        selectImg.image = [UIImage imageNamed:@"coupon_no_select"];
    }
}

@end
