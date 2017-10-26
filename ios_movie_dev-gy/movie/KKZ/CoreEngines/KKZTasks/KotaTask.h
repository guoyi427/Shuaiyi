//
//  KotaTask.h
//  KoMovie
//
//  Created by gree2 on 15/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#warning 约电影的接口，保持原样

#import "NetworkTask.h"

typedef enum {
  KotaListFilterFemale = 0,
  KotaListFilterMale,
  KotaListFilterDistance,
  KotaListFilterTime,
} KotaListFilterMode;

@interface KotaTask : NetworkTask

@property(nonatomic, strong) NSString *myId;
@property(nonatomic, strong) NSString *requestId;
@property(nonatomic, assign) KotaListFilterMode filter;
@property(nonatomic, assign) NSInteger pageNum; //
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) UIImage *bgImage;
@property(nonatomic, strong) NSString *kotaId;
@property(nonatomic, strong) NSString *attitude;
@property(nonatomic, assign) int row;

@property(nonatomic, assign) int status;
@property(nonatomic, strong) NSString *requestUid;
@property(nonatomic, strong) NSString *orderNo;
@property(nonatomic, strong) NSString *promoId;
@property(nonatomic, assign) int cityId;
@property(nonatomic, strong) NSString *movieId;
@property(nonatomic, strong) NSString *type;

/**
 *  查询当前城市的 和kota有关的 电影列表。
 *
 *  @param cityId      城市id
 *  @param currentPage <#currentPage description#>
 *  @param block       <#block description#>
 *
 *  @return 电影列表
 */
- (id)initKotaFilmListByCityId:(NSString *)cityId
                          page:(int)currentPage
                      pageSize:(int)pageSize
                      finished:(FinishDownLoadBlock)block;

- (id)initKotaNearUserListByCityId:(NSString *)cid
                              page:(int)currentPage
                          finished:(FinishDownLoadBlock)block;

- (id)initKotaHeadImageListByCityId:(NSString *)cityId
                               page:(int)currentPage
                           finished:(FinishDownLoadBlock)block;

- (id)initKotaListByFilterMode:(KotaListFilterMode)filter
                   withMovieId:(unsigned int)movieId
                          page:(int)currentPage
                      finished:(FinishDownLoadBlock)block;
- (id)initUserDetail:(unsigned int)userId finished:(FinishDownLoadBlock)block;

- (id)initModifyHomeBackground:(UIImage *)image
                      finished:(FinishDownLoadBlock)block;
- (id)initKotaShareApply:(int)kotaId finished:(FinishDownLoadBlock)block;

- (id)initResponseForKota:(int)kotaId
                     user:(NSString *)userId
                 attitude:(NSString *)attitude
                 finished:(FinishDownLoadBlock)block;

- (id)initKotaListByMovieId:(unsigned int)movieId
                    andType:(NSString *)type
                       page:(NSInteger)currentPage
                   finished:(FinishDownLoadBlock)block;

- (id)initKotaMyAppointmentAndPage:(NSInteger)currentPage
                          finished:(FinishDownLoadBlock)block;

- (id)initAcceptMyAppointmentWithKotaId:(NSString *)kotaId
                              andStatus:(int)status
                              andUserId:(NSString *)requesrtUId
                               finished:(FinishDownLoadBlock)block;

- (id)initFriendUserDetail:(unsigned int)userId
                  finished:(FinishDownLoadBlock)block;

- (void)cancelCurrentTask;

@end
