//
//  Predict.m
//  basic
//
//  Created by zhang da on 14-4-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Predicate.h"
#import "Model.h"


@implementation Predicate

- (void)dealloc {
    
    self.key = nil;
    self.value = nil;
    
    
}

+ (Predicate *)predictForKey:(NSString *)key compare:(Compare)compare value:(id)value {
    Predicate *p = [[Predicate alloc] init];
    p.key = key;
    p.compare = compare;
    p.value = value;
    return p;
}

- (bool)match:(NSObject *)data {
    if (!data) {
        return NO;
    }
    if ([data isKindOfClass:[Model class]]) {
        Model *m = (Model *)data;
        id dataValue = [[m exportData] valueForKey:self.key];
        return [Predicate object:dataValue compare:self.compare object:self.value];
    } else {
        id dataValue = [data valueForKey:self.key];
        return [Predicate object:dataValue compare:self.compare object:self.value];
    }
}

+ (bool)object:(id)object1 compare:(Compare)compare object:(id)object2 {
    switch (compare) {
        case Equal: {
            if ([object1 isKindOfClass:[NSString class]] && [object2 isKindOfClass:[NSString class]]) {
                return [((NSString *)object1) isEqualToString:((NSString *)object2)];
            }
            return [object1 isEqual:object2];
        }
        case More: return object1 > object2;
        case Less: return object1 < object2;
        case MoreEqual: return object1 >= object2;
        case LessEqual:{
            if ([object1 isKindOfClass:[NSString class]] && [object2 isKindOfClass:[NSString class]]) {
                if ([object2 rangeOfString:object1].length != 0) {
                    return YES;
                }
            }
            return object1 <= object2;
        }
        case FuzzyMatch:
            if ([object1 isKindOfClass:[NSString class]] && [object2 isKindOfClass:[NSString class]]) {
                NSString *lowObject1 = [object1 lowercaseString];
                NSString *lowObject2 = [object2 lowercaseString];
                if ([lowObject1 rangeOfString:lowObject2].length > 0 || [lowObject2 rangeOfString:lowObject1].length > 0) {
                    return YES;
                }
            }
            return NO;
        default:
            break;
    }
    return NO;
}

@end
