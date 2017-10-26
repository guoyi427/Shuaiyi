//
//  统计的接口
//
//  Created by zhoukai on 1/16/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

typedef enum {
  ChannelTypeWeChatTimeline = 1, //微信朋友圈
  ChannelTypeWeChat = 2,
  ChannelTypeSina = 3,
  ChannelTypeRenren = 4,
  ChannelTypeWeibo = 5,
  ChannelTypeQQSpace = 6
} ChannelType;

#import "NetworkTask.h"

@interface StatisticsTask : NetworkTask

@property(nonatomic, copy) NSString *infName; // 事件的名称（与友盟相同）
@property(nonatomic, copy)
    NSString *articleId; // 接口业务参数,有参数就要传参数，否则无法做详细统计

/**
 * 统计分享的数量。
 *
 * @param stype <#stype description#>
 * @param ctype <#ctype description#>
 * @param uid   <#uid description#>
 * @param si    <#si description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initStatisticsShareByType:(StatisticsType)stype
                withChannelType:(ChannelType)ctype
                  withSharedUid:(NSString *)uid
                  withShareInfo:(NSString *)si
                       finished:(FinishDownLoadBlock)block;

/**
 * 统计帖子的阅读量
 *
 * @param Inf       <#Inf description#>
 * @param articleId <#articleId description#>
 * @param block     <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initStatisticsClubByInf:(NSString *)Inf
                withArticleId:(NSString *)articleId
                     finished:(FinishDownLoadBlock)block;

@end
