//
//  RequestParameter.h
//  TestTaskQueue
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestParameter : NSObject {
@protected
    NSString *name;
    NSString *value;
    BOOL isGBK;
}
@property(copy) NSString *name;
@property(copy) NSString *value;
@property(assign) BOOL isGBK;;

+ (id)requestParameterWithName:(NSString *)aName value:(NSString *)aValue withGBK:(BOOL)isGBK;
- (id)initWithName:(NSString *)aName value:(NSString *)aValue withGBK:(BOOL)isGBK;
- (NSString *)URLEncodedNameValuePair;

@end
