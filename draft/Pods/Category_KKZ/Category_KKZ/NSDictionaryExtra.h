//
//  NSDictionaryExtra.h
//  phonebook
//
//  Created by kokozu on 10-12-18.
//  Copyright 2010 公司. All rights reserved.
//
#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>
@interface NSDictionary (NSDictionaryExtra) 

- (id)kkz_objForKey:(id)aKey;
- (NSString *)kkz_stringForKey:(id)aKey;
- (NSNumber *)kkz_intNumberForKey:(id)aKey;
- (NSNumber *)kkz_longNumberForKey:(id)aKey;
- (NSNumber *)kkz_floatNumberForKey:(id)aKey;
- (NSNumber *)kkz_doubleNumberForKey:(id)aKey;
- (NSNumber *)kkz_boolNumberForKey:(id)aKey;
- (NSDate *)kkz_dateForKey:(id)aKey withFormat:(NSString *)format;

@end
