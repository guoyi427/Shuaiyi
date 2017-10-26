//
//  DiscoverTabs.h
//  KoMovie
//
//  Created by KKZ on 15/8/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "Model.h"

@interface DiscoverTabs : Model
@property (nonatomic, assign) NSString * tab;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name; //未知



+ (DiscoverTabs *)getTabWithId:(NSString *)num;
@end
