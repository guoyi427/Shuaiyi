//
//  VoiceTask.h
//  KoMovie
//
//  Created by zhang da on 13-4-14.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import "Comment.h"

@interface VoiceTask : NetworkTask

@property(nonatomic, strong) NSData *voiceData;
@property(nonatomic, strong) NSString *kotaId;
@property(nonatomic, strong) NSString *movieId;
@property(nonatomic, strong) NSString *commentId;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSString *referId;
@property(nonatomic, copy) NSString *commentType;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, assign) float point;

@property(nonatomic, assign) CommentTargetType targetType;

@property(nonatomic, assign) int attitude;
@property(nonatomic, assign) int length;

//私信相关
@property(nonatomic, strong) NSString *uid;

/**
 * 上传电影的语音评论。暂时保留
 *
 * @param voice      <#voice description#>
 * @param movieId    <#movieId description#>
 * @param length     <#length description#>
 * @param commentId  <#commentId description#>
 * @param point      <#point description#>
 * @param targetType <#targetType description#>
 * @param block      <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadVoiceWithData:(NSData *)voice
                     forMovie:(NSUInteger)movieId
                       length:(int)length
                      referId:(NSString *)commentId
                    withPoint:(float)point
                   targetType:(CommentTargetType)targetType
                     finished:(FinishDownLoadBlock)block;

/**
 *  待评论语音评论
 *
 *  @param voice      语音数据
 *  @param movieId    电影Id
 *  @param orderId    订单Id
 *  @param length     语音长度
 *  @param point      评论的分数
 *  @param targetType 目标类型
 *  @param block
 *
 *  @return
 */
- (id)initUploadVoiceWithData:(NSData *)voice
                     forMovie:(NSUInteger)movieId
                      orderId:(NSString *)orderId
                       length:(int)length
                    withPoint:(float)point
                   targetType:(CommentTargetType)targetType
                     finished:(FinishDownLoadBlock)block;

/**
 * 上传文字评论。
 *
 * @param comment    <#comment description#>
 * @param movieId    <#movieId description#>
 * @param referId    <#referId description#>
 * @param point      <#point description#>
 * @param targetType <#targetType description#>
 * @param block      <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadCommentWithString:(NSString *)comment
                         forMovie:(NSUInteger)movieId
                          referId:(NSString *)referId
                        withPoint:(float)point
                       targetType:(CommentTargetType)targetType
                         finished:(FinishDownLoadBlock)block;

/**
 *  上传文本评论内容
 *
 *  @param comment    评论内容
 *  @param movieId    评论的电影Id
 *  @param point      评论的分数
 *  @param orderId    订单Id
 *  @param targetType 目标类型
 *  @param block
 *
 *  @return
 */
- (id)initUploadCommentWithString:(NSString *)comment
                         forMovie:(NSUInteger)movieId
                        withPoint:(float)point
                      withOrderId:(NSString *)orderId
                       targetType:(CommentTargetType)targetType
                         finished:(FinishDownLoadBlock)block;

/**
 * 发送语音消息。是否有用？
 *
 * @param voice  <#voice description#>
 * @param userId <#userId description#>
 * @param length <#length description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadVoiceMessageWithData:(NSData *)voice
                           forUserId:(NSString *)userId
                              length:(int)length
                            finished:(FinishDownLoadBlock)block;

/**
 * 发送文字消息。是否有用？
 *
 * @param comment <#comment description#>
 * @param userId  <#userId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadCommentMessageWithString:(NSString *)comment
                               forUserId:(NSString *)userId
                                finished:(FinishDownLoadBlock)block;

/**
 * 发起约电影发送的语音或文字
 *
 * @param voice       <#voice description#>
 * @param movieId     <#movieId description#>
 * @param commentType <#commentType description#>
 * @param content     <#content description#>
 * @param length      <#length description#>
 * @param block       <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadKotaCommentVoiceWithData:(NSData *)voice
                                forMovie:(NSString *)movieId
                             commentType:(NSString *)commentType
                                 content:(NSString *)content
                                  length:(int)length
                                finished:(FinishDownLoadBlock)block;

/**
 * 申请约电影发送的语音或文字
 *
 * @param voice       <#voice description#>
 * @param kotaId      <#kotaId description#>
 * @param commentType <#commentType description#>
 * @param content     <#content description#>
 * @param length      <#length description#>
 * @param block       <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUploadKotaApplyForCommentVoiceWithData:(NSData *)voice
                                       forKotaId:(NSString *)kotaId
                                     commentType:(NSString *)commentType
                                         content:(NSString *)content
                                          length:(int)length
                                        finished:(FinishDownLoadBlock)block;

@end
