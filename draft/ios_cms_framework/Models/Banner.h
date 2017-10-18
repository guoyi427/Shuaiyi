//
//  Banner.h
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Banner : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *file;
@property (nonatomic, copy)NSString *link;
@property (nonatomic, copy)NSString *title;

@end
