//
//  Kota.m
//  KoMovie
//
//  Created by XuYang on 13-8-13.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "UserMessage.h"
#import "DateEngine.h"
#import "MemContainer.h"


@implementation UserMessage

@dynamic cinemaId;
@dynamic cinemaName;
@dynamic dialogue;
@dynamic dialogueSpeaker;
@dynamic hallName;
@dynamic hasRead;
@dynamic kotaId;
@dynamic messageId;
@dynamic kotaState;
@dynamic kotaTime;
@dynamic movieId;
@dynamic movieName;
@dynamic smallPosterPath;
@dynamic ticketTime;
@dynamic shareHeadimg;
@dynamic shareId;
@dynamic shareNickname;
@dynamic shareSeatInfo;
@dynamic shareSex;
@dynamic requestNum;
@dynamic seatNo;
@dynamic songName;
@dynamic songSinger;
@dynamic songLength;
@dynamic songAttitude;
@dynamic songUrl;
@dynamic ticketId;
@dynamic place;
@dynamic movieLength;
@dynamic movieType;
@dynamic commentType;
@dynamic commentId;
@dynamic commentUrl;
@dynamic commentCount;
@dynamic txtComment;
@dynamic songId;
@dynamic dialogueId;
@dynamic songDesc;
@dynamic posterPath;
@dynamic publishTime;
@dynamic starringActor;
@dynamic director;
@dynamic requestIsVip;
@dynamic requestSeatInfo;
@dynamic shareIsVip;
@dynamic requestSex;
@dynamic point;
@dynamic loveNum;
@dynamic isLove;
@dynamic isRequest;
@dynamic isMy;
@dynamic index;

//@dynamic cmo_modifiedDate;
@dynamic collectId;
@dynamic requestAvatar;
@dynamic requestId;
@dynamic requestName;

+ (NSString *)primaryKey {
    return @"messageId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"messageId": @"id",
                 @"kotaState": @"status",
                 @"songUrl": @"songFile",
                 @"songSinger": @"singer",
                 @"movieId": @"filmId",
                 @"movieName": @"filmName",
                 @"ticketId": @"qid",
                 @"seatNo": @"shareSeatNo",
                 @"requestName": @"requestNickname",
                 @"requestAvatar": @"requestHeadimg",
                 @"commentUrl": @"attachPath",
                 @"txtComment": @"content",
                 @"songLength": @"attachLength",
                 @"dialogueSpeaker": @"actor",
                 @"movieLength": @"playTime",
                 @"movieType": @"commodityType",
                 @"songAttitude": @"attitude",

                 } retain];
    }
    return map;
}

- (void)updateDataFromDict:(NSDictionary *)dict
{
    //status= 1 向我申请，2 同意我的，  4 购票成功的，7 普通的kota , 8 关注 ，10 分享电影，
    //11 分享歌曲，12 分享台词，13 评论(文字、语音评论) 14 //点击评分。意思是收藏。
    
    if ([dict kkz_stringForKey:@"createTime"].length != 0) {
        self.kotaTime = [dict kkz_dateForKey:@"createTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];

    }
    //歌曲
    NSString *desc = [dict kkz_stringForKey:@"songDesc"];
    if (desc.length != 0) {
        desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.songDesc = desc; //歌曲描述
    }
    
    //影片信息
    
    NSString *ptime = dict[@"publishTime"];
    ptime = [ptime stringByAppendingString:@" 01:01:01"];
    if (ptime.length != 0) {
        NSDate *pDate = [[DateEngine sharedDateEngine] dateFromString:ptime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.publishTime = pDate;// 影片上映时间
    }
   
    if ([dict kkz_stringForKey:@"ticketTime"].length != 0) {
        self.ticketTime = [dict kkz_dateForKey:@"ticketTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}


+ (UserMessage *)getKotaWithId:(unsigned int)messageId
{
    return [[MemContainer me] getObject:[UserMessage class]
                                 filter:[Predicate predictForKey: @"id" compare:Equal value:@(messageId)], nil];

}

- (NSComparisonResult) compare:(UserMessage *)other{
    return [other.kotaTime compare:self.kotaTime];
    //    //这里可以作适当的修正后再比较
    //    int result = ([selfintValue]>>1) - ([other intValue]>>1);
    //    //这里可以控制排序的顺序和逆序
    //    return result < 0 ?NSOrderedDescending : result >0 ?NSOrderedAscending :NSOrderedSame;
}

@end
