//
//  NetworkUtil.h
//  KoMovie
//
//  Created by zhang da on 14-6-10.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface NetworkUtil : NSObject {
    
    Reachability *internetReach;
    
}

+ (NetworkUtil *)me;
- (BOOL)reachable;
- (BOOL)isWIFI;
- (BOOL)reachable:(BOOL)isLandscape;

@end
