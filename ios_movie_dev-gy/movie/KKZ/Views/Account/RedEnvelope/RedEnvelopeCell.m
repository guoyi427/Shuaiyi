//
//  我的 - 我的红包 页面列表
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RedEnvelopeCell.h"

#import "DateEngine.h"
#import "UIConstants.h"

@implementation RedEnvelopeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabelText = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screentWith - 115, 40)];
        titleLabelText.backgroundColor = [UIColor clearColor];
        titleLabelText.text = @"";
        titleLabelText.numberOfLines = 0;
        titleLabelText.textColor = [UIColor blackColor];
        titleLabelText.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLabelText];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 115, 25, 100, 15)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor r:100 g:100 b:100];
        titleLabel.hidden = NO;
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLabel];

        aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 90, 45, 75, 15)];
        aboutLabel.backgroundColor = [UIColor clearColor];
        aboutLabel.textColor = [UIColor r:100 g:100 b:100];
        aboutLabel.hidden = NO;
        aboutLabel.textAlignment = NSTextAlignmentRight;
        aboutLabel.text = @"";
        aboutLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:aboutLabel];

        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 45, 15)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = [UIColor r:150 g:150 b:150];
        statusLabel.hidden = NO;
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.text = @"";
        statusLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:statusLabel];

        validateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + 45 + 10, 65, 280 - 45, 15)];
        validateLabel.backgroundColor = [UIColor clearColor];
        validateLabel.textColor = [UIColor r:150 g:150 b:150];
        validateLabel.hidden = NO;
        validateLabel.textAlignment = NSTextAlignmentLeft;
        validateLabel.font = [UIFont systemFontOfSize:14];
        validateLabel.text = @"";
        [self addSubview:validateLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 94, screentWith - 15 * 2, 1)];
        [self addSubview:line];
        line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.7];
    }
    return self;
}

- (void)updateLayout {
    if ([self.myRedCoupon.note isEqualToString:@"<null>"]) {
        titleLabelText.text = @"";
    } else {
        titleLabelText.text = self.myRedCoupon.note;
    }

    titleLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.myRedCoupon.redRemainAmount floatValue]];
    statusLabel.text = self.myRedCoupon.status;
    if ([self.myRedCoupon.sourceTypeStr isEqualToString:@"<null>"]) {

    } else {
        aboutLabel.text = self.myRedCoupon.sourceTypeStr;
    }

    if ([self.myRedCoupon.status isEqualToString:@"可用"]) {
        statusLabel.textColor = [UIColor r:0 g:204 b:0];
        titleLabel.textColor = kUIColorOrange;
    } else if ([self.myRedCoupon.status isEqualToString:@"已使用"]) {
        statusLabel.textColor = [UIColor r:180 g:180 b:180];
        titleLabel.textColor = [UIColor r:150 g:150 b:150];
    } else if ([self.myRedCoupon.status isEqualToString:@"已过期"]) {
        statusLabel.textColor = [UIColor r:180 g:180 b:180];
        titleLabel.textColor = [UIColor r:150 g:150 b:150];
    }
    NSDate *beginD = [[DateEngine sharedDateEngine] dateFromString:self.myRedCoupon.redUtimeStart];
    NSDate *endD = [[DateEngine sharedDateEngine] dateFromString:self.myRedCoupon.redUtimeEnd];

    validateLabel.text = [NSString stringWithFormat:@"有效期:%@至%@", [[DateEngine sharedDateEngine] stringFromDate:beginD withFormat:@"YYYY-M-d"], [[DateEngine sharedDateEngine] stringFromDate:endD withFormat:@"YYYY-M-d"]]; //@"有效期：2014年10月5日至2014年12月5日";
}

@end
