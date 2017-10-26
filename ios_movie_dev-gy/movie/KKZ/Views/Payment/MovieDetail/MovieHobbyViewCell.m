//
//  电影详情页面的周边Cell
//
//  Created by KKZ on 15/11/4.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieHobbyViewCell.h"
#import "MovieHobbyModel.h"

#import "UIConstants.h"

@implementation MovieHobbyViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        hobbyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 85, 80)];
        hobbyImgV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:hobbyImgV];
        hobbyImgV.clipsToBounds = YES;
        hobbyTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(hobbyImgV.frame), 15, screentWith - 15 - 10 - CGRectGetMaxX(hobbyImgV.frame), 14)];
        
        hobbyTitleLbl.font = [UIFont systemFontOfSize:17];
        
        [hobbyTitleLbl setBackgroundColor:[UIColor clearColor]];
        
        hobbyTitleLbl.textColor = [UIColor blackColor];
        hobbyTitleLbl.text = @"";
        [self addSubview:hobbyTitleLbl];
        
        hobbyPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(hobbyImgV.frame), CGRectGetMaxY(hobbyTitleLbl.frame) + 12, 50, 20)];
        
        hobbyPriceLbl.font = [UIFont systemFontOfSize:20];
        
        [hobbyPriceLbl setBackgroundColor:[UIColor clearColor]];
        
        hobbyPriceLbl.textColor = kUIColorOrange;
        hobbyPriceLbl.text = @"";
        
        [self addSubview:hobbyPriceLbl];
        
        hobbyPriceLblY = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(hobbyPriceLbl.frame), CGRectGetMaxY(hobbyTitleLbl.frame) + 12, 17, 20)];
        
        hobbyPriceLblY.font = [UIFont systemFontOfSize:15];
        
        [hobbyPriceLblY setBackgroundColor:[UIColor clearColor]];
        
        hobbyPriceLblY.textColor = kUIColorOrange;
        hobbyPriceLblY.text = @"元";
        
        [self addSubview:hobbyPriceLblY];
        
        hobbyPromotionPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 + CGRectGetMaxX(hobbyPriceLbl.frame), CGRectGetMaxY(hobbyTitleLbl.frame) + 12, 100, 20)];
        
        hobbyPromotionPriceLbl.font = [UIFont systemFontOfSize:13];
        
        [hobbyPromotionPriceLbl setBackgroundColor:[UIColor clearColor]];
        
        hobbyPromotionPriceLbl.textColor = [UIColor grayColor];
        hobbyPromotionPriceLbl.text = @"元";
        [self addSubview:hobbyPromotionPriceLbl];
        
        lineCenter = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(hobbyPromotionPriceLbl.frame), CGRectGetMaxY(hobbyTitleLbl.frame) + 12 + 10, hobbyPromotionPriceLbl.frame.size.width, 1)];
        [lineCenter setBackgroundColor:[UIColor grayColor]];
        [self addSubview:lineCenter];
        
        checkDetial = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(hobbyImgV.frame), CGRectGetMaxY(hobbyPromotionPriceLbl.frame) + 10, 52, 16)];
        
        checkDetial.font = [UIFont systemFontOfSize:13];
        
        [checkDetial setBackgroundColor:[UIColor clearColor]];
        
        checkDetial.textColor = kUIColorOrange;
        checkDetial.text = @"查看详情";
        [self addSubview:checkDetial];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkDetial.frame), CGRectGetMaxY(hobbyPromotionPriceLbl.frame) + 10 + 3, 10, 10)];
        [imgV setImage:[UIImage imageNamed:@"arrowOrange"]];
        [self addSubview:imgV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 100 - 1, screentWith, 1)];
        line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:line];
    }
    return self;
}

-(void)setHobbyModel:(MovieHobbyModel *)hobbyModel
{
    _hobbyModel = hobbyModel;
    
    [hobbyImgV loadImageWithURL:hobbyModel.picUrl andSize:ImageSizeSmall];
    
    hobbyTitleLbl.text = hobbyModel.title;
    
    CGFloat hobbyPriceP = [hobbyModel.promotionPrice floatValue];
    NSString *hobbyPriceStr = [NSString stringWithFormat:@"%.2f", hobbyPriceP];
    hobbyPriceLbl.text = hobbyPriceStr;
    
    CGSize r = [hobbyPriceStr sizeWithFont:[UIFont systemFontOfSize:20]];
    
    CGRect f = hobbyPriceLbl.frame;
    f.size.width = r.width;
    hobbyPriceLbl.frame = f;
    
    f = hobbyPriceLblY.frame;
    f.origin.x = CGRectGetMaxX(hobbyPriceLbl.frame);
    hobbyPriceLblY.frame = f;
    
    CGFloat hobbyPromotionPriceP = [hobbyModel.price floatValue];
    NSString *hobbyPromotionPriceLblStr = [NSString stringWithFormat:@"%.2f元", hobbyPromotionPriceP];
    CGSize r1 = [hobbyPromotionPriceLblStr sizeWithFont:[UIFont systemFontOfSize:13]];
    hobbyPromotionPriceLbl.text = hobbyPromotionPriceLblStr;
    
    f = hobbyPromotionPriceLbl.frame;
    f.origin.x = CGRectGetMaxX(hobbyPriceLblY.frame) + 10;
    f.size.width = r1.width;
    hobbyPromotionPriceLbl.frame = f;
    
    f = lineCenter.frame;
    f.origin.x = CGRectGetMinX(hobbyPromotionPriceLbl.frame);
    f.size.width = hobbyPromotionPriceLbl.frame.size.width;
    lineCenter.frame = f;
    
}


- (void)updateMovieHobbyCell {
}

@end
