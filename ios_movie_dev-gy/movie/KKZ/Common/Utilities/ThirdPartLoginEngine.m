//
//  ThirdPartLoginEngine.m
//  KoMovie
//
//  Created by 艾广华 on 15/11/3.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//


#import "DataEngine.h"
#import "KKZUtility.h"
#import "KotaTask.h"
#import "TaskQueue.h"
#import "ThirdPartLoginEngine.h"
#import "UserDefault.h"
#import "UserManager.h"
#import "UserRequest.h"
#import "WXApi.h"

@interface ThirdPartLoginEngine ()

/**
 *  第三方登录类型
 */
@property (nonatomic, assign) SiteType siteType;

/**
 *  分享的图片地址
 */
@property (nonatomic, strong) NSString *shareImgURL;

/**
 *  分享的URL
 */
@property (nonatomic, strong) NSString *shareUrl;

/**
 *  分享的内容
 */
@property (nonatomic, strong) NSString *shareContent;

/**
 *  分享的标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 *  分享的类型
 */
@property (nonatomic, assign) ShareType shareType;

/**
 *  登陆状态回调
 */
@property (nonatomic, strong) callBack responseCallBack;

/**
 *  显示加载框的视图
 */
@property (nonatomic, weak) UIView *showDialogView;

/**
 *  第三方授权回调
 */
@property (nonatomic, strong) ThirdAccessCallBack thirdCallBack;

@end

@implementation ThirdPartLoginEngine

- (void)startThirdPartLog:(SiteType)site
           showDialogView:(UIView *)dialogView
                   result:(callBack)resultCallBack {

    //对传进来的变量进行赋值
    self.siteType = site;
    self.responseCallBack = resultCallBack;
    self.showDialogView = dialogView;

    //判断登录类型
    ShareType shareType;
    switch (site) {
        case SiteTypeWX: {
            shareType = ShareTypeWeixiSession;
            [self cancelWeixiSessionAuth];
            break;
        }
        case SiteTypeQQ: {
            shareType = ShareTypeQQSpace;
            [self cancelQQSpaceoAuth];
            break;
        }
        case SiteTypeSina: {
            shareType = ShareTypeSinaWeibo;
            [self cancelSinaWeiboAuth];
            break;
        }
        default:
            shareType = 0;
            break;
    }

    if (shareType == 0) {
        return;
    }

    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"正在登录"
                                atView:dialogView];

    //创建授权选项
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:NO //自动授权标志
                                                         allowCallback:YES //是否允许授权后回调到服务器
                                                                scopes:nil
                                                         powerByHidden:YES //版权信息隐藏标识
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal //授权视图样式
                                                          viewDelegate:nil //授权视图协议委托
                                               authManagerViewDelegate:nil]; //授权管理器视图协议委托

    //获取用户个人资料
    [ShareSDK getUserInfoWithType:shareType
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                               //有授权过期的情况需要处理
                               if (result) {

                                   //统计事件：用户登录
                                   StatisEvent(EVENT_USER_LOGIN);

                                   //授权登录
                                   id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];
                                   
                                   [[UserManager shareInstance] login:[userInfo uid] password:[credential token] site:site success:^(UserLogin * _Nullable userLogin) {
                                       [self handleLoginFinishedNotification:TRUE];

                                   } failure:^(NSError * _Nullable err) {
                                       [self handleLoginFailsNotification];
                                   }];
                                   
                               } else {

                                   //失败回调
                                   self.responseCallBack(NO);

                                   //隐藏加载框
                                   [KKZUtility hidenIndicator];

                                   //回调错误判断
                                   if ([error.errorDescription isEqualToString:@"尚未安装微信"]) {
                                       [self showAlertMainThread];
                                   } else {
                                       [self showFailAlert:@"登录授权失败，请您稍后重试"];
                                   }
                               }
                           }];
}

- (void)shareContentToThirdPartWithTitle:(NSString *)title
                                 Content:(NSString *)content
                                 withUrl:(NSString *)url
                                   image:(NSString *)imageURL
                                WithSite:(ShareType)site
                          showDialogView:(UIView *)dialogView
                                  result:(callBack)resultCallBack {

    id<ISSContent> publishContent = nil;
    publishContent = [ShareSDK content:content
                        defaultContent:@"章鱼电影"
                                 image:[ShareSDK imageWithUrl:imageURL]
                                 title:title
                                   url:url
                           description:content
                             mediaType:SSPublishContentMediaTypeNews];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"章鱼电影_官方"],
                                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                                         [ShareSDK userFieldWithType:SSUserFieldTypeName
                                                                               value:@"章鱼电影"],
                                                         SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                                         nil]];

    self.responseCallBack = resultCallBack;
    self.shareType = site;
    self.shareImgURL = imageURL;
    self.shareUrl = url;
    self.shareContent = content;
    self.shareTitle = title;
    self.showDialogView = dialogView;

    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"正在分享"
                                atView:dialogView];

    //取消授权
    if (![ShareSDK hasAuthorizedWithType:ShareTypeQQSpace] && site == ShareTypeQQSpace) {

        ShareType shareType;
        shareType = ShareTypeQQSpace;
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:NO //自动授权标志
                                                             allowCallback:YES //是否允许授权后回调到服务器
                                                                    scopes:nil
                                                             powerByHidden:YES //版权信息隐藏标识
                                                            followAccounts:nil
                                                             authViewStyle:SSAuthViewStyleModal //授权视图样式
                                                              viewDelegate:nil //授权视图协议委托
                                                   authManagerViewDelegate:nil]; //授权管理器视图协议委托

        //获取用户个人资料
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                                   //有授权过期的情况需要处理
                                   if (result) {
                                       [self shareContentToThirdPartWithTitle:self.shareTitle
                                                                        Content:self.shareContent
                                                                        withUrl:self.shareUrl
                                                                          image:self.shareImgURL
                                                                       WithSite:self.shareType
                                                                 showDialogView:self.showDialogView
                                                                         result:self.responseCallBack];
                                   } else {
                                       //隐藏加载框
                                       [KKZUtility hidenIndicator];
                                       [self showFailAlert:@"登录授权失败，请您稍后重试"];
                                   }
                               }];
        return;
    }

    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:site
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [KKZUtility showIndicatorWithTitle:@"分享中"];
                        }
                        if (state == SSResponseStateSuccess) {
                            [KKZUtility hidenIndicator];
                            [KKZUtility showAlert:@"分享成功"];
                        } else if (state == SSResponseStateFail) {
                            [KKZUtility hidenIndicator];
                            if ([[error errorDescription] isEqualToString:@"尚未安装QQ"]) {
                                [KKZUtility showAlert:@"尚未安装QQ"];
                            } else if ([[error errorDescription] isEqualToString:@"ERROR_DESC_QZONE_NOT_INSTALLED"]) {
                                [KKZUtility showAlert:@"目前只支持QQ客户端登录，您还未安装QQ客户端"];
                            } else if ([[error errorDescription] isEqualToString:@"尚未安装微信"]) {
                                [KKZUtility showAlert:@"尚未安装微信"];
                            } else
                                [KKZUtility showAlert:@"分享失败,建议不要频繁分享或者重复分享"];
                        } else if (state == SSResponseStateCancel) {
                            [KKZUtility hidenIndicator];
                            //                            [KKZUtility showAlert:@"取消分享"];
                        }
                    }];
}

- (void)showAlertView {
    [self performSelectorOnMainThread:@selector(showAlertMainThread)
                             withObject:nil
                          waitUntilDone:NO];
}

- (void)showAlertMainThread {

    __weak ThirdPartLoginEngine *weak_self = self;
    [KKZUtility showAlertTitle:@"登录失败"
                        detail:@"尚未检测到微信客户端,请使用其他方式登录,我们推荐你使用QQ登录?"
                        cancel:@"否"
                     clickCall:^(NSInteger buttonIndex) {
                         if (buttonIndex == 1) {
                             [self startThirdPartLog:SiteTypeQQ
                                        showDialogView:self.showDialogView
                                                result:self.responseCallBack];
                         } else {
                             weak_self.responseCallBack = nil;
                         }
                     }
                        others:@"是"];
}

- (void)showFailAlert:(NSString *)title {
    [self performSelectorOnMainThread:@selector(showFailMainThreadAlert:)
                             withObject:title
                          waitUntilDone:NO];
}

- (void)showFailMainThreadAlert:(NSString *)title {
    [KKZUtility showAlertTitle:@""
                        detail:title
                        cancel:@"确定"
                     clickCall:nil
                        others:nil];
}

- (void)startThirdPartAccessWithSite:(SiteType)site
                      showDialogView:(UIView *)dialogView
                           WithBlock:(ThirdAccessCallBack)callBack {

    self.siteType = site;
    self.thirdCallBack = callBack;
    ShareType shareType;
    switch (site) {
        case SiteTypeWX: {
            [self cancelWeixiSessionAuth];
            shareType = ShareTypeWeixiSession;
            break;
        }
        case SiteTypeQQ: {
            [self cancelQQSpaceoAuth];
            shareType = ShareTypeQQSpace;
            break;
        }
        case SiteTypeSina: {
            [self cancelSinaWeiboAuth];
            shareType = ShareTypeSinaWeibo;
            break;
        }
        case SiteTypeQQSpace: {
            [self cancelQQSpaceoAuth];
            shareType = ShareTypeQQSpace;
            break;
        }
        default:
            shareType = 0;
            break;
    }

    if (shareType == 0) {
        return;
    }

    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"正在授权"
                                atView:dialogView];

    //创建授权选项
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:NO //自动授权标志
                                                         allowCallback:YES //是否允许授权后回调到服务器
                                                                scopes:nil
                                                         powerByHidden:YES //版权信息隐藏标识
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal //授权视图样式
                                                          viewDelegate:nil //授权视图协议委托
                                               authManagerViewDelegate:nil]; //授权管理器视图协议委托

    //获取用户个人资料
    [ShareSDK getUserInfoWithType:shareType
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                               //有授权过期的情况需要处理
                               if (result) {

                                   //授权
                                   id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];
                                   //绑定授权信息
                                   UserRequest *request = [UserRequest new];
                                   [request bindAccount:site
                                           thirdId:[userInfo uid]
                                           token:[credential token]
                                           success:^{
                                               dispatch_async(dispatch_get_main_queue(), ^{

                                                   //隐藏加载框
                                                   [KKZUtility hidenIndicator];

                                                   //回调函数
                                                   self.thirdCallBack(YES, nil);
                                               });
                                           }
                                           failure:^(NSError *_Nullable err) {
                                               dispatch_async(dispatch_get_main_queue(), ^{

                                                   //隐藏加载框
                                                   [KKZUtility hidenIndicator];

                                                   //回调函数
                                                   self.thirdCallBack(NO, err.userInfo[KKZRequestErrorMessageKey]);
                                               });
                                           }];

                               } else {

                                   //隐藏加载框
                                   [KKZUtility hidenIndicator];

                                   if ([error.errorDescription isEqualToString:@"尚未安装微信"]) {

                                       //显示失败的加载框
                                       [self showFailAlert:@"您尚未安装微信"];
                                   } else {

                                       //显示失败的加载框
                                       [self showFailAlert:@"登录授权失败，请您稍后重试"];
                                   }
                               }
                           }];
}

/**
 *  处理登录成功之后的逻辑
 *
 *  @param notification
 */
- (void)handleLoginFinishedNotification:(BOOL)success {

    //隐藏加载框
    [KKZUtility hidenIndicator];

    // 正常登陆条件，或者第三方登陆条件
    if (success) {

        //注册推送通知
        [self rigistKotaPush];

        //先回调
        if (self.responseCallBack) {
            self.responseCallBack(TRUE);
        }
    } else {
        if (self.responseCallBack) {
            self.responseCallBack(FALSE);
        }
        [appDelegate showAlertViewForTitle:@""
                                   message:@"登录失败"
                              cancelButton:@"确定"];
    }
}

/**
 *  登录失败
 */
- (void)handleLoginFailsNotification {

    //隐藏加载框
    [KKZUtility hidenIndicator];
    if (self.responseCallBack) {
        self.responseCallBack(FALSE);
    }
}

/**
 *  获取用户资料
 */
- (void)getUserDetailTask {
    KotaTask *task = [[KotaTask alloc] initUserDetail:[DataEngine sharedDataEngine].userId.intValue
                                             finished:^(BOOL succeeded, NSDictionary *userInfo){

                                             }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

/**
 *  注册推送通知
 */
- (void)rigistKotaPush {
    UserRequest *request = [UserRequest new];
    [request updateUserPosition];
}

+ (BOOL)isWeixinInstall {
    if ([WXApi isWXAppInstalled]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLargeSevenDay {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:date];
    NSArray *compareArr = @[ @2016, @1, @27 ];
    NSArray *currentArr = [currentDate componentsSeparatedByString:@"-"];
    if ([currentArr[0] intValue] == [compareArr[0] intValue] && (([currentArr[1] intValue] == [compareArr[1] intValue] && [currentArr[2] intValue] > [compareArr[2] intValue]) || [currentArr[1] intValue] > [compareArr[1] intValue])) {
        return YES;
    }
    return NO;
}

/**
 *  取消微信授权
 */
- (void)cancelWeixiSessionAuth {
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
}

/**
 *  取消新浪微博授权
 */
- (void)cancelSinaWeiboAuth {
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
}

/**
 *  取消QQ空间授权
 */
- (void)cancelQQSpaceoAuth {
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
}

/**
 *  取消所有授权
 */
- (void)cancelAllAuth {
    [self cancelWeixiSessionAuth];
    [self cancelSinaWeiboAuth];
    [self cancelQQSpaceoAuth];
}

+ (void)signoutAllAuth {
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeRenren];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
}

/**
 *  变量释放
 */
- (void)dealloc {
}

@end
