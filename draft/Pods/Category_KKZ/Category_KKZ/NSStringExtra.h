//
//  NSStringExtra.h
//  alfaromeo.dev
//
//  Created by zhang da on 10-9-27.
//  Copyright 2010 alfaromeo.dev inc. All rights reserved.
//
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
@interface NSString (Extra)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
+ (NSString *)uniqueId;

- (NSString *)String2Base64;
- (NSString *)Base642String:(NSStringEncoding)encoding;

- (NSString *)MD5String;
- (NSString *)MD5String16;

- (long)serverDateSince1970;

- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
- (NSString *)flattenHTML;

- (NSString *)imageKeyFromURL;

- (BOOL)isNumeric;

- (NSString *)desEncryptWithKey:(NSString *)key;
- (NSString *)desDecryptWithKey:(NSString *)key;

- (NSString *)kkzEncodedString;
- (NSString *)kkzDecodedString;

- (NSDictionary *)URLParams;

- (NSString *)primaryDomain;

- (NSString *)replaceString:(NSString *)str;
- (NSString *)URLEncodedStringY;


/**
 NSString to NSNumber
 Make sure this string contains only numbers

 @return NSNumber
 */
- (NSNumber *) toNumber;

/**
 用于限定字符串长度，emoji长度计算为1

 @param index 截取长度
 @return 截取后字符串
 */
- (NSString *)subEmojiStringToIndex:(NSUInteger)index;

/**
 获取字符串长度，汉字算2个，数字字母算一个

 @return ascii长度
 */
- (NSUInteger)unicodeLength;

@end
