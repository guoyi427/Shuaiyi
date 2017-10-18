//
//  UIConstants.m
//  CIASMovie
//
//  Created by cias on 2016/12/8.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "UIConstants.h"
#import "CIASActivityIndicatorView.h"
#import <Social/Social.h>

static UIConstants *uiConstantsEngine = nil;
@interface UIConstants ()<CIASActivityIndicatorViewDelegate>

@property (nonatomic, strong) CIASActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;


@end
@implementation UIConstants

+ (UIConstants *)sharedDataEngine {
    @synchronized(self) {
        if (!uiConstantsEngine) {
            uiConstantsEngine = [[UIConstants alloc] init];
        }
    }
    return uiConstantsEngine;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.tabbarBackgroundColor = @"#FFFFFF";
        self.tabbarLineColor = @"#8B8482";
        
        self.navigationBarBackgroundColor = @"#333333";
        self.navigationBarTitleColor = @"#FFFFFF";
        self.navigationBarLineColor = @"#B9B9B9";
        
        self.viewControllerBackgroundColor = @"#FFFFFF";
        self.tableviewBackgroundColor = @"#F2F5F5";
        self.scrollviewBackgroundColor = @"#FFFFFF";
        self.withColor = @"#FFCC00";
        self.lineColor = @"#f2f2f2";
        self.splashBackgroundColor = @"#ffffff";
        self.planBtnColor = @"#ff9900";
        
        #if K_HUACHEN
            self.lumpColor = @"#3d8af7";
            self.btnColor = @"#3d8af7";
            self.btnCharacterColor = @"#ffffff";
            self.characterColor = @"#99ccff";
        
            self.tabSelectedColor = @"#3d8af7";
            self.tabNonSelectedColor = @"#b2b2b2";
        #elif K_XINGYI
            self.lumpColor = @"#FFCC00";
            self.btnColor = @"#FFCC00";
            self.btnCharacterColor = @"#333333";
            self.characterColor = @"#FFCC00";
        
            self.tabSelectedColor = @"#333333";
            self.tabNonSelectedColor = @"#b2b2b2";
        #elif K_HENGDIAN
            self.lumpColor = @"#e23f3d";
            self.btnColor = @"#e23f3d";
            self.btnCharacterColor = @"#ffffff";
            self.characterColor = @"#e23f3d";
            
            self.tabSelectedColor = @"#333333";
            self.tabNonSelectedColor = @"#b2b2b2";
            self.navigationBarBackgroundColor = @"#ffffff";
            self.navigationBarTitleColor = @"#e23f3d";
            self.planBtnColor = @"#e23f3d";
        #elif K_BAOSHAN
            self.lumpColor = @"#FFCC00";
            self.btnColor = @"#FFCC00";
            self.btnCharacterColor = @"#333333";
            self.characterColor = @"#FFCC00";
            
            self.tabSelectedColor = @"#333333";
            self.tabNonSelectedColor = @"#b2b2b2";
        #elif K_ZHONGDU
            self.lumpColor = @"#FFCC00";
            self.btnColor = @"#FFCC00";
            self.btnCharacterColor = @"#333333";
            self.characterColor = @"#FFCC00";
        
            self.tabSelectedColor = @"#333333";
            self.tabNonSelectedColor = @"#b2b2b2";
        #else
            self.lumpColor = @"#FFCC00";
            self.btnColor = @"#FFCC00";
            self.btnCharacterColor = @"#333333";
            self.characterColor = @"#FFCC00";
        
            self.tabSelectedColor = @"#333333";
            self.tabNonSelectedColor = @"#b2b2b2";
        #endif
        
    }
    return self;
}

- (void) loadingAnimation {
    [[UIApplication sharedApplication].keyWindow addSubview:self.activityIndicatorView];
}

- (void) stopLoadingAnimation {
    if (self.activityIndicatorView) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}


- (UIView *) activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        _activityIndicatorView.userInteractionEnabled = YES;
        [_activityIndicatorView addSubview:self.activityIndicator];
    }
    return _activityIndicatorView;
}

- (CIASActivityIndicatorView *) activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[CIASActivityIndicatorView alloc] init];
        _activityIndicator.center = CGPointMake(kCommonScreenWidth/2, kCommonScreenHeight/2);
        _activityIndicator.delegate = self;
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}



#pragma mark - Public
+ (BOOL)shareWithType:(UIConstantsShareType)type andController:(UIViewController *)controller andItems:(NSArray *)items
{
    return [[UIConstants sharedDataEngine] shareWithType:type andController:controller andItems:items];
}

- (BOOL)shareWithType:(UIConstantsShareType)type andController:(UIViewController *)controller andItems:(NSArray *)items
{
    //分享对象
    
    //判断分享类型
    if(type==0)
    {
        UIActivityViewController * activityCtl = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        [controller presentViewController:activityCtl animated:YES completion:nil];
        return YES;
    }
    
    NSString * serviceType = [self serviceTypeWithType:type];
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    // 添加要分享的图片
    
    for ( id obj in items)
    {
        if ([obj isKindOfClass:[UIImage class]])
        {
            [composeVC addImage:(UIImage *)obj];
        }
        else if ([obj isKindOfClass:[NSURL class]])
        {
            [composeVC addURL:(NSURL *)obj];
        }
        
    }
    
    // 添加要分享的文字
    [composeVC setInitialText:@"分享"];
    
    // 弹出分享控制器
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            DLog(@"点击了发送");
        }
        else if (result == SLComposeViewControllerResultCancelled)
        {
            DLog(@"点击了取消");
        }
    };
    
    
    @try
    {
        [controller presentViewController:composeVC animated:YES completion:nil];
        return YES;
        
    } @catch (NSException *exception)
    {
        DLog(@"没有安装");
        return NO;
        
    } @finally {
        
    }
    
    return YES;
}


#pragma mark - Private
- (NSString *)serviceTypeWithType:(UIConstantsShareType)type
{
    //这个方法不再进行校验,传入就不等于0.这里做一个转换
    NSString * serviceType;
    if ( type!= 0)
    {
        switch (type)
        {
            case UIConstantsShareTypeWeChat:
                serviceType = @"com.tencent.xin.sharetimeline";
                break;
            case UIConstantsShareTypeQQ:
                serviceType = @"com.tencent.mqq.ShareExtension";
                break;
            default:
                break;
        }
    }
    return serviceType;
}



/*
 <NSExtension: 0x1741735c0> {id = com.apple.share.Flickr.post}",
 "<NSExtension: 0x174173740> {id = com.taobao.taobao4iphone.ShareExtension}",
 "<NSExtension: 0x174173a40> {id = com.apple.reminders.RemindersEditorExtension}",
 "<NSExtension: 0x174173bc0> {id = com.apple.share.Vimeo.post}",
 "<NSExtension: 0x174173ec0> {id = com.apple.share.Twitter.post}",
 "<NSExtension: 0x174174040> {id = com.apple.mobileslideshow.StreamShareService}",
 "<NSExtension: 0x1741741c0> {id = com.apple.Health.HealthShareExtension}",
 "<NSExtension: 0x1741744c0> {id = com.apple.mobilenotes.SharingExtension}",
 "<NSExtension: 0x174174640> {id = com.alipay.iphoneclient.ExtensionSchemeShare}",
 "<NSExtension: 0x174174880> {id = com.apple.share.Facebook.post}",
 "<NSExtension: 0x174174a00> {id = com.apple.share.TencentWeibo.post}
 */

/*
 "<NSExtension: 0x174174340> {id = com.tencent.xin.sharetimeline}", //微信
 "<NSExtension: 0x174173d40> {id = com.tencent.mqq.ShareExtension}", //QQ
 "<NSExtension: 0x1741738c0> {id = com.apple.share.SinaWeibo.post}", //微博
 */


@end
