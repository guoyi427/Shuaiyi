//
//  CPKeyChain.h
//  Cinephile
//
//  Created by KKZ on 16/7/19.
//  Copyright © 2016年 Kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPKeyChain : NSObject

// save username and password to keychain
+ (void)save:(NSString *)service data:(id)data;

// take out username and passwore from keychain
+ (id)load:(NSString *)service;

// delete username and password from keychain
+ (void)delete:(NSString *)service;


@end
