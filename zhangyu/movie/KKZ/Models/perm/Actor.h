//
//  Actor.h
//  KoMovie
//
//  Created by XuYang on 13-8-6.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Model.h"


@interface Actor : NSObject

@property (nonatomic, assign) unsigned int starId;
@property (nonatomic, copy) NSString * chineseName;
@property (nonatomic, copy) NSString * doubanId; //未知
@property (nonatomic, copy) NSString * foreignName;
@property (nonatomic, copy) NSNumber * gender;
@property (nonatomic, copy) NSNumber * hot;
@property (nonatomic, copy) NSString * imageBig;
@property (nonatomic, copy) NSString * imageSmall;
@property (nonatomic, copy) NSString * bornPlace;//出生地
@property (nonatomic, copy) NSDate   * birthday;//根据出生日期算星座
@property (nonatomic, copy) NSString * actorIntro;//演员介绍
@property (nonatomic, copy) NSString * character;//明星饰演的角色


//+ (Actor *)getActorWithId:(unsigned int)starId;

@end
