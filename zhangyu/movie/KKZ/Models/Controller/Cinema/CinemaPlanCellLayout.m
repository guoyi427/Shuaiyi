//
//  CinemaPlanCellLayout.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CinemaPlanCellLayout.h"
#import "KKZUtility.h"

@implementation CinemaPlanCellLayout

+ (CGFloat)getCurrentMaxMovieTypeWidth {
    return currentMaxMovieTypeWidth;
}

+ (CGFloat)getCurrentMaxDiscountWidth {
    return currentMaxDiscountWidth;
}

+ (void)resetMaxWidthVariable {
    currentMaxMovieTypeWidth = 0;
    currentMaxDiscountWidth = 0;
}

- (void)updateCinemaPlanCellLayout:(Ticket *)ticket {
    
    //电影类型的文本计算
    NSString *screenDesc0 = ticket.screenType;
    NSString *screenDesc = @"";
    NSString *language = @"";
    if (![KKZUtility stringIsEmpty:ticket.language]) {
        language = [NSString stringWithFormat:@"/%@",ticket.language];
    }
    if (![KKZUtility stringIsEmpty:screenDesc0]) {
        screenDesc = [screenDesc0 uppercaseString];
    }
    NSString *finalString = [NSString stringWithFormat:@"%@%@",screenDesc, language];
    CGSize movieTypeSize = [KKZUtility customTextSize:[UIFont systemFontOfSize:movieTypeFont]
                                                 text:finalString
                                                 size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.movieTypeSize = CGSizeMake(movieTypeSize.width + 5, movieTypeSize.height);
    if (currentMaxMovieTypeWidth < self.movieTypeSize.width) {
        currentMaxMovieTypeWidth = self.movieTypeSize.width;
    }
    
    //电影厅数的文本计算
    NSString *hallStr = @"";
    if (![KKZUtility stringIsEmpty:ticket.hallName]) {
        hallStr = ticket.hallName;
    }
    self.movieHallSize = [KKZUtility customTextSize:[UIFont systemFontOfSize:movieHallFont]
                                               text:hallStr
                                               size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    if (currentMaxMovieTypeWidth < self.movieHallSize.width) {
        currentMaxMovieTypeWidth = self.movieHallSize.width;
    }
    
    //排期价格标签(有可能价格标签的区域显示的是排期标签，所以判断一下计算 )
    NSString *planTitle = [NSString stringWithFormat:@"￥%.2f",[ticket.standardPrice floatValue]];
    if (![KKZUtility stringIsEmpty:ticket.planShortTitle]) {
        planTitle = ticket.planShortTitle;
    }
    CGSize discountSize = [KKZUtility customTextSize:[UIFont systemFontOfSize:discountFont]
                                             text:planTitle
                                             size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.planLableSize = CGSizeMake(discountSize.width + 5, discountSize.height);
    if (currentMaxDiscountWidth < self.planLableSize.width) {
        currentMaxDiscountWidth = self.planLableSize.width;
    }
    
    //买票的价钱
    NSString *priceTitle = [NSString stringWithFormat:@"￥%.2f",[ticket.vipPrice floatValue]];;
    CGSize priceSize = [KKZUtility customTextSize:[UIFont systemFontOfSize:priceLabelFont]
                                             text:priceTitle
                                             size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN)];
    self.priceLabelSize = CGSizeMake(priceSize.width + 5, priceSize.height + 5);
    if (currentMaxDiscountWidth < self.priceLabelSize.width) {
        currentMaxDiscountWidth = self.priceLabelSize.width;
    }
}

@end
