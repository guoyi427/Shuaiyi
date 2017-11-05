//
//  UserCenterMovieViewController.h
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

typedef enum : NSUInteger {
    UserCenterMovieType_WantSee,
    UserCenterMovieType_Score,
} UserCenterMovieType;

@interface UserCenterMovieViewController : CommonViewController

@property (nonatomic, assign) UserCenterMovieType type;

@end
