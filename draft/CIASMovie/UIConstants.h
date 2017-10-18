//
//  UIConstants.h
//  CIASMovie
//
//  Created by cias on 2016/12/8.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CIASActivityIndicatorView;

typedef NS_ENUM(NSInteger, UIConstantsShareType)
{
    UIConstantsShareTypeOthers,//其他
    UIConstantsShareTypeWeChat,//微信
    UIConstantsShareTypeQQ,//腾讯QQ
};

@interface UIConstants : NSObject 


//tabbar 背景颜色
@property (nonatomic, copy) NSString *tabbarBackgroundColor;
//tab 选中的颜色
@property (nonatomic, copy) NSString *tabSelectedColor;
//tab 没有选中的颜色
@property (nonatomic, copy) NSString *tabNonSelectedColor;
//tabbar 上面line的颜色
@property (nonatomic, copy) NSString *tabbarLineColor;


//navigationbar 背景颜色
@property (nonatomic, copy) NSString *navigationBarBackgroundColor;
//navigationbar 标题颜色
@property (nonatomic, copy) NSString *navigationBarTitleColor;
//navigationbar 下面line的颜色
@property (nonatomic, copy) NSString *navigationBarLineColor;


//viewcontroller 背景颜色
@property (nonatomic, copy) NSString *viewControllerBackgroundColor;
//tableview 背景颜色
@property (nonatomic, copy) NSString *tableviewBackgroundColor;

@property (nonatomic, copy) NSString *lineColor;

//scrollview 背景颜色
@property (nonatomic, copy) NSString *scrollviewBackgroundColor;
//app 搭配点缀颜色
@property (nonatomic, copy) NSString *withColor;
//splash 背景颜色
@property (nonatomic, copy) NSString *splashBackgroundColor;


/*************************更换皮肤颜色******************************/
//app 色块颜色
@property (nonatomic, copy) NSString *lumpColor;
//app 按钮颜色
@property (nonatomic, copy) NSString *btnColor;
//app 按钮文字颜色
@property (nonatomic, copy) NSString *btnCharacterColor;
//app 文字颜色
@property (nonatomic, copy) NSString *characterColor;
@property (nonatomic, copy) NSString *planBtnColor;

/*************************更换皮肤颜色******************************/


+ (UIConstants *)sharedDataEngine;

- (void)loadingAnimation;
- (void)stopLoadingAnimation;


/**
 分享方法
 
 @param type 分享类型
 @param controller 展示的控制器
 @return 返回分享结果 如果是No表示没有安装,请自行处理.
 */
+ (BOOL)shareWithType:(UIConstantsShareType)type andController:(UIViewController *)controller andItems:(NSArray *)items;

- (BOOL)shareWithType:(UIConstantsShareType)type andController:(UIViewController *)controller andItems:(NSArray *)items;

@end
