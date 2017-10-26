//
//  BindPhoneViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UnbindTypeWeixin = 1000,
    UnbindTypePhone,
    UnbindTypeQQ,
    UnbindTypeWeibo,
} UnbindType;

@interface BindPhoneViewModel : NSObject

/**
 *  是否是有效的电话号码
 *
 *  @param phoneNum
 *
 *  @return
 */
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum;

/**
 *  是否是有效的验证码
 *
 *  @param codeNum
 *
 *  @return
 */
+ (BOOL)isValidCodeNumber:(NSString *)codeNum;

/**
 *  是否是有效的密码
 *
 *  @param passNum
 *
 *  @return
 */
+ (BOOL)isValidPassWordNumber:(NSString *)passNum;

/**
 *  通过绑定类型获得到对应的名字
 *
 *  @param bindType
 *
 *  @return
 */
+ (NSString *)getTypeNameByUnbindType:(UnbindType)bindType;

/**
 *  通过绑定类型得到对应的图片
 *
 *  @param bindType
 *
 *  @return
 */
+ (NSString *)getTypeImageByUnbindType:(UnbindType)bindType;

/**
 *  将输入的字符串加密
 *
 *  @param inputString
 *
 *  @return
 */
+ (NSString *)getSecretStringByString:(NSString *)inputString;

@end
