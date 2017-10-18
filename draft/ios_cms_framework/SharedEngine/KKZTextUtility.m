//
//  KKZTextUtility.m
//  KoMovie
//
//  Created by wuzhen on 16/8/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZTextUtility.h"

@implementation KKZTextUtility

+ (CGSize)measureText:(NSString *)text
                 size:(CGSize)size
                 font:(UIFont *)font {

    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}

+ (CGSize)measureText:(NSString *)text
                 font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize textSize = [text sizeWithAttributes:attributes];
    return textSize;
}

+ (BOOL)isTextEmpty:(NSString *)text {
    if ([text isEqual:[NSNull null]] || text == nil || [text isEqualToString:@"null"] || [text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)trimText:(NSString *)text {
    NSString *result = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
}

/*
 *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
 */
+ (NSMutableAttributedString *) getbalanceStrWithString:(NSString *)balanceStr {
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:balanceStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#ffffff"],NSFontAttributeName:[UIFont systemFontOfSize:10*Constants.screenWidthRate]}];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#ffffff"] range:NSMakeRange(3,balanceStr.length-3)];
    [vAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*Constants.screenWidthRate] range:NSMakeRange(3,balanceStr.length-4)];
    return vAttrString;
}

+ (NSMutableAttributedString *) getAttributeStr:(NSString *)str withStartRangeStr:(NSString *)startStr  withEndRangeStr:(NSString *)endStr withFormalColor:(UIColor *)formalColor withSpecialColor:(UIColor *)specialColor withFont:(UIFont *)font {
    
    NSRange startRange = [str rangeOfString:startStr];
    NSRange endRange = [str rangeOfString:endStr];
    NSRange validRange = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:formalColor,NSFontAttributeName:font}];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:specialColor range:validRange];
    
    return vAttrString;
}



+ (id)readPersonArrayData {
    NSData * userInfodata = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfoMData"];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:userInfodata];
}

+ (NSFileManager *)initFileManager {
    NSFileManager *manager;
    if (manager == nil) {
        manager = [NSFileManager defaultManager];
    }
    return manager;
}

#pragma mark - 获取沙盒目录 -

/** 获取沙盒Document目录 */
+ (NSString *)getDocumentDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

/** 获取沙盒Liabrary目录 */
+ (NSString *)getLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

/** 获取沙盒Library/Caches目录 */
+ (NSString *)getCachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

/** 获取沙盒Preference目录 */
+ (NSString *)getPreferenceDirectory {
    return NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES)[0];
}

/** 获取沙盒Tmp目录 */
+ (NSString *)getTmpDirectory {
    return NSTemporaryDirectory();
}

/** 创建cache/xxx文件夹 xxx-->huachen/ xincheng/ zhongdu/ baoshan*/
+ (void)createUserCacheFile {
    NSFileManager *fm = [self initFileManager];
    NSString *path = [[self getCachesDirectory] stringByAppendingPathComponent:kKeyChainServiceName];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    } else
        DLog(@"File path Cache/xxx has been existed !");
}

/** 获取cache/xxx文件夹路径 */
+ (NSString *)getUserCachePath {
    NSString *userPath = [[self getCachesDirectory] stringByAppendingPathComponent:kKeyChainServiceName];
    return userPath;
}




+ (UILabel *) getLabelWithText:(NSString *)titleStr font:(UIFont *)labelFont textColor:(UIColor *)labelColor textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    if (titleStr.length>0&&titleStr) {
        label.text = titleStr;
    }
    label.font = labelFont;
    label.textColor = labelColor;
    label.textAlignment = alignment;
    return label;
}

+ (UILabel *) getLabelWithAttributedText:(NSAttributedString *)titleStr font:(UIFont *)labelFont textColor:(UIColor *)labelColor textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    if (titleStr.length>0&&titleStr) {
        label.attributedText = titleStr;
    }
    if (labelFont) {
        label.font = labelFont;
    }
    if (labelColor) {
        label.textColor = labelColor;
    }
    label.textAlignment = alignment;
    return label;
}




@end
