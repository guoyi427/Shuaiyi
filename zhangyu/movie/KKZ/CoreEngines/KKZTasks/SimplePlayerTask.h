//
//  SimplePlayerTask.h
//  KoMovie
//
//  Created by KKZ on 15/10/13.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface SimplePlayerTask : NetworkTask

@property(nonatomic, strong) NSString *record_id;

/**
 * 查询全景视频的播放列表。入口在某个活动。
 *
 * @param record_id <#record_id description#>
 * @param block     <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initSimplePlayerDataWithRecord_id:(NSString *)record_id
                               finished:(FinishDownLoadBlock)block;
@end
