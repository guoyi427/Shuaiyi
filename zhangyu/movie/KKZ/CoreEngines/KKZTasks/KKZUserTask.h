//
//  FavListTask.h
//  Aimeili
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface KKZUserTask : NetworkTask {
}

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *openId;
@property(nonatomic, strong) NSString *phoneArray;

@property(nonatomic, strong) NSString *sessionId;
@property(nonatomic, strong) NSString *username;

@property(nonatomic, strong) NSString *friendIds;
@property(nonatomic, strong) NSString *relateId;
@property(nonatomic, strong) NSString *movieId;
@property(nonatomic, strong) NSString *searchText;
@property(nonatomic, assign) ShareFriendType shareType;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *isNewFriend;

/**
 *  查询关注列表
 *
 *  @param uId   用户id
 *  @param page  第几页
 *  @param block <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initFavoriteListFor:(unsigned int)userId
                     page:(NSInteger)page
               searchText:(NSString *)searchText // TODO 参数作废
                 finished:(FinishDownLoadBlock)block;

/**
 *  查询粉丝列表
 *
 *  @param userId <#userId description#>
 *  @param page   <#page description#>
 *  @param block  <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initFollowingListFor:(unsigned int)userId
                      page:(NSInteger)page
                searchText:(NSString *)searchText // TODO 参数作废
                  finished:(FinishDownLoadBlock)block;

/**
 *  查询好友列表，和关注相似
 *
 *  @param uId   <#uId description#>
 *  @param page  <#page description#>
 *  @param searchText  搜索文字
 *  @param sort  sort, 1 按照时间排序，2 按照拼音排序,默认时间排序
 *  @param block <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initFriendListFor:(unsigned int)uId
                   page:(NSInteger)page
             searchText:(NSString *)searchText // TODO 参数作废
                   sort:(NSString *)sort
               finished:(FinishDownLoadBlock)block;

/**
 * 添加关注
 *
 * @param userId <#userId description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initAddFriend:(unsigned int)userId finished:(FinishDownLoadBlock)block;

/**
 * 更新通讯录好友的邀请状态。
 *
 * @param sessionId <#sessionId description#>
 * @param username  <#username description#>
 *
 * @return <#return value description#>
 */
- (id)initGetInvitedFriend:(NSString *)sessionId username:(NSString *)username;

/**
 *  删除好友，取消关注。
 *
 *  @param userId <#userId description#>
 *  @param block  <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initDelFriend:(unsigned int)userId finished:(FinishDownLoadBlock)block;

/**
 * 查询是否已关注某个用户
 *
 * @param userId <#userId description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUserRelationWith:(unsigned int)userId
                  finished:(FinishDownLoadBlock)block;

/**
 *  获取新浪微博的好友列表。
 *  TODO 该功能已删除
 *
 *  @param userId      <#userId description#>
 *  @param token       <#token description#>
 *  @param page        <#page description#>
 *  @param isNewFriend is_new_friend=1，查询新浪微博的新好友.默认没有。
 *  @param block       <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initSinaWeiboUserListWith:(NSString *)userId
                          token:(NSString *)token
                        ForPage:(NSInteger)page
                    isNewFriend:(NSString *)isNewFriend
                       finished:(FinishDownLoadBlock)block;

/**
 *  查询通讯录的好友列表
 *
 *  @param phoneArray  <#phoneArray description#>
 *  @param page        <#page description#>
 *  @param isNewFriend is_new_friend=1，查询通讯录新的新好友.默认没有。
 *  @param block       <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initIdentifyPhoneNum:(NSString *)phoneArray
                      page:(NSInteger)page
               isNewFriend:(NSString *)isNewFriend
                  finished:(FinishDownLoadBlock)block;



/**
 * 查询别人的个人主页分享的信息。
 *
 * @param userId <#userId description#>
 * @param page   <#page description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initFriendHomeListFor:(unsigned int)userId
                       page:(NSInteger)page
                   finished:(FinishDownLoadBlock)block;

/**
 * 查询自己主页分享的信息
 *
 * @param userId <#userId description#>
 * @param page   <#page description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initMyHomeListFor:(unsigned int)userId
                   page:(NSInteger)page
               finished:(FinishDownLoadBlock)block;

@end
