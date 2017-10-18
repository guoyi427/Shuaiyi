//
//  NSStringExtra.m
//  alfaromeo.dev
//
//  Created by zhang da on 10-9-27.
//  Copyright 2010 alfaromeo.dev inc. All rights reserved.
//

#import "NSStringExtra.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonCrypto.h>

#define HANZI_START 19968
#define HANZI_COUNT 20902

static const char _base64EncodingTable[64] = { 
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
};
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation NSString (Extra)

- (NSString *)URLEncodedStringY {
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                            kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                            NULL,
                                            kCFStringEncodingUTF8);
    
//      [encodedString stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    
    return [encodedString autorelease];
}

- (NSString *)URLEncodedString {
//    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                    (CFStringRef)self,
//                                                                    NULL,
//                                                                    CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
//                                                                    kCFStringEncodingUTF8);
    
    NSString *newString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                    kCFAllocatorDefault,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                    kCFStringEncodingUTF8);
    
    [newString stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    
    return [newString autorelease];
    
//    NSString *encodedStr = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return encodedStr;
}

- (NSString*)URLDecodedString {
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
	return [result autorelease];	
}

+ (NSString *)uniqueId {
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    NSString *identifierString = (NSString*)CFUUIDCreateString(NULL, identifier);
    CFRelease(identifier);
    return [identifierString autorelease];
}

- (NSString*)String2Base64 {
    if ([self length] == 0)
        return @"";
    
    const char *source = [self UTF8String];
    NSInteger strlength  = strlen(source);
    
    char *characters = (char *)malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = _base64EncodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = _base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = _base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = _base64EncodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];

}

- (NSString *)Base642String:(NSStringEncoding)encoding {
    const char * objPointer = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char *objResult = (unsigned char *)calloc(intLength, sizeof(unsigned char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4) {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[[NSData alloc] initWithBytes:objResult length:j] autorelease];
    free(objResult);
    return [[[NSString alloc] initWithData:objData encoding:encoding] autorelease];
}

- (NSString *)MD5String {
    // Get the c string from the NSString
    const char *cString = [self UTF8String];
    unsigned char result[16];
    
    // MD5 encryption
    CC_MD5( cString, (CC_LONG)strlen(cString), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSString *)MD5String16 {
    NSString *md5 = [self MD5String];
    if ([md5 length] == 32) {
        return [md5 substringWithRange:NSMakeRange(8, 16)];
    }
    return nil;
}

- (long)serverDateSince1970 {
    struct tm created;
    time_t now;
    time(&now);
    if (strptime([self UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
        strptime([self UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
    }
    
    return mktime(&created);
}

- (NSString*)encodeAsURIComponent {
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

- (NSString*)escapeHTML {
	NSMutableString* s = [NSMutableString string];
	
	NSInteger start = 0;
	NSInteger len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML {
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [[self mutableCopy] autorelease];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

- (NSString *)flattenHTML {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:self];
    NSString *res = self;
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        res = [res stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
        
    } // while //
    
    return res;
    
}

- (NSString *)imageKeyFromURL {
    if ([self length]) {
        return [self URLEncodedString];        
    }

    return @"nokey";
}

- (BOOL)isNumeric {
	const char *raw = (const char *) [self UTF8String];
	
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') 
            return NO;
	}
	return YES;
}

- (NSString *)desEncryptWithKey:(NSString *)key {
    const char *bytes = [self UTF8String];
    NSInteger length  = strlen(bytes);

    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], 
                                          kCCKeySizeDES,
                                          NULL,
                                          bytes, 
                                          length,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSString *res = [[NSString alloc] initWithBytes:buffer length:numBytesEncrypted encoding:NSASCIIStringEncoding];
        return [res autorelease];
    }
    return nil;
}

- (NSString *)desDecryptWithKey:(NSString *)key {
    const char *bytes = [self UTF8String];
    NSInteger length  = strlen(bytes);
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], 
                                          kCCKeySizeDES,
                                          NULL,
                                          bytes, 
                                          length,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSString *res = [[NSString alloc] initWithBytes:buffer length:numBytesEncrypted encoding:NSASCIIStringEncoding];
        return [res autorelease];
    }
    return nil;
}

char originChar(char crypto) {
    switch (crypto) {
        case 'z': return '0';
        case 'a': return '1';
        case 'q': return '2';
        case 'x': return '3'; 
        case 's': return '4';
        case 'w': return '5'; 
        case 'c': return '6';
        case 'd': return '7'; 
        case 'e': return '8';
        case 'v': return '9'; 
        case 'f': return 'a';
        case 'r': return 'b';
        case 'b': return 'c';
        case 'g': return 'd';
        case 't': return 'e'; 
        case 'n': return 'f';
        case 'h': return 'g'; 
        case 'y': return 'h';
        case 'm': return 'i';
        case 'j': return 'j'; 
        case 'u': return 'k';
        case 'k': return 'l';
        case 'i': return 'm'; 
        case 'l': return 'n';
        case 'o': return 'o'; 
        case 'p': return 'p';
        case 'P': return 'q';
        case 'O': return 'r';
        case 'I': return 's';
        case 'U': return 't';
        case 'Y': return 'u';
        case 'T': return 'v';
        case 'R': return 'w'; 
        case 'E': return 'x';
        case 'W': return 'y';
        case 'Q': return 'z'; 
        case 'A': return 'A'; 
        case 'S': return 'B';
        case 'D': return 'C';
        case 'F': return 'D'; 
        case 'G': return 'E'; 
        case 'H': return 'F';
        case 'J': return 'G';
        case 'K': return 'H'; 
        case 'L': return 'I';
        case 'M': return 'J'; 
        case 'N': return 'K';
        case 'B': return 'L';
        case 'V': return 'M'; 
        case 'C': return 'N'; 
        case 'X': return 'O';
        case 'Z': return 'P'; 
        case '0': return 'Q';
        case '9': return 'R'; 
        case '8': return 'S';
        case '7': return 'T'; 
        case '6': return 'U'; 
        case '5': return 'V'; 
        case '4': return 'W';
        case '3': return 'X';
        case '2': return 'Y'; 
        case '1': return 'Z';
        default: return ' ';
    }
}

char cryptoChar(char origin) {
    switch (origin) {
        case '0': return 'z';
        case '1': return 'a';
        case '2': return 'q';
        case '3': return 'x';
        case '4': return 's';
        case '5': return 'w';
        case '6': return 'c';
        case '7': return 'd';
        case '8': return 'e';
        case '9': return 'v';
        case 'a': return 'f';
        case 'b': return 'r';
        case 'c': return 'b';
        case 'd': return 'g';
        case 'e': return 't';
        case 'f': return 'n';
        case 'g': return 'h';
        case 'h': return 'y';
        case 'i': return 'm';
        case 'j': return 'j';
        case 'k': return 'u';
        case 'l': return 'k';
        case 'm': return 'i';
        case 'n': return 'l';
        case 'o': return 'o';
        case 'p': return 'p';
        case 'q': return 'P';
        case 'r': return 'O';
        case 's': return 'I';
        case 't': return 'U';
        case 'u': return 'Y';
        case 'v': return 'T';
        case 'w': return 'R';
        case 'x': return 'E';
        case 'y': return 'W';
        case 'z': return 'Q';
        case 'A': return 'A';
        case 'B': return 'S';
        case 'C': return 'D';
        case 'D': return 'F';
        case 'E': return 'G';
        case 'F': return 'H';
        case 'G': return 'J';
        case 'H': return 'K';
        case 'I': return 'L';
        case 'J': return 'M';
        case 'K': return 'N';
        case 'L': return 'B';
        case 'M': return 'V';
        case 'N': return 'C';
        case 'O': return 'X';
        case 'P': return 'Z';
        case 'Q': return '0';
        case 'R': return '9';
        case 'S': return '8';
        case 'T': return '7';
        case 'U': return '6';
        case 'V': return '5';
        case 'W': return '4';
        case 'X': return '3';
        case 'Y': return '2';
        case 'Z': return '1';
        default: return ' ';
    }
}

- (NSString *)kkzEncodedString {
    NSMutableString *decoded = [[NSMutableString alloc] initWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        [decoded appendString:[NSString stringWithFormat:@"%c",cryptoChar([self characterAtIndex:i])]];
    }
    return [decoded autorelease];
}

- (NSString *)kkzDecodedString {
    NSMutableString *decoded = [[NSMutableString alloc] initWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        [decoded appendString:[NSString stringWithFormat:@"%c",originChar([self characterAtIndex:i])]];
    }
    return [decoded autorelease];
}

- (NSDictionary *)URLParams {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?#"]];
    
    NSString *tempString = nil;
    NSString *mainUrl = nil;
    
    NSMutableDictionary *parsedParams = [[NSMutableDictionary alloc] init];
    
    [scanner scanUpToString:@"?" intoString:&mainUrl];
    if ([mainUrl isEqualToString:self]) {
        [scanner setScanLocation:0];
        [scanner scanUpToString:@"#" intoString:&mainUrl];
    } if ([mainUrl isEqualToString:self]) {
        //兼容 client_id=100222222&openid=801C07AC85537C5D33058C81FC1FB281 无url的解析
        [scanner setScanLocation:0];
    }
    
    if (mainUrl) {
        [parsedParams setObject:mainUrl forKey:@"&url&"];
    }
    
    while ([scanner scanUpToString:@"&" intoString:&tempString]) {
        NSArray *params = [tempString componentsSeparatedByString:@"="];
        if ([params count] == 2) {
            [parsedParams setValue:[params objectAtIndex:1] forKey:[params objectAtIndex:0]];
        }
    }
    
    return [parsedParams autorelease];
}

- (NSString *)primaryDomain {
    NSArray *components = [self componentsSeparatedByString:@"/"];
        
    if ([components count] >= 3) {
        return [components objectAtIndex:2];
    }
    if ([components count] == 1) {
        return [components lastObject];
    }
    return nil;
}

- (NSString *)replaceString:(NSString *)str {
  
    NSString *modifiedString = [self stringByReplacingOccurrencesOfString:str withString:@""];
    return modifiedString;
}

/**
 NSString to NSNumber
 Make sure this string contains only numbers
 
 @return NSNumber
 */
- (NSNumber *) toNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    return [formatter numberFromString:self];
}

/**
 用于限定字符串长度，emoji长度计算为1
 
 @param index 截取长度
 @return 截取后字符串
 */
- (NSString *)subEmojiStringToIndex:(NSUInteger)index {
    NSMutableString *resultString = [NSMutableString string];
    __block NSInteger textLength = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                              if (substring.length && textLength < index) {
                                  [resultString appendString:substring];
                                  textLength ++;
                              }
                          }];
    
    return resultString;
}

/**
 获取字符串长度，汉字算2个，数字字母算一个
 
 @return ascii长度
 */
- (NSUInteger)unicodeLength {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;

}

@end
