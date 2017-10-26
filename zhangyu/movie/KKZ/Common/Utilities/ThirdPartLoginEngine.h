//
//  ThirdPartLoginEngine.h
//  KoMovie
//
//  Created by 艾广华 on 15/11/3.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

/**
 *  第三方登录请求
 *
 *  @param result 登陆成功与否
 */
typedef void(^callBack)(BOOL result);

/**
 *  第三方授权回调block
 *
 *  @param success 成功授权标志
 */
typedef void(^ThirdAccessCallBack)(BOOL success,NSString *title);

@interface ThirdPartLoginEngine : NSObject

/**
*  开始第三方登录
*
*  @param site           登录类型
*  @param dialogView     在哪个页面上显示加载框
*  @param resultCallBack 登录成功与否回调
*/
- (void) startThirdPartLog:(SiteType)site
            showDialogView:(UIView *)dialogView
                    result:(callBack)resultCallBack;


/**
 *  开始第三方授权(回调信息里包括字典)
 *
 *  @param site       <#site description#>
 *  @param dialogView <#dialogView description#>
 *  @param callBack   <#callBack description#>
 */
- (void) startThirdPartAccessWithSite:(SiteType)site
                       showDialogView:(UIView *)dialogView
                            WithBlock:(ThirdAccessCallBack)callBack;

/**
 *  分享内容到指定的平台
 *
 *  @param title          分享的标题
 *  @param content        分享的内容
 *  @param url            分享的URL
 *  @param imageURL       分享的内容前面的图片地址
 *  @param site           分享的平台
 *  @param dialogView     分享的加载显示的视图
 *  @param resultCallBack 分享的结果回调
 */
- (void)shareContentToThirdPartWithTitle:(NSString *)title
                                 Content:(NSString *)content
                                   withUrl:(NSString *)url
                                     image:(NSString *)imageURL
                                  WithSite:(ShareType)site
                            showDialogView:(UIView *)dialogView
                                    result:(callBack)resultCallBack;

/**
 *  判断是否安装微信
 *
 *  @return
 */
+ (BOOL)isWeixinInstall;

/**
 *  是否大于7天
 *
 *  @return 
 */
+ (BOOL)isLargeSevenDay;

/**
 *  退出所有的授权
 */
+ (void)signoutAllAuth;

@end
