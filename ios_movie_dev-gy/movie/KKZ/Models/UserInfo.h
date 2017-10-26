//
//  UserInfo.h
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserDetail.h"
#import "Share.h"
#import "UserGroup.h"

/**
 用户信息 体重、爱好等
 */
@interface UserInfo : UserDetail
@property (nonatomic, copy) NSString *detailId;

@property (nonatomic, copy) NSNumber *weight;

@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSNumber *gradeId;
@property (nonatomic, copy) UserGroup *group;
@property (nonatomic, copy) NSNumber *groupId;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *hobbyMovieType;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *oftenCinema;
@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, strong) Share *share;
@property (nonatomic, copy) NSString *signature;


@end
