//
//  MovieListForCityTask.h
//  KoMovie
//
//  Created by renzc on 16/9/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "NetworkTask.h"

@interface MovieListForCityTask : NetworkTask

@property(nonatomic, strong) NSString *beginData;
@property(nonatomic, strong) NSString *cityId;
@property(nonatomic, assign) NSInteger pageNum;

@end
