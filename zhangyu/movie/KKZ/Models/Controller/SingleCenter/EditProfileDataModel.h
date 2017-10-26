//
//  EditProfileDataModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditProfileDataModel : NSObject

/**
 *  身高数组
 *
 *  @return
 */
+ (NSMutableArray *)heightArray;

/**
 *  体重数组
 *
 *  @return
 */
+ (NSMutableArray *)weightArray;

/**
 *  职业数组
 *
 *  @return
 */
+ (NSMutableArray *)jobArray;

/**
 *  爱好数组
 *
 *  @return
 */
+ (NSMutableArray *)hobbyArray;

/**
 *  城市名称列表
 *
 *  @return
 */
+ (NSMutableArray *)cityNameArray;

/**
 *  影片类型数组
 *
 *  @return 
 */
+ (NSMutableArray *)movieTypeArray;

/**
 *  性别数组
 *
 *  @return
 */
+ (NSMutableArray *)genderArray;

/**
 *  通过城市名字获取城市Id
 *
 *  @param cityName
 *
 *  @return
 */
+(NSString *)getCityIdByCityName:(NSString *)cityName;

/**
 *  通过字符串获取索引
 *
 *  @param index
 *
 *  @return
 */
+ (NSString *)getGenderIndex:(NSString *)genderString;

/**
 *  通过性别索引获取字符串
 *
 *  @param sex
 *
 *  @return
 */
+ (NSString *)getGenderStringByIndex:(int)sex;

@end
