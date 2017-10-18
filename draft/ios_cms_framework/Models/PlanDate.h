//
//  PlanDate.h
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PlanDate : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *showDate;
@property (nonatomic, strong)NSNumber *planCount;


@end
