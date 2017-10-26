//
//  CinemaFeature.h
//  Cinephile
//
//  Created by KKZ on 16/7/19.
//  Copyright © 2016年 Kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CinemaFeature : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *tag;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) NSNumber *cinemaId;
@property(nonatomic, strong) NSNumber *level;
@property(nonatomic, strong) NSNumber *type;

@end
