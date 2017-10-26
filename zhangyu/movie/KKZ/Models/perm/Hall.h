//
//  Hall.h
//  KKZ
//
//  Created by zhang da on 11-11-4.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//


@interface Hall : NSObject

@property (nonatomic, assign) int cinemaId;
@property (nonatomic, strong) NSString * hallId;

@property (nonatomic, strong) NSNumber * maxScreenRow;
@property (nonatomic, strong) NSNumber * maxScreenColumn;

@end
