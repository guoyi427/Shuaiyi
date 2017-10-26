//
//  ShareEngine.m
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//

#import "ShareEngine.h"
#import "Constants.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "StatisticsTask.h"
#import "DataManager.h"
#import "TaskQueue.h"
#import "KKZUserTask.h"
#import "DataEngine.h"
#import "KKZUtility.h"

static ShareEngine *_shareEngine = nil;

@interface ShareEngine ()

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *sUrl;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) int mediaType;
@property (nonatomic, assign) ShareType type;

@end

@implementation ShareEngine

+ (ShareEngine *)shareEngine {
    @synchronized(self) {
        if (!_shareEngine) {
            _shareEngine = [[ShareEngine alloc] init];
        }
    }
    return _shareEngine;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//新浪腾讯微博公用
- (void)shareToSinaWeiBo:(NSString *)content
                   title:(NSString *)title
                   image:(UIImage *)image
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type {
    //创建分享内容
    self.content = content;
    self.image = image;
    self.title = title;
    self.url = url;
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:url
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeText];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewDelegate];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO

                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate popViewControllerAnimated:YES];

                            [self shareStatisticsWithType:type];

                            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareSucceed" object:nil];
                        } else if (state == SSResponseStateFail) {
                            NSString *errorStr = [error errorDescription];
                            NSLog(@"errorStr==%@", errorStr);
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享失败,建议不要频繁分享或者重复分享" cancelButton:@"OK"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareFailed" object:nil];

                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                        }
                    }];
}

- (void)shareToQQWeiBo:(NSString *)content
                 title:(NSString *)title
                 image:(UIImage *)image
                   url:(NSString *)url
              delegate:(id)viewDelegate
             mediaType:(SSPublishContentMediaType)mediaType
                  type:(ShareType)type {

    //创建分享内容
    self.content = content;
    self.image = image;
    self.title = title;
    self.url = url;
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:url
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeText];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewDelegate];

    //    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
    //                                                         allowCallback:NO
    //                                                                scopes:nil
    //                                                         powerByHidden:YES
    //                                                        followAccounts:nil
    //                                                         authViewStyle:SSAuthViewStyleModal
    //                                                          viewDelegate:nil
    //                                               authManagerViewDelegate:nil];

    //创建弹出菜单容器

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO

                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate popViewControllerAnimated:YES];

                            [self shareStatisticsWithType:type];
                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享失败！" cancelButton:@"OK"];

                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                        }
                    }];
}

- (void)inviteFromWeiBo:(NSString *)content
               username:(NSString *)username
                  title:(NSString *)title
                  image:(UIImage *)image
                    url:(NSString *)url
               delegate:(id)viewDelegate
              mediaType:(SSPublishContentMediaType)mediaType
                   type:(ShareType)type {

    //创建分享内容
    self.content = content;
    self.image = image;
    self.title = title;
    self.url = url;
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewDelegate];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"邀请中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"已邀请！" cancelButton:@"OK"];
                            [appDelegate sendShareViewControllerToBack];
                            DLog(@" statusInfo  %@", statusInfo.sourceData);
                            KKZUserTask *invitedTask = [[KKZUserTask alloc] initGetInvitedFriend:[DataEngine sharedDataEngine].sessionId username:username];
                            [[TaskQueue sharedTaskQueue] addTaskToQueue:invitedTask];

                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate showAlertViewForTitle:@"" message:@"邀请失败！" cancelButton:@"OK"];

                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                        }
                    }];
}

- (id<ISSContent>)view:(UIViewController *)viewController willPublishContent:(id<ISSContent>)content {
    NSString *userContent = [content content];
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",
                                                                                 userContent ? userContent : @"", self.url]
                                       defaultContent:@" "
                                                image:[ShareSDK pngImageWithImage:self.image]
                                                title:self.title
                                                  url:kAppHTML5Url
                                          description:@" "
                                            mediaType:SSPublishContentMediaTypeText];

    return publishContent;
}

- (void)shareToRenRen:(NSString *)content
                title:(NSString *)title
                image:(UIImage *)image
                  url:(NSString *)url
          description:(NSString *)description
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type {
    //创建分享内容
    self.content = content;
    self.image = image;
    self.title = title;
    self.url = url;
    if (content.length == 0) {
        content = @"抠电影";
    }
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];

    //    id<ISSContent> publishContent = [ShareSDK content:content
    //                                       defaultContent:nil
    //                                                image:[ShareSDK imageWithUrl:@"http://list.image.baidu.com/t/yingshi.jpg"]
    //                                                title:@"ShareSDK"
    //                                                  url:@"http://www.sharesdk.cn"
    //                                          description:@"这是一条测试信息"
    //                                            mediaType:SSPublishContentMediaTypeNews];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewDelegate];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
    //                                                         allowCallback:NO
    //                                                                scopes:nil
    //                                                         powerByHidden:YES
    //                                                        followAccounts:nil
    //                                                         authViewStyle:SSAuthViewStyleModal
    //                                                          viewDelegate:nil
    //                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate popViewControllerAnimated:YES];

                            [self shareStatisticsWithType:type];

                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享失败！" cancelButton:@"OK"];

                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            DLog(@"发布失败!error code == %ld, error code == %@", (long) [error errorCode], [error errorDescription]);
                        }
                    }];
}

- (void)shareToQZone:(NSString *)content
               title:(NSString *)title
               image:(UIImage *)image
            imageURL:(NSString *)imageURL
                 url:(NSString *)url
            delegate:(id)viewDelegate
           mediaType:(SSPublishContentMediaType)mediaType
                type:(ShareType)type {

    //创建分享内容
    self.content = content;
    self.image = image;
    self.title = title;
    self.url = url;
    self.type = type;
    self.imageURL = imageURL;

    //如果已授权
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {

        [self toShareQQSpace];

    } else {
        [self toAuthorizedQQSpace];
    }
}

//分享qq空间
- (void)toShareQQSpace {

    id<ISSContent> publishContent = nil;
    //    if (self.imageURL && self.imageURL.length > 0) {
    publishContent = [ShareSDK content:self.content
                        defaultContent:@"抠电影"
                                 image:[ShareSDK imageWithUrl:self.imageURL]
                                 title:self.title
                                   url:self.url
                           description:self.content
                             mediaType:SSPublishContentMediaTypeNews];

    ////}else{
    //        CGSize newSize = CGSizeMake(self.image.size.width/2, self.image.size.height/2);
    //        UIGraphicsBeginImageContext(newSize);
    //        [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    //        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //
    //
    //        publishContent = [ShareSDK content:self.content
    //                            defaultContent:@"抠电影"
    //                                     image:[ShareSDK pngImageWithImage:newImage]
    //                                     title:self.title
    //                                       url:self.url
    //                               description:self.content
    //                                 mediaType:SSPublishContentMediaTypeNews];
    ////    }

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:nil];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:self.type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];
                            //                            [KKZUtility showAlertTitle:@"分享成功！"
                            //                                                detail:@""
                            //                                                cancel:@"OK"
                            //                                             clickCall:nil
                            //                                                others:nil];
                            [self shareStatisticsWithType:type];
                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];

                            if ([[error errorDescription] isEqualToString:@"尚未安装QQ"]) {
                                [KKZUtility showAlertTitle:@"尚未安装QQ"
                                                    detail:@""
                                                    cancel:@"OK"
                                                 clickCall:nil
                                                    others:nil];
                            } else
                                [KKZUtility showAlertTitle:@"分享失败！"
                                                    detail:@""
                                                    cancel:@"OK"
                                                 clickCall:nil
                                                    others:nil];
                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            DLog(@"发布失败!error code == %ld, error code == %@", (long) [error errorCode], [error errorDescription]);
                        }
                    }];
}
//授权qq空间
- (void)toAuthorizedQQSpace {
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    [ShareSDK getUserInfoWithType:self.type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                               if (result) {
                                   //                                           [item setObject:[userInfo nickname] forKey:@"username"];
                                   //                                           [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                   [self toShareQQSpace];
                               } else {
                                   [appDelegate hideIndicator];
                                   //                                   [appDelegate sendShareViewControllerToBack];

                                   NSString *mesg;

                                   if ([[error errorDescription] isEqualToString:@"ERROR_DESC_QZONE_NOT_INSTALLED"]) {

                                       mesg = @"目前只支持QQ客户端登录，您还未安装QQ客户端";

                                   } else {
                                       mesg = @"分享失败！";
                                   }

                                   [KKZUtility showAlertTitle:mesg
                                                       detail:@""
                                                       cancel:@"OK"
                                                    clickCall:nil
                                                       others:nil, nil];

                                   //                                   [appDelegate showAlertViewForTitle:@"" message:mesg cancelButton:@"OK"];
                               }

                           }];
}

- (void)shareToWeiXin:(NSString *)content
                title:(NSString *)title
                image:(UIImage *)image
                  url:(NSString *)url
             soundUrl:(NSString *)sUrl
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type {
    //    if ([[image class]isSubclassOfClass:[UIImage class]]) {
    //
    //        newImage = image;
    //    }

    CGSize newSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK pngImageWithImage:newImage]
                                                title:title
                                                  url:url
                                          description:nil
                                            mediaType:mediaType];
    DLog(@"%d %d %@ %@ %@ %@", type, mediaType, content, title, url, newImage);

    float kCompressionQuality = 0.1;
    NSData *photo = UIImageJPEGRepresentation(newImage, kCompressionQuality);

    UIImage *thumbImage = [UIImage imageWithData:photo];

    if (type == ShareTypeWeixiSession) {
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:INHERIT_VALUE
                                               title:INHERIT_VALUE
                                                 url:INHERIT_VALUE
                                          thumbImage:[ShareSDK pngImageWithImage:thumbImage]
                                               image:INHERIT_VALUE
                                        musicFileUrl:sUrl
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
    } else if (type == ShareTypeWeixiTimeline) {
        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                              content:title
                                                title:content
                                                  url:INHERIT_VALUE
                                           thumbImage:[ShareSDK pngImageWithImage:thumbImage]
                                                image:INHERIT_VALUE
                                         musicFileUrl:sUrl
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
    }

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        } else if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];

                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];

                            [self shareStatisticsWithType:type];
                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            if ([error errorCode] == -22003) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"知道了"
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            DLog(@"发布失败!error code == %ld, error code == %@", (long) [error errorCode], [error errorDescription]);
                        }

                    }];
}

//分享统计
- (void)shareStatisticsWithType:(ShareType)type {
    if ([DataManager shareDataManager].isStatistics) {
        StatisticsType stype = [DataManager shareDataManager].statisticsType;
        NSString *shareInfo = [DataManager shareDataManager].shareInfo;
        NSString *sharedUid = [DataManager shareDataManager].sharedUid;
        ChannelType ctype = 0;

        switch (type) {
            case ShareTypeQQSpace:
                ctype = ChannelTypeQQSpace;
                break;
            case ShareTypeRenren:
                ctype = ChannelTypeRenren;
                break;
            case ShareTypeSinaWeibo:
                ctype = ChannelTypeSina;
                break;
            case ShareTypeTencentWeibo:
                ctype = ChannelTypeWeibo;
                break;
            case ShareTypeWeixiSession:
                ctype = ChannelTypeWeChat;
                break;
            case ShareTypeWeixiTimeline:
                ctype = ChannelTypeWeChatTimeline;
                break;
            default:
                break;
        }

        StatisticsTask *task = [[StatisticsTask alloc] initStatisticsShareByType:stype
                                                                 withChannelType:ctype
                                                                   withSharedUid:sharedUid
                                                                   withShareInfo:shareInfo
                                                                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                            DLog(@"分享统计ok");
                                                                        }];
        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
    }
    //    [DataManager shareDataManager].isStatistics = NO;
}

//对图片尺寸进行压缩--
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];

    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}

- (void)shareToSinaWeiBo:(NSString *)content
                   title:(NSString *)title
                imageUrl:(NSString *)imageUrl
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type {

    //创建分享内容
    self.content = content;
    self.title = title;
    self.url = url;
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeText];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewDelegate];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"抠电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO

                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        }
                        if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate popViewControllerAnimated:YES];

                            [self shareStatisticsWithType:type];
                        } else if (state == SSResponseStateFail) {
                            DLog(@"error ====  error  %@", error);
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                            [appDelegate showAlertViewForTitle:@"" message:@"分享失败！" cancelButton:@"OK"];

                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            [appDelegate sendShareViewControllerToBack];
                        }
                    }];
}

- (void)shareToWeiXin:(NSString *)content
                title:(NSString *)title
             imageUrl:(NSString *)imageUrl
                  url:(NSString *)url
             soundUrl:(NSString *)sUrl
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type {

    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:nil
                                            mediaType:mediaType];

    if (type == ShareTypeWeixiSession) {
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:INHERIT_VALUE
                                               title:INHERIT_VALUE
                                                 url:INHERIT_VALUE
                                          thumbImage:[ShareSDK imageWithUrl:imageUrl]
                                               image:INHERIT_VALUE
                                        musicFileUrl:sUrl
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
    } else if (type == ShareTypeWeixiTimeline) {
        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                              content:title
                                                title:content
                                                  url:INHERIT_VALUE
                                           thumbImage:[ShareSDK imageWithUrl:imageUrl]
                                                image:INHERIT_VALUE
                                         musicFileUrl:sUrl
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
    }

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [appDelegate showIndicatorWithTitle:@"分享中"
                                                       animated:YES
                                                     fullScreen:NO
                                                   overKeyboard:YES
                                                    andAutoHide:NO];
                        } else if (state == SSResponseStateSuccess) {
                            [appDelegate hideIndicator];

                            [appDelegate showAlertViewForTitle:@"" message:@"分享成功！" cancelButton:@"OK"];

                            [self shareStatisticsWithType:type];
                        } else if (state == SSResponseStateFail) {
                            [appDelegate hideIndicator];
                            if ([error errorCode] == -22003) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"知道了"
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        } else if (state == SSResponseStateCancel) {
                            [appDelegate hideIndicator];
                            DLog(@"发布失败!error code == %ld, error code == %@", (long) [error errorCode], [error errorDescription]);
                        }

                    }];
}

- (void)shareToQZone:(NSString *)content
               title:(NSString *)title
            imageUrl:(NSString *)imageUrl
            imageURL:(NSString *)imageURL
                 url:(NSString *)url
            delegate:(id)viewDelegate
           mediaType:(SSPublishContentMediaType)mediaType
                type:(ShareType)type {

    //创建分享内容
    self.content = content;
    //    self.image = image;
    //    self.imageURL =
    self.title = title;
    self.url = url;
    self.type = type;
    self.imageURL = imageURL;

    //如果已授权
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {

        [self toShareQQSpace];

    } else {
        [self toAuthorizedQQSpace];
    }
}

@end
