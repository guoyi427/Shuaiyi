//
//  NewLoginViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "UserLogin.h"

@interface NewLoginViewModel : NSObject

/**
 *  将登录的信息插入到数据库
 *
 *  @param model
 */
+ (void)insertLoginDataIntoDataBase:(UserLogin *)model;

/**
 *  从数据库里获取用户登录信息
 *
 *  @return 返回的用户个人信息
 */
+ (UserLogin *)selectLoginDataFromDataBase;

/**
 *  从数据库里删除登录信息
 */
+ (void)deleteLoginDataFromDataBase;

/**
 *  更新数据库的登录信息的key和value
 *
 *  @param key
 *  @param value
 */
+ (void)updateLoginModelKey:(NSString *)key
                 modelValue:(NSString *)value;

/**
 *  单例对象
 *
 *  @return
 */
+ (NewLoginViewModel *)sharedLoginEngine;



@end
