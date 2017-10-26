//
//  NewCinemaDetailModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/24.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "kkzCommonModel.h"

@interface NewCinemaDetailModel : kkzCommonModel

/**
 *  影院名字
 */
@property (nonatomic, strong) NSString * cinemaName;

/**
 *  影院电话
 */
@property (nonatomic, strong) NSString * cinemaPhone;

/**
 *  影院地址
 */
@property (nonatomic, strong) NSString * cinemaAddress;

/**
 *  影院介绍
 */
@property (nonatomic, strong) NSString * cinemaIntro;

/**
 *  影院评分
 */
@property (nonatomic, assign) CGFloat point;

@end
