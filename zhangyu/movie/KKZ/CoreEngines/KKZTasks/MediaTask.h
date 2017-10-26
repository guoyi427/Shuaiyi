//
//  MediaTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Banner.h"
#import "NetworkTask.h"
#import <Foundation/Foundation.h>
// banner类型

@interface MediaTask : NetworkTask {
}

@property(nonatomic, strong) NSString *targetId;
@property(nonatomic, assign) MediaType type;

/**
 * 查询影院的图集。
 *
 * @param targetId <#targetId description#>
 * @param type     <#type description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initMedia:(int)targetId
      mediaType:(MediaType)type
       finished:(FinishDownLoadBlock)block;

@end
