//
//  BindPhoneViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "BindPhoneViewModel.h"

@implementation BindPhoneViewModel

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum {
    if (phoneNum.length == 11) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)isValidCodeNumber:(NSString *)codeNum {
    if (codeNum.length > 0) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)isValidPassWordNumber:(NSString *)passNum {
    if (passNum.length >= 6 && passNum.length <= 16) {
        return TRUE;
    }
    return FALSE;
}

+ (NSString *)getTypeNameByUnbindType:(UnbindType)bindType {
    NSString *titleString;
    if (bindType == UnbindTypeWeibo) {
        titleString = @"微博";
    }else if (bindType == UnbindTypePhone) {
        titleString = @"手机";
    }else if (bindType == UnbindTypeQQ) {
        titleString = @"QQ";
    }else if (bindType == UnbindTypeWeixin) {
        titleString = @"微信";
    }
    return titleString;
}

+ (NSString *)getTypeImageByUnbindType:(UnbindType)bindType {
    NSString *titleString;
    if (bindType == UnbindTypeWeibo) {
        titleString = @"AccountBind_weibo";
    }else if (bindType == UnbindTypePhone) {
        titleString = @"AccountBind_phone";
    }else if (bindType == UnbindTypeQQ) {
        titleString = @"AccountBind_QQ";
    }else if (bindType == UnbindTypeWeixin) {
        titleString = @"AccountBind_weixin";
    }
    return titleString;
}

+ (NSString *)getSecretStringByString:(NSString *)inputString {
    
    NSString *finalString;
    if (inputString.length >= 5) {
        NSString *front = [inputString substringToIndex:2];
        NSString *last = [inputString substringFromIndex:inputString.length - 2];
        finalString = [NSString stringWithFormat:@"%@***%@",front,last];
    }else if (inputString.length >= 3) {
        NSString *front = [inputString substringToIndex:1];
        NSString *last = [inputString substringFromIndex:inputString.length - 1];
        finalString = [NSString stringWithFormat:@"%@***%@",front,last];
    }
    return finalString;
}

@end
