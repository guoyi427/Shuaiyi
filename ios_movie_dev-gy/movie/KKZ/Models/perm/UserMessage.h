//
//  Kota.h
//  KoMovie
//
//  Created by XuYang on 13-8-13.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
//“我的电影中心”
//分享给我的好友
//按照分享时间排序
@interface UserMessage : Model

@property (nonatomic, assign) unsigned int messageId;

@property (nonatomic, assign) int cinemaId;//cinema table
@property (nonatomic, retain) NSString * cinemaName;

@property (nonatomic, retain) NSString * dialogueId;//台词
@property (nonatomic, retain) NSString * dialogue;
@property (nonatomic, retain) NSString * dialogueSpeaker;//演员名字

@property (nonatomic, retain) NSString * hallName;
@property (nonatomic, retain) NSNumber * hasRead;//没用

@property (nonatomic, assign) int kotaId;
@property (nonatomic, retain) NSNumber * kotaState;
@property (nonatomic, retain) NSDate   * kotaTime;

@property (nonatomic, assign) int movieId;
@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, retain) NSDate   * publishTime;
@property (nonatomic, retain) NSString * movieType;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * movieLength;

@property (nonatomic, assign) int shareId;//...选座的时候需要传shareid
@property (nonatomic, retain) NSString * shareNickname;
@property (nonatomic, retain) NSString * shareHeadimg;//分享人url
@property (nonatomic, retain) NSString * shareSeatInfo;
@property (nonatomic, retain) NSNumber * shareSex;
@property (nonatomic, retain) NSNumber * requestNum;//...

@property (nonatomic, retain) NSString * requestId;
@property (nonatomic, retain) NSString * requestName;
@property (nonatomic, retain) NSString * requestAvatar;
@property (nonatomic, retain) NSNumber * requestSex;
@property (nonatomic, retain) NSNumber * requestIsVip;

@property (nonatomic, retain) NSString * seatNo;//...
@property (nonatomic, retain) NSString * ticketId;//排期id

@property (nonatomic, retain) NSString * songId;//音乐或者评论
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songSinger;
@property (nonatomic, retain) NSNumber * songLength;
@property (nonatomic, retain) NSString * songUrl;
@property (nonatomic,retain) NSString *songDesc; //歌曲信息
@property (nonatomic, retain) NSString * songAttitude;//评论的态度，没用

@property (nonatomic, retain) NSNumber * commentType;//评论的类型 语音.文字
@property (nonatomic, assign) unsigned int commentId;//...语音.文字的评论的id
@property (nonatomic, retain) NSString * commentUrl;//...语音评论的URL
@property (nonatomic, retain) NSString * txtComment;//文字评论的内容

@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSDate * ticketTime; //影片放映时间
@property (nonatomic, retain) NSString *smallPosterPath;

@property (nonatomic,retain) NSString *posterPath;
@property (nonatomic,retain) NSString *starringActor;
@property (nonatomic,retain) NSString *director;
@property (nonatomic,retain) NSString *requestSeatInfo;
@property (nonatomic,retain) NSNumber *shareIsVip;
@property (nonatomic,retain) NSNumber *point;
@property (nonatomic,retain) NSNumber *loveNum;
@property (nonatomic,retain) NSNumber *isLove;
@property (nonatomic,retain) NSNumber *isRequest;
@property (nonatomic,retain) NSString *collectId;//评分的id，同pingfenid。status==14时候分享评分
@property (nonatomic,retain) NSString *isMy;
@property (nonatomic,retain) NSNumber *index;


+ (UserMessage *)getKotaWithId:(unsigned int)messageId;
- (void)updateDataFromDict:(NSDictionary *)dict;
//-(NSString*) airDay
//{
//    NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
//    [dayFormatter setLocale:[NSLocale currentLocale]];
//    [dayFormatter setDateStyle: NSDateFormatterMediumStyle];
//    [dayFormatter setDoesRelativeDateFormatting: YES];
//    
//    return [dayFormatter stringFromDate:self.startDate];
//}
- (NSComparisonResult) compare:(UserMessage *)other;


@end
