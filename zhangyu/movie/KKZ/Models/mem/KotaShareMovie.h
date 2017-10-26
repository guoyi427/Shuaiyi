//
//  KotaShareMovie.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KotaShareMovie : NSObject

@property (nonatomic,strong)NSNumber *man;
@property (nonatomic,strong)NSNumber *women;
@property (nonatomic,strong)NSNumber *successCount;
@property (nonatomic, assign) int filmId;
@property (nonatomic, copy) NSString *posterPath;
@property (nonatomic, copy) NSString *movieName;

@end
