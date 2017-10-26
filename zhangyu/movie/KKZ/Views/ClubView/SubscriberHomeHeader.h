//
//  SubscriberHomeHeader.h
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface SubscriberHomeHeader : UIView {
    //用户头像
    UIImageView *userHeadImgV;
    //用户昵称
    UILabel *nickNameLbl;
    //用户简介
    UILabel *subTitleLbl;

    UIButton *subscribeBtn;
}
/**
 *  用户简介
 */
@property (nonatomic, copy) NSString *subTitle;

/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *userHeadImgPath;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  用户昵称
 */
@property (nonatomic, assign) BOOL isSubscribe;

/**
 *  用户Id
 */
@property (nonatomic, assign) NSUInteger userId;

/**
 *  是否已订阅
 */
@property (nonatomic, assign) BOOL isFriend;

/**
 *  加载数据
 */
- (void)upLoadData:(User *)user;
@end
