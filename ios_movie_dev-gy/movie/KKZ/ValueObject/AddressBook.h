//
//  AddressBook.h
//  KoMovie
//
//  Created by zhoukai on 3/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBook : NSObject<NSCopying>

@property (nonatomic, assign) int recordID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *namePY;

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) UIImage *thumbnail;

//后台返回数据

@property (nonatomic, strong) NSString *uId;
@property (nonatomic, strong) NSString *username;//通讯录，手机号
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) int status;//status=0 未添加，status=2已经添加
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *age;//字符串
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) NSDate *registerTime;
@property (nonatomic, strong) NSNumber *sex;//1男0女
@property (nonatomic, strong) NSString *markNickName;//新浪微博昵称/通讯录手机号码

-(void)updaInfoWithDic:(NSDictionary*)dic;

@end
