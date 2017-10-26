//
//  MessageTalk.h
//  KoMovie
//
//  Created by zhoukai on 1/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface MessageTalk : Model

@property (nonatomic, retain) NSString * uidForList; //私信列表的uid，是和uid的最后一条私信内容，一定是别人的uid
@property (nonatomic, retain) NSString * attachPath;
@property (nonatomic, retain) NSString * uid; //私信列表的发信人uid，是发信人的uid，可能是自己
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * shuoLength;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * headImg;
@property (nonatomic, assign) unsigned int messageId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * sessionId;
@property (nonatomic, retain) NSNumber * messageCount;
@property (nonatomic, assign) unsigned int getUserId;
@property (nonatomic, assign) unsigned int sendUserId;



+ (MessageTalk *)getMessageWithId:(unsigned int)messageId;

- (NSComparisonResult) compareAscend:(MessageTalk *)other;
- (NSComparisonResult) compareDescend:(MessageTalk *)other;

@end
