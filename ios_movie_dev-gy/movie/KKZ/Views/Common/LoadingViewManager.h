//
//  LoadingViewManager.h
//  KoMovie
//
//  Created by kokozu on 21/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingViewManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithText:(NSString *)text;

- (void)stop;

@end
