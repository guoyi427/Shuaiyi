//
//  KotaFilm.h
//  KoMovie
//
//  Created by zhoukai on 3/20/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface KotaFilmNew:Model

@property (nonatomic,retain)NSNumber *index;
@property (nonatomic, retain) NSString * posterPath0;
@property (nonatomic, assign) int filmId;
@property (nonatomic, retain) NSString * filmName;
@property (nonatomic,retain) NSString *isOK;

@end
