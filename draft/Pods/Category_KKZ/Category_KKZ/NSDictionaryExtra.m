//
//  NSDictionaryExtra.m
//  phonebook
//
//  Created by kokozu on 10-12-18.
//  Copyright 2010 公司. All rights reserved.
//

#import "NSDictionaryExtra.h"
#import <Foundation/NSNull.h>
#import <Foundation/NSString.h>

#import "DateEngine.h"

@implementation NSDictionary (NSDictionaryExtra)

- (id)kkz_objForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null] 
            && [self objectForKey:aKey] 
            && [self objectForKey:aKey]!=[NSNull null])
            return [self objectForKey:aKey];
    }
    return nil;
}

- (NSString *)kkz_stringForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null])
            return [NSString stringWithFormat:@"%@", [self objectForKey:aKey]];
    }
    return nil;
}

- (NSNumber *)kkz_intNumberForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null]) {
            
            int value = [[self objectForKey:aKey] intValue];
            return [NSNumber numberWithInt:value];
        }
    }
    return nil;
}

- (NSNumber *)kkz_longNumberForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null]) {
            
            long value = [[self objectForKey:aKey] intValue];
            return [NSNumber numberWithLong:value];
        }
    }
    return nil;
}

- (NSNumber *)kkz_doubleNumberForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null]) {
            
            int value = [[self objectForKey:aKey] doubleValue];
            return [NSNumber numberWithDouble:value];
        }
    }
    return nil;
}

- (NSNumber *)kkz_floatNumberForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null]) {
            
            float value = [[self objectForKey:aKey] floatValue];
            return [NSNumber numberWithFloat:value];
        }
    }
    return nil;
}

- (NSNumber *)kkz_boolNumberForKey:(id)aKey {
    if (aKey) {
        if ( (id)self!=[NSNull null]
            && [self objectForKey:aKey]
            && [self objectForKey:aKey]!=[NSNull null]) {
            
            BOOL value = [[self objectForKey:aKey] boolValue];
            return [NSNumber numberWithBool:value];
        }
    }
    return nil;
}

- (NSDate *)kkz_dateForKey:(id)aKey withFormat:(NSString *)format {
    NSString *timeStr = [self kkz_stringForKey:aKey];
    if (timeStr) {
        return [[DateEngine sharedDateEngine] dateFromString:timeStr withFormat:format];
    }
    return nil;
}

@end
