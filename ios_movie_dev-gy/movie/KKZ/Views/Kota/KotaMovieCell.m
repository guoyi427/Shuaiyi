//
//  KotaMovieCell.m
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//
// 约电影首页影片列表 cell
//

#import "KotaMovieCell.h"
#import "RoundCornersButton.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngine.h"
#import "Constants.h"
#import "UIConstants.h"

#define kButtonHeight 30

@implementation KotaMovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int top = 10;
        int left = kDimensControllerHPadding + kDimensMoviePosterVWidth + 13;
        
        UIImageView * shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kDimensControllerHPadding - 3, top - 3, kDimensMoviePosterVWidth + 6, kDimensMoviePosterVHeight + 6)];
        shadowImg.image = [UIImage imageNamed:@"post_black_shadow"];
        shadowImg.contentMode = UIViewContentModeScaleAspectFit;
        shadowImg.clipsToBounds = YES;
        [self addSubview:shadowImg];
        
        posterImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kDimensControllerHPadding, top, kDimensMoviePosterVWidth, kDimensMoviePosterVHeight)];
        posterImgV.contentMode = UIViewContentModeScaleAspectFill;
        posterImgV.clipsToBounds = YES;
        [self addSubview:posterImgV];
        
        UILabel *lblSuc = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 63, 12, 60, 16)];
        lblSuc.text = @"成功约会";
        [lblSuc setBackgroundColor:[UIColor clearColor]];
        lblSuc.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblSuc.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lblSuc];

        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 150 - 50 - 15, 11, 150, 16)];
        lblNum.text = @"11111";
        [lblNum setBackgroundColor:[UIColor clearColor]];
        lblNum.font = [UIFont systemFontOfSize:16];
        lblNum.textColor = [UIColor orangeColor];
        lblNum.textAlignment = NSTextAlignmentRight;
        [self addSubview:lblNum];
        
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(left, top, screentWith - 180 ,16)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        lblName.font = [UIFont systemFontOfSize:kTextSizeTitle];
        [self addSubview:lblName];
        
        
        lblMan = [[UILabel alloc] initWithFrame:CGRectMake(left, 36, 150,16)];
        [lblMan setBackgroundColor:[UIColor clearColor]];
        lblMan.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblMan.textColor = [UIColor grayColor];
        lblMan.text = @"待约男青年：";
        [self addSubview:lblMan];
        
        
        lblWoman = [[UILabel alloc] initWithFrame:CGRectMake(left, 56, 150,16)];
        [lblWoman setBackgroundColor:[UIColor clearColor]];
        lblWoman.font = [UIFont systemFontOfSize:kTextSizeContent];
        lblWoman.textColor = [UIColor grayColor];
        lblWoman.text = @"待约女青年：";
        [self addSubview:lblWoman];
        
        
        RoundCornersButton *btn = [[RoundCornersButton alloc]initWithFrame:CGRectMake(left, kDimensMoviePosterVHeight + top - kButtonHeight + 2, 85, kButtonHeight)];
            btn.cornerNum = 2;
            btn.rimWidth = 1;
            btn.rimColor = [UIColor orangeColor];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleColor = [UIColor orangeColor];
            btn.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
            btn.titleName = @"查看所有";
        
        btn.userInteractionEnabled = NO;
   
        [self addSubview:btn];
        
        
    }
    return self;
}

-(void)reloadData
{
    [posterImgV loadImageWithURL:self.posterPath andSize:ImageSizeMiddle];
    lblName.text = self.movieName;
    if ([self.manNum isEqualToString:@"(null)"]) {
        self.manNum = @"0";
    }
    
    if ([self.womanNum isEqualToString:@"(null)"]) {
        self.womanNum = @"0";
    }
    lblMan.text = [NSString stringWithFormat:@"待约男青年：%@人", self.manNum];
    lblWoman.text = [NSString stringWithFormat:@"待约女青年：%@人", self.womanNum];
    lblNum.text = self.succeedNum;
    
}


@end
