//
//  MySubscreberCell.m
//  KoMovie
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZUser.h"
#import "MySubscreberCell.h"

#define marginX 15
#define marginY 17
#define titleToTop 22
#define marginImgToTitle 18
#define marginTitleToSubTitle 10
#define titleFont 14
#define subTitleFont 12
#define arrowMargin 20
#define imgWidth 45
#define arrowVWidth 8.5
#define arrowVHeight 15.5
#define cellHeight 80

@implementation MySubscreberCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        icon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, imgWidth, imgWidth)];
        icon.layer.cornerRadius = imgWidth * 0.5;
        icon.layer.masksToBounds = YES;
        icon.backgroundColor = [UIColor clearColor];
        [self addSubview:icon];

        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + marginImgToTitle, titleToTop - 2, screentWith - marginX * 2 - CGRectGetMaxX(icon.frame), titleFont + 3)];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:titleFont];
        [self addSubview:titleLbl];

        subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + marginImgToTitle, CGRectGetMaxY(titleLbl.frame) + marginTitleToSubTitle, screentWith - marginX * 2 - CGRectGetMaxX(icon.frame) - 20, subTitleFont)];
        subTitleLbl.textColor = [UIColor blackColor];
        subTitleLbl.font = [UIFont systemFontOfSize:subTitleFont];
        [self addSubview:subTitleLbl];

        UIImageView *arrowV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - marginX - arrowVWidth, (cellHeight - arrowVHeight) * 0.5, arrowVWidth, arrowVHeight)];
        [self addSubview:arrowV];

        arrowV.image = [UIImage imageNamed:@"arrowGray"];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), cellHeight - 1, screentWith - CGRectGetMinX(titleLbl.frame), 0.5)];
        [line setBackgroundColor:[UIColor r:216 g:216 b:216]];

        [self addSubview:line];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)upLoadData {

    KKZUser *user = [KKZUser getUserWithId:self.userId];

    [icon loadImageWithURL:user.headImg andSize:ImageSizeOrign];
    titleLbl.text = user.userName;
    subTitleLbl.text = user.declaration;
}
@end
