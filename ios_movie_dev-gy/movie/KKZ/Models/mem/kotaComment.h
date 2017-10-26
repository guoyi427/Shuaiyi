//
//  kotaComment.h
//  KoMovie
//
//  Created by avatar on 14-12-3.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface kotaComment : Model
@property (nonatomic, assign) int kotaCommentId;
@property (nonatomic, assign) int kotaId;
@property (nonatomic, assign) int attachLength;
@property (nonatomic, assign) int commentType;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * attachPath;



+ (kotaComment *)getKotaCommentMessageWithId:(unsigned int)kotaCommentId;
@end
