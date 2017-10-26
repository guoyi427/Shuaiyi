//
//  AttentionModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/9.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionModel : NSObject

/**
 *  朋友的Id
 */
@property (nonatomic, strong) NSString *friendId;

/**
 *  用户头像
 */
@property (nonatomic, strong) NSString *headimg;

/**
 *  用户昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 *  用户的Id
 */
@property (nonatomic, strong) NSString *uid;

/**
 *  用户状态
 */
@property (nonatomic, assign) int status;

@end
