//
//  显示积分信息的View
//
//  Created by KKZ on 15/12/24.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZIntegralView.h"

#import "KKZTextUtility.h"
#import "UIColor+Hex.h"

@interface KKZIntegralView () {

    UIImageView *alertImgView;
    UILabel *titleLabel;
}

@end

@implementation KKZIntegralView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = AHEX(0.5, @"#000000");

        alertImgView = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 40) * 0.5, 15, 40, 40)];
        alertImgView.image = [UIImage imageNamed:@"failure"];
        [self addSubview:alertImgView];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(alertImgView.frame), screentWith - 15 * 2, 15)];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"亲，还没有你要找的信息，请稍候~";
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];

        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)updateWithTitle:(NSString *)title
               andScore:(NSString *)score
            andIconPath:(NSString *)iconPath {

    [alertImgView loadImageWithURL:iconPath andSize:ImageSizeSmall];

    titleLabel.text = [NSString stringWithFormat:@"%@", title];

    CGSize swith = [KKZTextUtility measureText:titleLabel.text
                                          size:CGSizeMake(MAXFLOAT, 15)
                                          font:[UIFont systemFontOfSize:14]];
    CGSize sheight = [KKZTextUtility measureText:titleLabel.text
                                            size:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)
                                            font:[UIFont systemFontOfSize:14]];

    //    CGSize swith = [titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14]
    //                               constrainedToSize:CGSizeMake(MAXFLOAT, 15)
    //                                   lineBreakMode:NSLineBreakByTruncatingTail];
    //
    //    CGSize sheight = [titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14]
    //                                 constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)
    //                                     lineBreakMode:NSLineBreakByTruncatingTail];

    CGFloat titleLabelWith = swith.width + 8;
    if (titleLabelWith + 15 * 2 <= screentWith - 15 * 2) {

        titleLabel.frame = CGRectMake(15, CGRectGetMaxY(alertImgView.frame) + 15, titleLabelWith, 15);
        self.frame = CGRectMake((screentWith - titleLabelWith - 15 * 2) * 0.5, (screentHeight - 200) * 0.5, 15 * 2 + titleLabelWith, 15 + 40 + 15 + 15 + 15);

    } else {
        titleLabel.frame = CGRectMake(15, CGRectGetMaxY(alertImgView.frame) + 15, screentWith - 15 * 2 * 2, sheight.height);
        self.frame = CGRectMake(15, (screentHeight - 200) * 0.5, screentWith - 15 * 2, 15 + 40 + 15 + sheight.height + 15);
    }

    alertImgView.frame = CGRectMake((self.frame.size.width - 40) * 0.5, 15, 40, 40);
}

@end
