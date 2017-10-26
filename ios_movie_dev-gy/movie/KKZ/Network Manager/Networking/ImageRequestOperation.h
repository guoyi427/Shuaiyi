//
//  ImageRequestOperation.h
//  NetworkManager
//
//  Created by Nostalgia on 11-9-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageRequestOperation : NSOperation{
    
    NSURLRequest * request;
    NSURLResponse * response;
    NSURLConnection* connection;
    
    NSString * urlString;
    
    NSData * buf;
    NSError * error;
    
    id target;
    SEL selector;
    id object;
    
    int status;
    
    NSString * type;
    
}

@property (nonatomic, retain, readonly) NSString * urlString;
@property (nonatomic, retain, readonly) NSURLRequest * request;
@property (nonatomic, assign, readonly) NSURLResponse * response;


- (id) initWithRequest:(NSURLRequest *)urlRequest urlString:(NSString * )_urlString target:(id)_target selector:(SEL)_selector object:(id)_object;
- (void) dataDidFinishedDownloading;
- (void) start;
- (BOOL) isFinished;
- (BOOL) isExecuting;
- (BOOL) isConcurrent;


@end
