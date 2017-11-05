//
//  电影详情页面电影简介的cell
//
//  Created by da zhang on 11-5-12.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieIntroCell.h"

#import "Constants.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngine.h"
#import "KKZTextUtility.h"

static const CGFloat kFontSize = 15;
static const CGFloat kMarginX = 15;

@implementation MovieIntroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        whiteBg = [[UIView alloc] initWithFrame:CGRectZero];
        whiteBg.backgroundColor = [UIColor whiteColor];
        whiteBg.userInteractionEnabled = YES;
        [self addSubview:whiteBg];

        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        introLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 12, screentWith - kMarginX * 2, kFontSize * 5)];
        introLabel.backgroundColor = [UIColor clearColor];
        introLabel.textColor = [UIColor r:100 g:100 b:100];
        introLabel.font = [UIFont systemFontOfSize:kFontSize];
        introLabel.numberOfLines = 0;
        [self addSubview:introLabel];

        unfoldLbl = [[UIImageView alloc] init];
        unfoldLbl.image = [UIImage imageNamed:@"cinemaDetail_arrow"];
        [self addSubview:unfoldLbl];
        [unfoldLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];

        UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 5)];
        topline.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:topline];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:line];
    }
    return self;
}

- (void)updateLayout {
    if (!self.isExpand) {
        //        CGSize introSizeMin = [self.movieIntro sizeWithFont:[UIFont systemFontOfSize:kFontSize]
        //                                          constrainedToSize:CGSizeMake(screentWith - Margin * 2, kFontSize * 5)
        //                                              lineBreakMode:NSLineBreakByTruncatingTail];

        //        CGRect rect = [self.movieIntro
        //                boundingRectWithSize:CGSizeMake(screentWith - kMarginX * 2, kFontSize * 5)
        //                             options:NSStringDrawingUsesLineFragmentOrigin
        //                          attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kFontSize] }
        //                             context:nil];
        //        CGSize introSizeMin = rect.size;

        CGSize introSizeMin = [KKZTextUtility
                measureText:self.movieIntro
                       size:CGSizeMake(screentWith - kMarginX * 2, kFontSize * 5)
                       font:[UIFont systemFontOfSize:kFontSize]];

        introLabel.frame = CGRectMake(kMarginX, 12, screentWith - kMarginX * 2, introSizeMin.height);
//        unfoldLbl.frame = CGRectMake(0, CGRectGetMaxY(introLabel.frame), screentWith, 35);
        line.frame = CGRectMake(0, 12 + introSizeMin.height + 35 - 1, screentWith, 1);
        whiteBg.frame = CGRectMake(0, 0, screentWith, 12 + introSizeMin.height + 35);
    } else {
        //        CGSize introSizeMax = [self.movieIntro sizeWithFont:[UIFont systemFontOfSize:kFontSize]
        //                                          constrainedToSize:CGSizeMake(screentWith - Margin * 2, MAXFLOAT)
        //                                              lineBreakMode:NSLineBreakByTruncatingTail];

        //        CGRect rect = [self.movieIntro
        //                boundingRectWithSize:CGSizeMake(screentWith - kMarginX * 2, MAXFLOAT)
        //                             options:NSStringDrawingUsesLineFragmentOrigin
        //                          attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kFontSize] }
        //                             context:nil];
        //        CGSize introSizeMax = rect.size;

        CGSize introSizeMax = [KKZTextUtility
                measureText:self.movieIntro
                       size:CGSizeMake(screentWith - kMarginX * 2, MAXFLOAT)
                       font:[UIFont systemFontOfSize:kFontSize]];

        introLabel.frame = CGRectMake(kMarginX, 12, screentWith - kMarginX * 2, introSizeMax.height);
//        unfoldLbl.frame = CGRectMake(0, CGRectGetMaxY(introLabel.frame), screentWith, 35);
        line.frame = CGRectMake(0, 12 + introSizeMax.height + 35 - 1, screentWith, 1);
        whiteBg.frame = CGRectMake(0, 0, screentWith, 12 + introSizeMax.height + 35);
    }
    introLabel.text = self.movieIntro;
}

- (float)heightWithCellState:(BOOL)isExpand {
    float positionY = 12.0;

    if (!isExpand) {
        //        CGSize introSizeMin = [self.movieIntro sizeWithFont:[UIFont systemFontOfSize:kFontSize]
        //                                          constrainedToSize:CGSizeMake(screentWith - Margin * 2, kFontSize * 5)
        //                                              lineBreakMode:NSLineBreakByTruncatingTail];

        //        CGRect rect = [self.movieIntro
        //                boundingRectWithSize:CGSizeMake(screentWith - kMarginX * 2, kFontSize * 5)
        //                             options:NSStringDrawingUsesLineFragmentOrigin
        //                          attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kFontSize] }
        //                             context:nil];
        //        CGSize introSizeMin = rect.size;

        CGSize introSizeMin = [KKZTextUtility
                measureText:self.movieIntro
                       size:CGSizeMake(screentWith - kMarginX * 2, kFontSize * 5)
                       font:[UIFont systemFontOfSize:kFontSize]];

        positionY += introSizeMin.height;
        unfoldLbl.transform = CGAffineTransformMakeRotation(0);
    } else {
        //        CGSize introSizeMax = [self.movieIntro sizeWithFont:[UIFont systemFontOfSize:kFontSize]
        //                                          constrainedToSize:CGSizeMake(screentWith - Margin * 2, MAXFLOAT)
        //                                              lineBreakMode:NSLineBreakByTruncatingTail];

        //        CGRect rect = [self.movieIntro
        //                boundingRectWithSize:CGSizeMake(screentWith - kMarginX * 2, MAXFLOAT)
        //                             options:NSStringDrawingUsesLineFragmentOrigin
        //                          attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kFontSize] }
        //                             context:nil];
        //        CGSize introSizeMax = rect.size;

        CGSize introSizeMax = [KKZTextUtility
                measureText:self.movieIntro
                       size:CGSizeMake(screentWith - kMarginX * 2, MAXFLOAT)
                       font:[UIFont systemFontOfSize:kFontSize]];

        positionY += introSizeMax.height;
        unfoldLbl.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return positionY + 35;
}

@end
