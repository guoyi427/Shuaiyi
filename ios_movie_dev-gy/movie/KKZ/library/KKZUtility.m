//
//  KKZUtility.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/9.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "AccountBindLoadingView.h"
#import "KKZUtility.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>

static NSString *BLOCK_ASS_KEY = @"com.random-ideas.BUTTONS";

//加载框
static AccountBindLoadingView *_bindLoading = nil;

#define kCommonScreenBounds [UIScreen mainScreen].bounds //整个APP屏幕尺寸
#define kCommonScreenWidth kCommonScreenBounds.size.width //整个APP屏幕的宽度
#define kCommonScreenHeight kCommonScreenBounds.size.height //整个APP屏幕的高度

static NSDateFormatter *static_formatter;
static NSDateFormatter *change_formatter;

@implementation KKZUtility

+ (NSString *)getSpecialNameByType:(int)type {
    NSDictionary *dic = @{ @1 : @"3D眼镜",
                           @2 : @"可停车",
                           @3 : @"VIP厅",
                           @4 : @"儿童优惠",
                           @5 : @"银联付款",
                           @6 : @"WIFI",
                           @7 : @"公交",
                           @8 : @"地铁",
                           @9 : @"零食",
                           @10 : @"大厅",
                           @11 : @"营业时间",
                           @12 : @"暂时不知",
                           @13 : @"美食",
                           @14 : @"娱乐",
                           @15 : @"购物" };
    NSNumber *number = [NSNumber numberWithInt:type];
    return dic[number];
}

+ (CGSize)customTextSize:(UIFont *)font
                    text:(NSString *)inputString
                    size:(CGSize)inputSize {
    CGSize result;
    if (runningOniOS7) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGRect rect1 = [inputString boundingRectWithSize:inputSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:dic
                                                 context:nil];
        result = rect1.size;
    } else {
        result = [inputString sizeWithFont:font
                         constrainedToSize:inputSize
                             lineBreakMode:NSLineBreakByCharWrapping];
    }
    return result;
}

+ (BOOL)stringIsEmpty:(NSString *)inputString {
    BOOL decide = FALSE;
    if ([inputString isEqual:[NSNull null]] || inputString == nil || [inputString isEqualToString:@"null"] || [inputString isEqualToString:@""]) {
        decide = TRUE;
    }
    return decide;
}

+ (void)showAlert:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showAlertTitle:(NSString *)title
                detail:(NSString *)detailTitle
                other1:(NSString *)otherTitle1
                other2:(NSString *)otherTitle2
             clickCall:(clickCallBack)back {

    objc_setAssociatedObject(self, (__bridge const void *) (BLOCK_ASS_KEY), back, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:detailTitle
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:otherTitle1, otherTitle2, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    clickCallBack call = objc_getAssociatedObject(self, (__bridge const void *) (BLOCK_ASS_KEY));
    NSString *index = [NSString stringWithFormat:@"%ld", (long) buttonIndex];
    call(index);
}

+ (void)showIndicatorWithTitle:(NSString *)title {

    //记载框如果不存在就初始化一个
    if (!_bindLoading) {
        _bindLoading = [[AccountBindLoadingView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    }

    //开始加载
    NSInteger count = [[UIApplication sharedApplication].windows count];
    if (count >= 1) {
        UIWindow *w = [[UIApplication sharedApplication].windows objectAtIndex:count - 1];
        [w addSubview:_bindLoading];
    }
    _bindLoading.titleString = title;
    [_bindLoading startAnimation];
}

+ (void)showIndicatorWithTitle:(NSString *)title
                        atView:(UIView *)showView {

    //记载框如果不存在就初始化一个
    if (!_bindLoading) {
        _bindLoading = [[AccountBindLoadingView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    }
    [showView addSubview:_bindLoading];
    _bindLoading.titleString = title;
    [_bindLoading startAnimation];
}

+ (void)hidenIndicator {
    [_bindLoading stopAnimation];
    [_bindLoading removeFromSuperview];
}

+ (NSString *)getDateStringByDate:(NSString *)dateString {

    //如果日期格式化不存在,初始化
    if (!static_formatter) {
        static_formatter = [[NSDateFormatter alloc] init];
        [static_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }

    //如果需要改变的日期格式化不存在
    if (!change_formatter) {
        change_formatter = [[NSDateFormatter alloc] init];
        [change_formatter setDateFormat:@"YYYY年MM月dd日"];
    }

    //格式化日期
    NSDate *date = [static_formatter dateFromString:dateString];
    NSString *dateStr = [change_formatter stringFromDate:date];
    return dateStr;
}

+ (void)showAlertTitle:(NSString *)title
                detail:(NSString *)detailTitle
                cancel:(NSString *)cancelString
             clickCall:(ClickBlock)back
                others:(NSString *)otherTitle, ... {
    dispatch_async(dispatch_get_main_queue(), ^{
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:title
                                                            detailTitle:detailTitle
                                                           cancelButton:cancelString
                                                             clickBlock:back
                                                      otherButtonTitles:otherTitle];
        [alert show];
    });
}

/**
 *  获取网络是否可用
 *
 *  @return 
 */
+ (BOOL)networkConnected {
    BOOL result = ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ||
                   [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
    return result;
}

+ (id)getCurrentScreenController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([[[frontView.subviews firstObject] nextResponder] isKindOfClass:[UIViewController class]]) {
        id nextResponder = [[frontView.subviews firstObject] nextResponder];
        result = nextResponder;
    } else
        result = window.rootViewController;

    return result;
}

+ (CommonViewController *)getRootNavagationLastTopController {
    id navigation = [[self class] getCurrentScreenController];
    return [[(UINavigationController *) navigation viewControllers] lastObject];
}

+ (MPMoviePlayerViewController *)startPlayer:(NSURL *)url {

    //视频播放器控制器
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    playerViewController.view.backgroundColor = [UIColor clearColor];
    playerViewController.view.alpha = 0.0;

    //过0.3后视频播放器页面出现
    [UIView animateWithDuration:.3
                     animations:^{
                         playerViewController.view.alpha = 1.0;
                     }
                     completion:nil];

    //视频播放器初始化
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    player.scalingMode = MPMovieScalingModeAspectFill;
    player.controlStyle = MPMovieControlStyleNone;
    player.movieSourceType = MPMovieSourceTypeUnknown;
    player.shouldAutoplay = NO;
    [player prepareToPlay];

    //返回视频播放器控制器
    return playerViewController;
}

+ (AVAudioPlayer *)startPlayAudio:(NSURL *)url {
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                                   error:&error];
    player.volume = 1.0f;
    [player prepareToPlay];
    return player;
}

+ (UIImage *)imageOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    //将CGImage对象画到上下文上
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)croppedImage:(UIImage *)imageToCrop
                 withSize:(CGSize)scaledImageSize {
    CGSize imageSize = imageToCrop.size;
    CGRect actualCropRect = CGRectMake(
            (imageSize.width - scaledImageSize.width) / 2.0f,
            (imageSize.height - scaledImageSize.height) / 2.0f,
            scaledImageSize.width,
            scaledImageSize.height);
    UIImage *outputImage = nil;

    CGImageRef imageRef = CGImageCreateWithImageInRect(imageToCrop.CGImage, actualCropRect);
    outputImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return outputImage;
}

+ (UIImage *)croppedImage:(UIImage *)imageToCrop
                withFrame:(CGRect)scaledImageFrame {
    CGRect actualCropRect = scaledImageFrame;
    UIImage *outputImage = nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageToCrop.CGImage, actualCropRect);
    outputImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return outputImage;
}

+ (UIImage *)resibleImage:(UIImage *)originImage
                   toSize:(CGSize)size {
    //    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getAstroWithMonth:(int)m
                            day:(int)d {
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m < 1 || m > 12 || d < 1 || d > 31) {
        return @"错误日期格式!";
    }
    if (m == 2 && d > 29) {
        return @"错误日期格式!!";
    } else if (m == 4 || m == 6 || m == 9 || m == 11) {
        if (d > 30) {
            return @"错误日期格式!!!";
        }
    }
    result = [NSString stringWithFormat:@"%@", [astroString substringWithRange:NSMakeRange(m * 2 - (d < [[astroFormat substringWithRange:NSMakeRange((m - 1), 1)] intValue] - (-19)) * 2, 2)]];
    return result;
}

+ (NSString *)getIPAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)macaddress {

    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }

    ifm = (struct if_msghdr *) buf;
    sdl = (struct sockaddr_dl *) (ifm + 1);
    ptr = (unsigned char *) LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];

    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    NSLog(@"outString:%@", outstring);

    free(buf);

    return [outstring uppercaseString];
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (BOOL)inputStringIsEmptyWith:(NSString *)text {
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return TRUE;
    }
    return FALSE;
}

//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage *)image Keys:(NSString *)key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString *)key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData *imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
+ (UIImage *)GetImageFromLocal:(NSString *)key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData *imageData = [preferences objectForKey:key];
    UIImage *image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    } else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}

@end
