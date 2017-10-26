//
//  MessageTalk.m
//  KoMovie
//
//  Created by zhoukai on 1/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "MessageTalk.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation MessageTalk

@dynamic uidForList;
@dynamic attachPath;
@dynamic uid;
@dynamic isRead;
@dynamic shuoLength;
@dynamic type;
@dynamic content;
@dynamic headImg;
@dynamic messageId;
@dynamic nickName;
@dynamic messageCount;
@dynamic createTime;

+ (NSString *)primaryKey {
    return @"messageId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"shuoLength": @"attachLength",
//                 @"uidForList": @"uid",

                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"createTime": @"yyyy-MM-dd HH:mm:ss",
                 } retain];
    }
    return map;
}

+ (MessageTalk *)getMessageWithId:(unsigned int)messageId {
    return [[MemContainer me] getObject:[MessageTalk class]
                                 filter:[Predicate predictForKey: @"messageId" compare:Equal value:@(messageId)], nil];

}

-(NSString *)description{
    return [NSString stringWithFormat:@"私信id:%u,私信内容%@,attachPath = url%@,好友名%@,sessionId:%@,uid:%@,\n发信时间%@--转化时间%@",self.messageId,self.content,self.attachPath,self.nickName,self.sessionId,self.uid,
            [[DateEngine sharedDateEngine] stringFromDate:self.createTime],
            [[DateEngine sharedDateEngine] formattedStringFromDateNew:self.createTime]];
}

- (NSComparisonResult) compareAscend:(MessageTalk *)other {
    return [self.createTime compare:other.createTime];
//    //这里可以作适当的修正后再比较
//    int result = ([selfintValue]>>1) - ([other intValue]>>1);
//    //这里可以控制排序的顺序和逆序
//    return result < 0 ?NSOrderedDescending : result >0 ?NSOrderedAscending :NSOrderedSame;
}

- (NSComparisonResult) compareDescend:(MessageTalk *)other {
    return [other.createTime compare:self.createTime];
}

@end
