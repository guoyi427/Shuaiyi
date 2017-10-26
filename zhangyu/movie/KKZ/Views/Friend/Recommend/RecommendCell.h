//
//  RecommendCell.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendRecommendModel.h"
#import "RecommendLayout.h"

typedef enum {
    PlatFormUserExist = 0, //存在非好友        0普通抠电影用户
    PlatFormUserNotExist, //不存在           1未注册抠电影
    PlatFormUserFriend, //好友             2是好友
    PlatFormInvitedUserFriend, //非好友已邀请      3已经邀请
} PlatFormUserType;

/**
 *  获取电话号码
 */
static NSString *cellPhoneNumKey = @"cellPhoneNumKey";

/**
 *  代表当前cell是第几个
 */
static NSString *cellIndexKey = @"cellIndexKey";

/**
 *  代表当前cell的Uid
 */
static NSString *cellUidKey = @"cellUidKey";

@protocol RecommendCellDelegate <NSObject>

@optional

/**
 *  点击邀请按钮
 *
 *  @param inventObject
 */
- (void)clickInventButton:(id)inventObject;

/**
 *  点击关注按钮
 *
 *  @param inventObject
 */
- (void)clickAttentionButton:(id)inventObject;

/**
 *  下拉刷新
 */
- (void)headerRefrshing;

@end

@interface RecommendCell : UITableViewCell

/**
 *  用户信息model
 */
@property (nonatomic, strong) friendRecommendModel *model;

/**
 *  cell尺寸布局
 */
@property (nonatomic, strong) RecommendLayout *layout;

/**
 *  cell的索引值
 */
@property (nonatomic, assign) NSInteger cellIndex;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<RecommendCellDelegate> cellDelegate;

/**
 *  更新视图
 */
- (void)updateLayout;

@end
