//
//  Gallery.h
//  KoMovie
//
//  Created by zhoukai on 3/7/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
// 电影海报，DB版 MovieGallery已废弃

#import <Foundation/Foundation.h>

@interface Gallery : NSObject

@property (nonatomic, strong) NSString * movieId;
@property (nonatomic, strong) NSString * imageSmall;
@property (nonatomic, strong) NSString * imageBig;

- (Gallery*)initWithDict:(NSDictionary *)dict;

@end
