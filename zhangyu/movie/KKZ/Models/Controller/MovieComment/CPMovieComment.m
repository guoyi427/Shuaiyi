//
//  CPMovieComment.m
//  Cinephile
//
//  Created by Albert on 17/12/2016.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPMovieComment.h"
#import <DateEngine_KKZ/DateEngine.h>

@implementation CPMovieComment
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [mudic setObject:@"id" forKey:@"commentId"];
    [mudic setObject:@"isFriend" forKey:@"isNotFriend"];
    return [mudic copy];
}
+ (NSValueTransformer *)posterPathJOSNTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)isNotFriendJOSNTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

+ (NSValueTransformer *)createTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    }
                                                reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
                                                    return [self.dateFormatter stringFromDate:date];
                                                }];
}


- (NSString *) formatedTime
{
    if (self.createTime == nil) {
        return @"";
    }
    
    return [[DateEngine sharedDateEngine] formattedStringFromDate:self.createTime];
}

@end
