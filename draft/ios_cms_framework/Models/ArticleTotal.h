//
//  ArticleTotal.h
//  CIASMovie
//
//  Created by avatar on 2017/4/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ArticleTotal : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSArray *rows;

@end
