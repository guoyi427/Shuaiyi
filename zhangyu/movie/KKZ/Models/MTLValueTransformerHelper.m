//
//  MTLValueTransformerHelper.m
//  KoMovie
//
//  Created by Albert on 12/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MTLValueTransformerHelper.h"
NSValueTransformer * KKZ_StringToNumberTransformer() {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = value;
            NSNumberFormatter *numf = [[NSNumberFormatter alloc] init];
            NSNumber *num = [numf numberFromString:str];
            return num;
        }
        return value;
    }];
}

NSValueTransformer * KKZ_StringToDateTransformer(NSString *formatter)
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = value;
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            dateformatter.dateFormat = formatter;
            return [dateformatter dateFromString:str];
        }
        return nil;
    }];
}
