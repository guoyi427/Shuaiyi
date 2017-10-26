//
//  ShareView.h
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "ShareEngine.h"
#import "StatisticsTask.h"

@protocol HideCoverViewDelegate <NSObject>

- (void)hideCoverView;

@end

@class ShareView;

@interface ShareView : UIView <UIGestureRecognizerDelegate> {
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id<HideCoverViewDelegate> delegateY;
@property (nonatomic, assign) BOOL isScore;
@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) int voiceLength;
@property (nonatomic, assign) int score;
@property (nonatomic, copy) NSString *userShareInfo;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)show;
- (void)dismiss;

/**
 *  <#Description#>
 *
 *  @param content      <#content description#>
 *  @param contentWeChat 微信分享的内容
 *  @param title        （人人和qq空间不能为nil）
 *  @param image        <#image description#>
 *  @param imageURL      为qq空间准备的图片路径
 *  @param url          <#url description#>
 *  @param sUrl         <#sUrl description#>
 *  @param viewDelegate <#viewDelegate description#>
 *  @param mediaType    <#mediaType description#>
 *  @param stype        分享统计相关
 *  @param si           分享统计相关.//影片id，评论id，歌曲id，台词id。  kotaid。没有个人主页id
 */
- (void)updateWithcontent:(NSString *)content
            contentWeChat:(NSString *)contentWeChat
           contentQQSpace:(NSString *)contentQQSpace
                    title:(NSString *)title
                imagePath:(UIImage *)image
                 imageURL:(NSString *)imageURL
                      url:(NSString *)url
                 soundUrl:(NSString *)sUrl
                 delegate:(id)viewDelegate
                mediaType:(SSPublishContentMediaType)mediaType
           statisticsType:(StatisticsType)stype
                shareInfo:(NSString *)si
                sharedUid:(NSString *)uid;

/**
 * <#Description#>
 *
 * @param content        <#content description#>
 * @param contentWeChat  <#contentWeChat description#>
 * @param contentQQSpace <#contentQQSpace description#>
 * @param title          <#title description#>
 * @param image          <#image description#>
 * @param url            <#url description#>
 * @param sUrl           <#sUrl description#>
 * @param viewDelegate   <#viewDelegate description#>
 * @param mediaType      <#mediaType description#>
 * @param stype          <#stype description#>
 */
- (void)updateWithcontent:(NSString *)content
            contentWeChat:(NSString *)contentWeChat
           contentQQSpace:(NSString *)contentQQSpace
                    title:(NSString *)title
                imagePath:(UIImage *)image
                      url:(NSString *)url
                 soundUrl:(NSString *)sUrl
                 delegate:(id)viewDelegate
                mediaType:(SSPublishContentMediaType)mediaType
           statisticsType:(StatisticsType)stype;

@end
