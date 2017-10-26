//
//  KKZUtility.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/9.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlertView.h"
#import "Reachability.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^clickCallBack)(NSString *title);

@interface KKZUtility : NSObject <UIAlertViewDelegate>

/**
 *  通过特色信息类型得到特色信息名字
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)getSpecialNameByType:(int)type;

/**
 *  根据输入文本计算文本尺寸
 *
 *  @param font
 *  @param inputString
 *  @param inputSize
 *
 *  @return 
 */
+(CGSize)customTextSize:(UIFont *)font
                   text:(NSString *)inputString
                   size:(CGSize)inputSize;


/**
 *  判断字符串是否未空
 *
 *  @param inputString
 *
 *  @return
 */
+ (BOOL)stringIsEmpty:(NSString *)inputString;

/**
 *  显示提示框只有一个按钮
 *
 *  @param title
 */
+(void)showAlert:(NSString *)title;

/**
 *  显示提示框两个按钮
 *
 *  @param title       提示框标题
 *  @param detailTitle 提示框的子标题
 *  @param otherTitle1 第一个按钮的标题
 *  @param otherTitle2 第二个按钮的标题
 *  @param back        回调函数
 */

-(void)showAlertTitle:(NSString *)title
               detail:(NSString *)detailTitle
               other1:(NSString *)otherTitle1
               other2:(NSString *)otherTitle2
            clickCall:(clickCallBack)back;

/**
 *  在UIWindow上显示加载框
 *
 *  @param title
 */
+(void)showIndicatorWithTitle:(NSString *)title;

/**
 *  在指定页面显示加载框
 *
 *  @param title    标题
 *  @param showView 显示的页面
 */
+(void)showIndicatorWithTitle:(NSString *)title
                       atView:(UIView *)showView;

/**
 *  隐藏加载框
 */
+(void)hidenIndicator;

/**
 *  通过日期字符串得到一个格式化的时间日期
 *
 *  @param dateString
 *
 *  @return
 */
+(NSString *)getDateStringByDate:(NSString *)dateString;


/**
 *  显示自定义加载框
 *
 *  @param title        <#title description#>
 *  @param detailTitle  <#detailTitle description#>
 *  @param cancelString <#cancelString description#>
 *  @param back         <#back description#>
 *  @param otherTitle   <#otherTitle description#>
 */
+(void)showAlertTitle:(NSString *)title
               detail:(NSString *)detailTitle
               cancel:(NSString *)cancelString
            clickCall:(ClickBlock)back
               others:(NSString *)otherTitle,...;

/**
 *  判断网络是否连接
 *
 *  @return
 */
+ (BOOL)networkConnected;

/**
 *  得到当前屏幕的视图控制器
 *
 *  @return
 */
+(id)getCurrentScreenController;

/**
 *  获取当前Navigation的最上层controller对象
 *
 *  @return
 */
+(CommonViewController *)getRootNavagationLastTopController;

/**
 *  初始化一个视频播放器
 *
 *  @param url  要播放的视频的URL
 *
 *  @return
 */
+(MPMoviePlayerViewController *)startPlayer:(NSURL *)url;

/**
 *  初始化一个音频播放器
 *
 *  @param url
 *
 *  @return
 */
+(AVAudioPlayer *)startPlayAudio:(NSURL *)url;

/**
 *  图片翻转正
 *
 *  @param aImage <#aImage description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageOrientation:(UIImage *)aImage;

/**
 *  将图片剪切到指定的尺寸(切图的区域在中间)
 *
 *  @param imageToCrop
 *  @param scaledImageSize
 *
 *  @return
 */
+ (UIImage *)croppedImage:(UIImage *)imageToCrop
                 withSize:(CGSize)scaledImageSize;

/**
 *  将图片剪切到指定的尺寸
 *
 *  @param imageToCrop
 *  @param scaledImageFrame
 *
 *  @return
 */
+ (UIImage *)croppedImage:(UIImage *)imageToCrop
                 withFrame:(CGRect)scaledImageFrame;

/**
 *  将图片缩放到指定尺寸
 *
 *  @param originImage
 *  @param size
 *
 *  @return
 */
+ (UIImage *)resibleImage:(UIImage *)originImage
                   toSize:(CGSize)size;

/**
 *  根据月份和天数来得到星座
 *
 *  @param m
 *  @param d
 *
 *  @return
 */
+(NSString *)getAstroWithMonth:(int)m
                           day:(int)d;

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 *   网络IP地址
 */
+ (NSString *)getIPAddress;

/**
 *  判断输入的文本的是否为空
 *
 *  @param text
 *
 *  @return 
 */
+ (BOOL)inputStringIsEmptyWith:(NSString *)text;


//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;
//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key;
//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key;

@end
