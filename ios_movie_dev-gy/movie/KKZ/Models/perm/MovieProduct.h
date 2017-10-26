//
//  MovieProduct.h
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface MovieProduct : Model

@property (nonatomic, assign) unsigned int productId;
@property (nonatomic, strong) NSString * productImg;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productIntro;
@property (nonatomic, strong) NSString * productUrl; //购买链接
@property (nonatomic, strong) NSNumber * hot;//热度，喜欢的数量，后台设置用来排序
@property (nonatomic, strong) NSNumber * isBanner;//没用。1
@property (nonatomic, strong) NSString * bannerImage;//没用

@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, strong) NSString * productPrice;

+ (MovieProduct *)getProductWithId:(unsigned int)productId;

@end
