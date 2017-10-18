//
//  CardCinemaList.h
//  CIASMovie
//
//  Created by avatar on 2017/3/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardCinemaList : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSNumber *page;
@property (nonatomic, strong)NSNumber *pageSize;

@property (nonatomic, strong)NSArray *rows;

@end
