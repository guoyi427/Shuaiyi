//
//  CinemaMovieModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/4/12.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaMovieModel : NSObject

/**
 *  电影评分
 */
@property (nonatomic, assign) CGFloat score;

/**
 *  电影名字
 */
@property (nonatomic, strong) NSString *movieName;

@end
