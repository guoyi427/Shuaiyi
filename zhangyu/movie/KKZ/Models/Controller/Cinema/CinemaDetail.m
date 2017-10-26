//
//  CinemaDetail.m
//  KoMovie
//
//  Created by Albert on 9/5/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaDetail.h"

#import "LocationEngine.h"
#import "Ticket.h"

@implementation CinemaDetail
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)isBuyJSONTransformer {
  return [NSValueTransformer
      valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)promotionsJSONTransformer {
  return [MTLJSONAdapter arrayTransformerWithModelClass:[Promotion class]];
}



/**
 minPrice处理，值有数字和字符串两种类型

 @return    NSValueTransformer
 */
+ (NSValueTransformer *) minPriceJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *num = value;
            return num.stringValue;
        }else{
            return value;
        }
    }];
}

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        CinemaDetail *a_cinema = object;
        if ([a_cinema.cinemaId isEqualToNumber:self.cinemaId]) {
            return YES;
        }
    }

  return NO;
}

- (NSNumber *)distanceMetres {
  if (_distanceMetres != nil) {
    return _distanceMetres;
  }

  if ([LocationEngine sharedLocationEngine].latitude &&
      [LocationEngine sharedLocationEngine].longitude) {
    double meters = [[LocationEngine sharedLocationEngine]
        metersFormPositonWithLatitude:self.latitude.doubleValue
                            longitude:self.longitude.doubleValue
               toPositionWithLatitude:[LocationEngine sharedLocationEngine]
                                          .latitude
                            longitude:[LocationEngine sharedLocationEngine]
                                          .longitude];
    _distanceMetres = [[NSNumber alloc] initWithFloat:meters];
  } else {
    _distanceMetres = [[NSNumber alloc] initWithFloat:99999999999];
  }

  return _distanceMetres;
}

- (PlatForm)platformType {
    return KKZPlateform(self.platform);
}

@end
