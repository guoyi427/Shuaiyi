//
//  VoiceTask.m
//  KoMovie
//
//  Created by zhang da on 13-4-14.
//  Copyright (c) 2013年 kokozu. All rights reserved.
////上传评论（包括语音和文字）

#import "VoiceTask.h"
#import "DataEngine.h"
#import "RecordAudio.h"
#import "Comment.h"
#import "MemContainer.h"
#import "KKZUser.h"
#import "MessageTalk.h"
#import "Constants.h"
#import "UserDefault.h"


@implementation VoiceTask


- (id)initUploadVoiceWithData:(NSData *)voice
                     forMovie:(NSUInteger)movieId
                       length:(int)length
                      referId:(NSString *)commentId
                    withPoint:(float)point
                   targetType:(CommentTargetType)targetType
                     finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCommentUploadAudio;
        self.voiceData = voice;
        self.referId = commentId;
        self.targetType = targetType;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long)movieId];
        self.length = length;
        self.commentId = commentId;
        self.point = point;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUploadVoiceWithData:(NSData *)voice
                     forMovie:(NSUInteger)movieId
                      orderId:(NSString *)orderId
                       length:(int)length
                    withPoint:(float)point
                   targetType:(CommentTargetType)targetType
                     finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCommentUploadAudio;
        self.voiceData = voice;
        self.referId = @"0";
        self.movieId = [NSString stringWithFormat:@"%lu",(unsigned long)movieId];
        self.orderId = orderId;
        self.length = length;
        self.point = point;
        self.targetType = targetType;
        self.finishBlock = block;
    }
    return self;
}

-(id)initUploadCommentWithString:(NSString *)comment forMovie:(NSUInteger)movieId referId:(NSString *)referId
                       withPoint:(float)point
                      targetType:(CommentTargetType)targetType
                        finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCommentUploadText;
        self.comment = comment;
        self.targetType = targetType;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long)movieId];
        self.referId = referId;
        self.point = point;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUploadCommentWithString:(NSString *)comment
                         forMovie:(NSUInteger)movieId
                        withPoint:(float)point
                      withOrderId:(NSString *)orderId
                       targetType:(CommentTargetType)targetType
                         finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.targetType = targetType;
        self.comment = comment;
        self.taskType = TaskTypeCommentUploadText;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long)movieId];
        self.referId = @"0";
        self.orderId = orderId;
        self.point = point;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUploadVoiceMessageWithData:(NSData *)voice
                           forUserId:(NSString *)userId
                              length:(int)length
                            finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCommentMessageUploadAudio;
        self.voiceData = voice;
        self.uid = userId;
        self.length = length;
        self.finishBlock = block;
    }
    return self;
}

-(id)initUploadCommentMessageWithString:(NSString *)comment forUserId:(NSString *)userId finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCommentMessageUploadText;
        self.comment = comment;
        self.uid = userId;
        self.finishBlock = block;
    }
    return self;
}



- (id)initUploadKotaApplyForCommentVoiceWithData:(NSData *)voice
                                       forKotaId:(NSString *)kotaId
                                     commentType:(NSString *)commentType
                                         content:(NSString *)content
                                          length:(int)length
                                        finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaApplyForMessageUploadText;
        self.voiceData = voice;
        self.kotaId = kotaId;
        self.length = length;
        self.finishBlock = block;
        self.comment = content;
        self.commentType = commentType;
    }
    return self;
}


- (id)initUploadKotaCommentVoiceWithData:(NSData *)voice
                                forMovie:(NSString *)movieId
                             commentType:(NSString *)commentType
                                 content:(NSString *)content
                                  length:(int)length
                                finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaMessageUploadText;
        self.voiceData = voice;
        self.movieId = movieId;
        self.length = length;
        self.finishBlock = block;
        self.comment = content;
        self.commentType = commentType;
    }
    return self;
}



- (void)getReady {
    
    if (taskType == TaskTypeCommentUploadAudio) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl, KKSSPKota,@"comment_add.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        [self addParametersWithValue:self.movieId forKey:@"target_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.length]forKey:@"attach_length"];
        [self addParametersWithValue:@"2" forKey:@"comment_type"]; //语音
        [self addParametersWithValue:[NSString stringWithFormat:@"%f",self.point] forKey:@"point"];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.targetType] forKey:@"target_type"];
        if ([self.referId isEqualToString:@"0"] || self.referId.length<=0) {
        }else{
            [self addParametersWithValue:self.referId forKey:@"refer_id"];
        }
        if (self.orderId) {
            //订单Id
            [self addParametersWithValue:self.orderId
                                  forKey:@"order_id"];
        }
        [self setUploadBody:self.voiceData withName:@"comment_data" fromFile:@"voice.mp3"];
        [self setRequestMethod:@"POST"];
    }else if(taskType == TaskTypeCommentUploadText){
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl, KKSSPKota,@"comment_add.chtml"]];
        //movieId
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%f",self.point] forKey:@"point"];
        [self addParametersWithValue:self.movieId forKey:@"target_id"];
        [self addParametersWithValue:@"1" forKey:@"attitude"];
        [self addParametersWithValue:@"1" forKey:@"comment_type"]; //文字
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.targetType] forKey:@"target_type"];
        [self addParametersWithValue:self.comment forKey:@"content"];
        if ([self.referId isEqualToString:@"0"] || self.referId.length<=0) {
        }else{
            [self addParametersWithValue:self.referId forKey:@"refer_id"];
        }
        if (self.orderId) {
            [self addParametersWithValue:self.orderId forKey:@"order_id"];
        }
        [self setRequestMethod:@"POST"];
        
    }
    
    
    else if(taskType == TaskTypeKotaApplyForMessageUploadText){
        
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl, KKSSPKota,@"user_ask_woman.chtml"]];
        
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        //1、文字 2、语音
        
        [self addParametersWithValue:self.kotaId forKey:@"entity.kotaQuoteId"];
        
        
        
        if ([self.commentType isEqualToString:@"1"]) {
            [self addParametersWithValue:@"1" forKey:@"comment_type"]; //文字
            [self addParametersWithValue:self.comment forKey:@"content"];
        }else if([self.commentType isEqualToString:@"2"]){
            
            [self addParametersWithValue:@"2" forKey:@"comment_type"]; //语音
            [self setUploadBody:self.voiceData withName:@"comment_data" fromFile:@"voice.mp3"];
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.length]forKey:@"attach_length"];
            
        }
        
        [self setRequestMethod:@"POST"];
        
        
    }
    
    
    
    
    else if(taskType == TaskTypeKotaMessageUploadText){
        
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl,KKSSPKota,@"inviteMovie.chtml"]];
        
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        //1、文字 2、语音
        
        [self addParametersWithValue:self.movieId forKey:@"film_id"];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        
        
        if ([self.commentType isEqualToString:@"1"]) {
            [self addParametersWithValue:@"1" forKey:@"comment_type"]; //文字
            [self addParametersWithValue:self.comment forKey:@"content"];
        }else if([self.commentType isEqualToString:@"2"]){
            
            [self addParametersWithValue:@"2" forKey:@"comment_type"]; //语音
            [self setUploadBody:self.voiceData withName:@"comment_data" fromFile:@"voice.mp3"];
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.length]forKey:@"attach_length"];
            
        }
        
        [self setRequestMethod:@"POST"];
        
        
    }
    
    
    else  if (taskType == TaskTypeCommentMessageUploadAudio
              || taskType == TaskTypeCommentMessageUploadText) {
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl, KKSSPKota,@"send_message.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        [self addParametersWithValue:self.uid forKey:@"get_uid"];
        
        if (taskType == TaskTypeCommentMessageUploadText) {
            [self addParametersWithValue:@"1" forKey:@"type"]; //文字
            [self addParametersWithValue:self.comment forKey:@"content"];
        }else{
            [self addParametersWithValue:@"2" forKey:@"type"]; //语音
            [self setUploadBody:self.voiceData withName:@"message_data" fromFile:@"voice.mp3"];
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.length]forKey:@"attach_length"];
        }
        
        [self setRequestMethod:@"POST"];
        
    }
}


#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeCommentUploadAudio) {
        DLog(@"语音评论上传成功 %@", result);
        NSDictionary *acomment = [result objectForKey:@"comment"];
        
        NSNumber *existed = nil;
        Comment * newComment = (Comment *)[[MemContainer me] instanceFromDict:acomment
                                                                        clazz:[Comment class]
                                                                        exist:&existed];
        [newComment updateDataFromDict:acomment];
        //        newComment.userAvatar = user.avatarPath;
        //        newComment.userName = user.userName;
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   newComment, @"newComment",
                                   self.identifier, @"taskId", nil]];
    }else if (taskType == TaskTypeCommentUploadText){
        DLog(@"文字评论上传成功 %@", result);
        NSDictionary *acomment = [result objectForKey:@"comment"];
        
        NSNumber *existed = nil;
        Comment * newComment = (Comment *)[[MemContainer me] instanceFromDict:acomment
                                                                        clazz:[Comment class]
                                                                        exist:&existed];
        [newComment updateDataFromDict:acomment];
        //        newComment.userAvatar = user.avatarPath;
        //        newComment.userName = user.userName;
        
        NSString *shareContent = @"";
        NSString *sharePicUrl = @"";
        NSString *shareUrl = @"";
        NSString *shareDetailUrl = @"";
        NSString *titile = @"";
        
        
        NSDictionary *share = [result objectForKey:@"share"];
        
        shareContent = share[@"shareContent"];
        sharePicUrl = share[@"sharePicUrl"];
        shareUrl = share[@"shareUrl"];
        shareDetailUrl = share[@"shareDetailUrl"];
        titile = share[@"titile"];
        
        if (shareUrl.length > 0 && sharePicUrl.length > 0 && shareUrl.length > 0 && titile.length > 0 && shareDetailUrl.length > 0) {
            
            [self doCallBack:YES info: [NSDictionary dictionaryWithObjectsAndKeys:
                                        newComment, @"newComment",
                                        self.identifier, @"taskId",
                                        shareContent, @"shareContent",
                                        sharePicUrl, @"sharePicUrl",
                                        shareUrl, @"shareUrl",shareDetailUrl, @"shareDetailUrl",
                                        titile, @"titile",nil]];
            
            
        }else{
            
            [self doCallBack:YES info: [NSDictionary dictionaryWithObjectsAndKeys:
                                        newComment, @"newComment",
                                        self.identifier, @"taskId", nil]];
            
        }
       
    }else if (taskType == TaskTypeCommentMessageUploadAudio) {
        DLog(@"语音私信发送成功  %@", result);
        
        NSDictionary *amessage = [result objectForKey:@"result"];
        NSNumber *existed = nil;
        MessageTalk *newMessage = (MessageTalk *)[[MemContainer me] instanceFromDict:amessage
                                                                               clazz:[MessageTalk class]
                                                                               exist:&existed];
        //newMessage.sessionId = self.sessionId;
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   newMessage, @"newMessage",
                                   self.identifier, @"taskId", nil]];
    }else if (taskType == TaskTypeCommentMessageUploadText){
        DLog(@"文字私信发送成功   %@", result);
        NSDictionary *amessage = [result objectForKey:@"result"];
        
        NSNumber *existed = nil;
        MessageTalk *newMessage = (MessageTalk *)[[MemContainer me] instanceFromDict:amessage
                                                                               clazz:[MessageTalk class]
                                                                               exist:&existed];
        
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   newMessage, @"newMessage",
                                   self.identifier, @"taskId", nil]];
        
    }
    
    
    else if (taskType == TaskTypeKotaMessageUploadText){
        DLog(@"发起约电影成功 %@", result);
        NSDictionary *amessage = [result objectForKey:@"result"];
        
        NSNumber *existed = nil;
        MessageTalk *newMessage = (MessageTalk *)[[MemContainer me] instanceFromDict:amessage
                                                                               clazz:[MessageTalk class]
                                                                               exist:&existed];
        
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   newMessage, @"newMessage",
                                   self.identifier, @"taskId", nil]];
        
    }
    
    else if (taskType == TaskTypeKotaApplyForMessageUploadText){
        DLog(@"发起约电影成功 %@", result);
        NSDictionary *amessage = [result objectForKey:@"result"];
        
        NSNumber *existed = nil;
        MessageTalk *newMessage = (MessageTalk *)[[MemContainer me] instanceFromDict:amessage
                                                                               clazz:[MessageTalk class]
                                                                               exist:&existed];
        
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   newMessage, @"newMessage",
                                   self.identifier, @"taskId", nil]];
        
    }
    
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeCommentUploadAudio) {
        DLog(@"语音评论上传失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeCommentUploadText){
        DLog(@"文字评论上传失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeCommentMessageUploadAudio) {
        DLog(@"语音私信发送失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeCommentMessageUploadText){
        DLog(@"文字私信发送失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeKotaMessageUploadText){
        DLog(@"发起约电影失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeKotaApplyForMessageUploadText){
        DLog(@"发起约电影失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

- (void)requestSucceededResponse {
    //if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
    //just for upload task
}

@end
