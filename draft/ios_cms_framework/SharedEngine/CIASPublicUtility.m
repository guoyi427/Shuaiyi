//
//  CIASPublicUtility.m
//  CIASMovie
//
//  Created by cias on 2017/1/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CIASPublicUtility.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import <UMMobClick/MobClick.h>
#import "AppConfigureRequest.h"
#import "AppConfig.h"
#import "AppTemplate.h"

static CIASPublicUtility *_pulicObject;

@implementation CIASPublicUtility
+ (CIASPublicUtility *)sharedEngine{
    @synchronized(self) {
        if (!_pulicObject) {
            _pulicObject = [[CIASPublicUtility alloc] init];
        }
    }
    return _pulicObject;
    
}

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

//弹出alert
+ (void)showAlertViewForTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle {
    if ([message length] > 0) {
//        UIAlertController *alc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alc addAction:action];
//        [Constants.rootNav.topViewController presentViewController:alc animated:YES completion:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];

    }
}

//网络错误提示
+ (void)showAlertViewForTaskInfo:(NSError *)errorInfo{
    NSString *messsage = @"";
    messsage = [errorInfo.userInfo kkz_objForKey:@"kkz.error.message"];
    if (messsage.length<=0) {
        NSDictionary *responseDict = [errorInfo.userInfo kkz_objForKey:@"kkz.error.response"];
        messsage = [responseDict kkz_objForKey:@"error"];
    }
    if (messsage.length<=0) {
        //获取网络状态
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
            messsage = @"网络连接错误，请检查网络情况~";
        } else {
            messsage = @"获取信息失败，请重试";
        }
    }
    DLog(@"err messsage== %@", messsage);
    if (messsage.length>0) {
        [CIASPublicUtility showAlertViewForTitle:@"" message:messsage cancelButton:@"知道了"];
    }
}

+ (void)showMyAlertViewForTaskInfo:(NSError *)errorInfo {
    NSDictionary *userInfo = [errorInfo userInfo];
    
    NSDictionary *errInfo = [userInfo kkz_objForKey:@"kkz.error.response"];
    NSString *errStr = [errInfo kkz_stringForKey:@"error"];
    
    if (errStr.length <= 0) {
        //获取网络状态
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
            errStr = @"网络连接错误，请检查网络情况~";
        } else {
            errStr = @"获取信息失败，请重试";
        }
    }
    [[CIASAlertCancleView new] show:@"温馨提示" message:errStr cancleTitle:@"知道了" callback:^(BOOL confirm) {
    }];
}

+(NSURL *) getUrlDeleteChineseWithString:(NSString *)urlStr {
    NSString *urlString = @"";
    if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"%@", urlStr];
    }
    NSURL *requestUrl = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return requestUrl;
}

- (void)applyThirdPartySDK{
    /**
     WIFI只在WIFI开启时发送Dplus数据
     START_SEND_MODEL – 启动时发送：APP启动时发送本次启动时间和上次启动会话的所有缓存数据；本次会话产生的事件数据缓存在客户端，下次启动时发送。。如果启动时没有联网，那么数据仍会缓存在本地，下次启动时发送。
     INTERVAL_SEND_MODEL-间隔发送：按特定间隔发送数据，间隔时长介于90秒与24小时之间。
     */
//    [DplusMobClick setTokenProperty:kDplusKey model:START_SEND_MODEL wifi:YES];
//    //     [DplusMobClick setChannel:@"pugongying"];//将YOUR CHANNEL替换为您应用的推广渠道。不设置时，默认为App Store渠道。
//    [DplusMobClick setDebugStatus:YES]; //您就可以在Log中查看track事件的所有参数了
//    [DplusMobClick track:@"launch"];
    @try {
        /*
         *上版本SDK
         [MobClick startWithAppkey:kUMengKey
         reportPolicy:REALTIME
         channelId:[self channelId]];
         */
        [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
        [MobClick setLogEnabled:NO];
        UMConfigInstance.appKey = kUMengKey;
        UMConfigInstance.secret = @"komovieSecretUsing";
        [MobClick startWithConfigure:UMConfigInstance];
        if (Constants.launch3rdSDK) {
            [MobClick event:@"launch" label:[self channelId]];
        }
        [MobClick setCrashReportEnabled:YES];
        //self.idfaUrl = [MobClick getAdURL];
        // [MobClick checkUpdate];   //自动更新检查,
        
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
    
}
- (NSString *)channelId {
    return nil;
}

/////自动更新
- (void)checkAppUpdate
{
    //同步请求
    //NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //    1.设置请求路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/lookup?id=%@", kStoreAppId]];
    //    2.创建请求对象
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    3.发送请求
    //3.1发送同步请求，在主线程执行
    //    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
    
    //3.1发送异步请求
    //创建一个队列（默认添加到该队列中的任务异步执行）
    //NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    //获取一个主队列
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString * file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@", file);
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        if (substr.length<=0) {
            return;
        }
        
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        NSRange substr2 =[file rangeOfString:@"\"" options:0 range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        
        //AppStore上面的版本号
        NSString *newVersion =[file substringWithRange:range2];
        //当前ipa的版本号
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *nowVersion = [infoDict kkz_stringForKey:@"CFBundleShortVersionString"];
        
        NSArray *arr = [newVersion componentsSeparatedByString:@"."];
        NSArray *arr1 = [nowVersion componentsSeparatedByString:@"."];
        
        NSMutableString *arrStr = [[NSMutableString alloc]initWithCapacity:0];
        for (int i=0; i<arr.count; i++) {
            arrStr = (NSMutableString *)[arrStr stringByAppendingFormat:@"%@", [arr objectAtIndex:i]];
        }
        if (arrStr.length<3) {
            arrStr = (NSMutableString *)[arrStr stringByAppendingFormat:@"%d", 0];
        }
        NSMutableString *arr1Str = [[NSMutableString alloc] initWithCapacity:0];
        for (int j=0; j<arr1.count; j++) {
            arr1Str = (NSMutableString *)[arr1Str stringByAppendingFormat:@"%@", [arr1 objectAtIndex:j]];
        }
        if (arr1Str.length<3) {
            arr1Str = (NSMutableString *)[arr1Str stringByAppendingFormat:@"%d", 0];
        }
        NSString *preStr = [arrStr substringToIndex:2];
        NSString *preStr1 = [arr1Str substringToIndex:2];
        
        int num = arrStr.intValue;
        int num1 = arr1Str.intValue;
        if (num1>num) {
            if ([preStr isEqualToString:preStr1]) {
                //如果当前ipa大于AppStore的，审核当中的，就输出log
                self.kShowLog = @"0";
                //审核当中不显示第三方登录
                Constants.idfaUrl = nil;
                
            }else{
                //如果当前ipa大于AppStore的，审核当中的，就输出log
                self.kShowLog = @"1";
                //审核当中不显示第三方登录
                Constants.idfaUrl = [NSString stringWithFormat:@"%@",@"hidenThirdLogin"];
            }
            
        }else{
            //正式上线的都不输出log
            self.kShowLog = @"0";
            //审核过后显示第三方登录
            Constants.idfaUrl = nil;
            
        }
        if (num > num1) {
            [Constants.appDelegate.window addSubview:Constants.tmpView];
            AppConfigureRequest *request = [[AppConfigureRequest alloc] init];
            [request requestQueryTemplateParams:nil success:^(NSDictionary * _Nullable data) {
                DLog(@"基础配置接口：%@",data);
                AppTemplate *app = (AppTemplate *)data;
                NSDictionary *dict = app.all;
                NSString *titleL = [dict kkz_stringForKey:@"updateTitle"];
                NSString *titleM = [dict kkz_stringForKey:@"updateDesc"];
                NSString *updateLevel = [dict kkz_stringForKey:@"updateLevel"];
                if ([kKeyChainServiceName isEqual:@"xincheng"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新，为了不影响您的使用，请您更新"delegate:self cancelButtonTitle:@"更新"otherButtonTitles:nil];
                        //                    [alert show];
                        if ([updateLevel isEqualToString:@"0"]) {
                            [[CIASAlertImageCancelView new] show:titleL message:titleM image:[UIImage imageNamed:@"updata"] cancleTitle:@"更新" callback:^(BOOL confirm) {
                                if (!confirm) {
                                    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                    //            [[UIApplication sharedApplication] openURL:url];
                                    UIApplication *application = [UIApplication sharedApplication];
                                    
                                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    } else {
                                        [application openURL:url];
                                    }
                                }
                            }];
                        } else {
                            [[CIASAlertImageView new] show:titleL message:titleM image:[UIImage imageNamed:@"updata"] cancleTitle:@"取消" otherTitle:@"更新" callback:^(BOOL confirm) {
                                if (confirm) {
                                    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                    //            [[UIApplication sharedApplication] openURL:url];
                                    UIApplication *application = [UIApplication sharedApplication];
                                    
                                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    } else {
                                        [application openURL:url];
                                    }
                                } else {
                                    if (Constants.tmpView) {
                                        [Constants.tmpView removeFromSuperview];
                                        Constants.tmpView = nil;
                                    }
                                }
                            }];
                        }
                        
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新，为了不影响您的使用，请您更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                        //                    [alert show];
                        if ([updateLevel isEqualToString:@"0"]) {
                            [[CIASAlertImageCancelView new] show:titleL message:titleM image:[UIImage imageNamed:@"updata"] cancleTitle:@"更新" callback:^(BOOL confirm) {
                                if (!confirm) {
                                    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                    //            [[UIApplication sharedApplication] openURL:url];
                                    UIApplication *application = [UIApplication sharedApplication];
                                    
                                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    } else {
                                        [application openURL:url];
                                    }
                                }
                            }];
                        } else {
                            [[CIASAlertImageView new] show:titleL message:titleM image:[UIImage imageNamed:@"updata"] cancleTitle:@"取消" otherTitle:@"更新" callback:^(BOOL confirm) {
                                if (confirm) {
                                    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                    //            [[UIApplication sharedApplication] openURL:url];
                                    UIApplication *application = [UIApplication sharedApplication];
                                    
                                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    } else {
                                        [application openURL:url];
                                    }
                                } else {
                                    if (Constants.tmpView) {
                                        [Constants.tmpView removeFromSuperview];
                                        Constants.tmpView = nil;
                                    }
                                }
                            }];
                        }
                    });
                    
                }
                
            } failure:^(NSError * _Nullable err) {
                if ([kKeyChainServiceName isEqual:@"xincheng"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新，为了不影响您的使用，请您更新"delegate:self cancelButtonTitle:@"更新"otherButtonTitles:nil];
                        //                    [alert show];
                        
                        [[CIASAlertImageCancelView new] show:@"我们升级了！" message:@"新版本中添加了会员购票，可乐爆米花的购买\n让你拥有更贴心，更划算的观影体验" image:[UIImage imageNamed:@"updata"] cancleTitle:@"更新" callback:^(BOOL confirm) {
                            if (!confirm) {
                                // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                //            [[UIApplication sharedApplication] openURL:url];
                                UIApplication *application = [UIApplication sharedApplication];
                                
                                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                } else {
                                    [application openURL:url];
                                }
                            }
                        }];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新，为了不影响您的使用，请您更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                        //                    [alert show];
                        [[CIASAlertImageView new] show:@"我们升级了！" message:@"新版本中添加了会员购票，可乐爆米花的购买\n让你拥有更贴心，更划算的观影体验" image:[UIImage imageNamed:@"updata"] cancleTitle:@"取消" otherTitle:@"更新" callback:^(BOOL confirm) {
                            if (confirm) {
                                // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
                                //            [[UIApplication sharedApplication] openURL:url];
                                UIApplication *application = [UIApplication sharedApplication];
                                
                                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                } else {
                                    [application openURL:url];
                                }
                            } else {
                                if (Constants.tmpView) {
                                    [Constants.tmpView removeFromSuperview];
                                    Constants.tmpView = nil;
                                }
                            }
                        }];
                    });
                    
                }
            }];
            
        } else {
            if (Constants.tmpView) {
                [Constants.tmpView removeFromSuperview];
                Constants.tmpView = nil;
            }
        }
#ifdef DEBUG
        self.kShowLog = @"1";
#endif
        
        
    }];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([kKeyChainServiceName isEqual:@"xincheng"]) {
        if(buttonIndex==0)
        {
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
            //            [[UIApplication sharedApplication] openURL:url];
            UIApplication *application = [UIApplication sharedApplication];
            
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url];
            }
        }
    }else{
        if(buttonIndex==0){
            
        }else if(buttonIndex==1){
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]];
            //            [[UIApplication sharedApplication] openURL:url];
            UIApplication *application = [UIApplication sharedApplication];
            
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url];
            }
        }
    }
}


@end
