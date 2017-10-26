//
//  Comment.m
//  KoMovie
//
//  Created by XuYang on 13-3-15.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Comment.h"
#import "MemContainer.h"


@implementation Comment


@dynamic commentId;
@dynamic targetId;

@dynamic moviePoint;
@dynamic movieId;
@dynamic cinemaId;

@dynamic commentType;
@dynamic commentTargetType;

@dynamic shuoLength;
@dynamic attitude;
@dynamic audioUrl;

@dynamic userId;
@dynamic userName;
@dynamic userAvatar;

@dynamic commentContent;
@dynamic commentScore;
@dynamic commentStyle;

@dynamic priority;

@dynamic qouteId;
@dynamic targetName;
//@dynamic qouteName;
//@dynamic qouteUrl;

@dynamic referNum;
@dynamic shareNum;
@dynamic isOppo;
@dynamic oppositionCount;
@dynamic relation;
@dynamic commentTime;

@dynamic likeNum;
@dynamic isLove;
@dynamic like;
@dynamic dislikeNum;
@dynamic commentLevelIcon;
@dynamic isSex;




+ (NSString *)primaryKey {
    return @"commentId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"commentTargetType": @"targetType",
                 @"shuoLength": @"attachLength",
                 @"audioUrl": @"attachPath",
                 @"commentContent": @"content",
                 @"commentScore":@"point",
                 @"commentTime":@"createTime",
                 @"commentLevelIcon":@"label",
                 @"isSex":@"sex",
                } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"commentTime": @"yyyy-MM-dd HH:mm:ss"
                 } retain];
    }
    return map;
}

- (void)updateDataFromDict:(NSDictionary *)dict {
    self.commentTime = [dict kkz_dateForKey:@"createTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //个人评
    if ([dict kkz_stringForKey:@"userId"].length != 0) {
        self.userId = [[dict kkz_objForKey:@"userId"] intValue];
    }
    if ([dict kkz_stringForKey:@"nickName"].length != 0) {
        self.userName = [dict kkz_stringForKey:@"nickName"];
    }
    if ([dict kkz_stringForKey:@"headImg"].length != 0) {
        self.userAvatar = [dict kkz_stringForKey:@"headImg"];
    }

}

+ (Comment *)getCommentWithId:(unsigned int)commentId {
    return [[MemContainer me] getObject:[Comment class]
                                 filter:[Predicate predictForKey: @"commentId" compare:Equal value:@(commentId)], nil];
}

@end
