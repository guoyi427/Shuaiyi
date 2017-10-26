//
//  电影详情 - 查看全部演职员 演员Cell
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "StarCell.h"

#import "UIImageVIew+WebURL.h"

static const CGFloat kMarginX = 15;

@implementation StarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 75)];
        whiteBg.backgroundColor = [UIColor clearColor];
        whiteBg.userInteractionEnabled = YES;
        [self addSubview:whiteBg];

        self.backgroundColor = [UIColor whiteColor];

        starHeaderImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginX, 11, 53, 53)];
        starHeaderImg.backgroundColor = [UIColor clearColor];
        starHeaderImg.clipsToBounds = YES;
        starHeaderImg.contentMode = UIViewContentModeScaleAspectFill;
        starHeaderImg.layer.masksToBounds = YES;
        starHeaderImg.layer.cornerRadius = 53 / 2.0f;
        [self addSubview:starHeaderImg];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 150, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor r:50 g:50 b:50];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameLabel];

        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 35, 28, 20, 20)];
        arrowImg.image = [UIImage imageNamed:@"right_arrow_gray"];
        arrowImg.backgroundColor = [UIColor clearColor];
        [self addSubview:arrowImg];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 74, screentWith, 1)];
        line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:line];
    }
    return self;
}

- (void)updateLayout {
    [starHeaderImg loadImageWithURL:self.starHeadUrl andSize:ImageSizeTiny defaultImagePath:@"avatarRImg"];
    nameLabel.text = self.titleStr;
}

@end
