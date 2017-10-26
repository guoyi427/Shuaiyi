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

@end
