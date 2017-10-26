//
//  MoviePoint.h
//  KoMovie
//
//  Created by yaojinhai on 13-4-25.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//点击“评”。抠评价

#import "Model.h"


@interface MoviePoint : Model

@property (nonatomic, assign) unsigned int pointId;
@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * score;//5星
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * typeName;

//没用
+ (MoviePoint *)getMoviePointWithId:(unsigned int)pointId;
- (void)updateDataFromDict:(NSDictionary *)dict;
@end
