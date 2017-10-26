//
//  Comment.h
//  KoMovie
//
//  Created by XuYang on 13-3-15.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Model.h"

typedef enum {
    ShuoTypeSupport = 1, //支持
    ShuoTypeOpposition,   //反对
} ShuoType;

typedef enum {
    CommentTargetTypeMovie = 1,   //电影评论
    CommentTargetTypeCinema, //影院评论
    
} CommentTargetType;

typedef enum {
    CommentTypeWord = 1, //用户文字评价
    CommentTypeSound = 2,   //语音评论
//    CommentTypeWordAndSound, //文字语音评论
    CommentTypeKo,   //ko评价
    CommentTypeDeBa,   //嘚吧嘚吧，官方影评
} CommentType;

@interface Comment : Model



//"comment": {
//like
//dislike
//
//    "attitude": 1,
//    "commentId": 12214,
//    "commentType": 1,
//    "content": "bbbbbbmjmmmmm",
//    "createTime": "2014-11-27 13:31:21",
//    "del": 0,
//    "isCheck": 0,
//    "point": 0,
//    "priority": 0,
//    "referId": 0,
//    "resultStatus": 0,
//    "targetId": 74,
//    "targetType": 2,
//    "uid": 214000
//}

/**
 *  标签名字
 */
@property (nonatomic, strong) NSString *label;

@property (nonatomic, assign) unsigned int commentId;
@property (nonatomic, assign) unsigned int targetId;//现在只有movieid，没有cinemaid

@property (nonatomic, strong) NSNumber * like;//支持此评论的数字。
@property (nonatomic, strong) NSNumber * dislikeNum;//支持此评论的数字。
@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, assign) unsigned int cinemaId;

@property (nonatomic, strong) NSDate * commentTime;
@property (nonatomic, strong) NSNumber * likeNum;//支持此评论的数字。
@property (nonatomic, strong) NSNumber * isLove; //是否已支持
@property (nonatomic, strong) NSNumber * oppositionCount;//支持此评论的数字。
@property (nonatomic, strong) NSNumber * relation;//支持此评论的数字。

@property (nonatomic, strong) NSNumber * isOppo; //是否已支持
@property (nonatomic, strong) NSNumber * commentType;
@property (nonatomic, strong) NSNumber * commentTargetType;

@property (nonatomic, strong) NSString * commentContent;
@property (nonatomic, assign) NSInteger commentStyle; //没用
@property (nonatomic, strong) NSNumber * commentScore; //5星
@property (nonatomic, strong) NSString * moviePoint; //5星
@property (nonatomic, strong) NSNumber * shuoLength;//语音长度，秒（3-30）
@property (nonatomic, strong) NSNumber * attitude;//语音评论态度。不用
@property (nonatomic, strong) NSString * audioUrl;//语音url
@property (nonatomic, strong) NSString * targetName;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userAvatar;

@property (nonatomic, strong) NSNumber * priority;//排序

@property (nonatomic, assign) unsigned int qouteId;//评论id，commentId //个人影评
//@property (nonatomic, retain) NSString * qouteName;//引用的username
//@property (nonatomic, retain) NSString * qouteUrl;//引用的语音url

@property (nonatomic, strong) NSNumber * referNum;//评论数量
@property (nonatomic, strong) NSNumber * shareNum;//分享数量

@property (nonatomic, strong) NSString * commentLevelIcon;

@property (nonatomic, strong) NSNumber * isSex;
//


//-(NSString *)description;

+ (Comment *)getCommentWithId:(unsigned int)commentId;
- (void)updateDataFromDict:(NSDictionary *)dict;
@end
