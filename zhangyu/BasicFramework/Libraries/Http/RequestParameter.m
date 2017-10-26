//
//  RequestParameter.m
//  TestTaskQueue
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import "RequestParameter.h"
#import "NSStringExtra.h"

@implementation RequestParameter

@synthesize name, value, isGBK;

+ (id)requestParameterWithName:(NSString *)aName value:(NSString *)aValue withGBK:(BOOL)isGBK {
    return [[[RequestParameter alloc] initWithName:aName value:aValue withGBK:isGBK] autorelease];
}

- (id)initWithName:(NSString *)aName value:(NSString *)aValue withGBK:(BOOL)withGBK {
    self = [super init];
    if (self ) {
		self.name = aName;
		self.value = aValue;
        self.isGBK = withGBK;
	}
    return self;
}

- (void)dealloc {
	[name release];
	[value release];
	[super dealloc];
}

- (NSString *)URLEncodedNameValuePair {
    if (isGBK) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000 );
        return [[NSString stringWithFormat:@"%@=%@",
                [[NSString stringWithFormat:@"%@", name] URLEncodedString],
                [value stringByAddingPercentEscapesUsingEncoding:enc]]stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    } else {
        return [[NSString stringWithFormat:@"%@=%@",
          [[NSString stringWithFormat:@"%@", name] URLEncodedString],
          [[NSString stringWithFormat:@"%@", value] URLEncodedString]]    stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", name, value];
}

@end
