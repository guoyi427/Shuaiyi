//
//  意见反馈接口
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "NetworkTask.h"

@interface FeedbackTask : NetworkTask

/**
 * 意见反馈的信息。
 */
@property(nonatomic, strong) NSString *message;

/**
 * 发送意见反馈。
 *
 * @param content <#content description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initFeedback:(NSString *)content finished:(FinishDownLoadBlock)block;

@end
