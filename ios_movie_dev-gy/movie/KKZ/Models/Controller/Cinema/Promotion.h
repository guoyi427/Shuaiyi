//
//  Promotion.h
//  KoMovie
//
//  Created by Albert on 9/6/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>
/**
 *  促销
 */
@interface Promotion : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSString *remarks;

@property(nonatomic, copy) NSString *beginTime;

@property(nonatomic, copy) NSString *promotionContent;

@property(nonatomic, copy) NSString *shortTitle;

@property(nonatomic, copy) NSString *promotionTitle;

@property(nonatomic, copy) NSNumber *promotionId;

@property(nonatomic, copy) NSString *promotionTitleName;

@property(nonatomic, copy) NSString *cinemaShortTitle;

@end
