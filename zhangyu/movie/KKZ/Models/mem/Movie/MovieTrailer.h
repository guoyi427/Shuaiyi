//
//  MovieTrailer.h
//  KoMovie
//
//  Created by gree2 on 21/5/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "Model.h"

@interface MovieTrailer : Model

@property (nonatomic, assign) int movieId;
@property (nonatomic, assign) int trailerId;
@property (nonatomic, retain) NSString * trailerCover;
@property (nonatomic, retain) NSString * trailerPath;
@property (nonatomic, assign) int type;

+ (MovieTrailer *)getMovieTrailerWithId:(int)movieId;

@end
