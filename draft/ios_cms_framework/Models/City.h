//
//  City.h
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface City : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *cityid;
@property (nonatomic, copy)NSString *cityname;
@property (nonatomic, copy)NSNumber *pid;
@property (nonatomic, copy)NSString *adminlevel;
@property (nonatomic, copy)NSString *pinyin;
@property (nonatomic, copy)NSNumber *level;
@property (nonatomic, copy)NSString *lon;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSNumber *cityHot;

@property (nonatomic, copy)NSString *nameFirst; //分类的索引，A，B，C等等

@end
