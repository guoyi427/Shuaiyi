//
//  我的 - 我的红包 页面列表的header view
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RedEnvelopeHeaderView.h"

#import "DataEngine.h"
#import "DateEngine.h"
#import "KKZUser.h"
#import "UIConstants.h"

@implementation RedEnvelopeHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, (240.0 - 39.5) / 320 * screentWith)];
        [bgV setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgV];

        UIImage *redBgImg = [UIImage imageNamed:@"redBgTop"];
        UIImageView *redBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentWith / 640.0 * 153)];
        redBgImgV.image = redBgImg;
        [bgV addSubview:redBgImgV];

        // 头像
        UIImage *avatorImgBgY = [UIImage imageNamed:@"avatorBgY"];

        avatorImgVBg = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 56.0 / 320 * screentWith) * 0.5, (84.0 - 39.5) / 320 * screentWith, 56.0 / 320 * screentWith, 56.0 / 320 * screentWith)];
        avatorImgVBg.image = avatorImgBgY;
        [bgV addSubview:avatorImgVBg];

        avatorImgV = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 56.0 / 320 * screentWith) * 0.5 + 2, (84.0 - 39.5) / 320 * screentWith + 2, 56.0 / 320 * screentWith - 4, 56.0 / 320 * screentWith - 4)];
        avatorImgV.image = avatorImgBgY;
        [bgV addSubview:avatorImgV];
        avatorImgV.layer.cornerRadius = (56.0 / 320 * screentWith - 4) * 0.5;
        avatorImgV.clipsToBounds = YES;
        avatorImgV.contentMode = UIViewContentModeScaleAspectFit;

        nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (144.0 - 39.5) / 320 * screentWith, screentWith, 20)];
        nickNameLab.textAlignment = NSTextAlignmentCenter;
        nickNameLab.text = @"";
        nickNameLab.textColor = [UIColor blackColor];
        [nickNameLab setBackgroundColor:[UIColor clearColor]];
        nickNameLab.font = [UIFont systemFontOfSize:14];
        [bgV addSubview:nickNameLab];

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, (175.0 - 39.5) / 320 * screentWith, screentWith, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"可用余额";
        lab.textColor = [UIColor lightGrayColor];
        [lab setBackgroundColor:[UIColor clearColor]];
        lab.font = [UIFont systemFontOfSize:13];
        [bgV addSubview:lab];

        redCouponMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, (200.0 - 39.5) / 320 * screentWith, screentWith, 30)];
        redCouponMoney.textColor = kUIColorOrange;
        redCouponMoney.textAlignment = NSTextAlignmentCenter;
        [redCouponMoney setBackgroundColor:[UIColor clearColor]];
        redCouponMoney.text = @"0.00";
        redCouponMoney.font = [UIFont systemFontOfSize:30];
        [bgV addSubview:redCouponMoney];

        lab2 = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - 90) * 0.5 + 90, (200.0 - 39.5) / 320 * screentWith + 10, 20, 15)];
        lab2.text = @"元";
        lab2.textAlignment = NSTextAlignmentLeft;
        [lab2 setBackgroundColor:[UIColor clearColor]];
        lab2.textColor = [UIColor lightGrayColor];
        [bgV addSubview:lab2];

        line = [[UIView alloc] initWithFrame:CGRectMake(0, (240.0 - 39.5) / 320 * screentWith - 1, screentWith, 1)];
        [line setBackgroundColor:kUIColorDivider];
        [bgV addSubview:line];

        lastRedInfoV = [[UIView alloc] initWithFrame:CGRectMake(0, (240.0 - 39.5) / 320 * screentWith, screentWith, 60)];
        [lastRedInfoV setBackgroundColor:[UIColor r:245.0 g:245.0 b:245.0]];
        [self addSubview:lastRedInfoV];

        UILabel *lastRedInfoLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, screentWith, 60 - 8 * 2)];
        lastRedInfoLabel0.numberOfLines = 0;
        lastRedInfoLabel0.font = [UIFont systemFontOfSize:14];
        [lastRedInfoLabel0 setBackgroundColor:[UIColor r:253.0 g:249 b:187]];
        [lastRedInfoV addSubview:lastRedInfoLabel0];

        lastRedInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, screentWith - 10 * 2, 60 - 8 * 2)];
        lastRedInfoLabel.numberOfLines = 0;
        lastRedInfoLabel.font = [UIFont systemFontOfSize:14];
        [lastRedInfoLabel setBackgroundColor:[UIColor r:253.0 g:249 b:187]];
        [lastRedInfoV addSubview:lastRedInfoLabel];
    }
    return self;
}

- (void)updateLayout {
    lastRedInfoV.hidden = YES;

    [avatorImgV loadImageWithURL:[DataEngine sharedDataEngine].headImg andSize:ImageSizeMiddle imgNameDefault:@"avatarRImg"];
    nickNameLab.text = [DataEngine sharedDataEngine].userName;

    redCouponMoney.text = [NSString stringWithFormat:@"%.2f", self.redAmount];

    CGRect rect = [redCouponMoney.text
            boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:30] }
                         context:nil];

    CGRect r = lab2.frame;
    r.origin.x = screentWith * 0.5 + rect.size.width * 0.5;
    lab2.frame = r;

    if (self.lastRedCoupon) {
        lastRedInfoV.hidden = NO;
        NSDate *dat = [[DateEngine sharedDateEngine] dateFromString:self.lastRedCoupon.redUtimeEnd];
        NSString *lastDateStr = [[DateEngine sharedDateEngine] shortDateStringFromDateMdHs:dat];
        lastRedInfoLabel.text = [NSString stringWithFormat:@"您最近一笔%.2f元的红包即将于%@过期，请尽快使用！", [self.lastRedCoupon.redRemainAmount floatValue], lastDateStr];
        line.frame = CGRectMake(0, (240.0 + 60 - 39.5) / 320 * screentWith - 1, screentWith, 1);
    } else {
        line.frame = CGRectMake(0, (240.0 - 39.5) / 320 * screentWith - 1, screentWith, 1);
    }
}

@end
