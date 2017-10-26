//
//  FetchOperation.h
//  NetworkManager
//
//  Created by Nostalgia on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchOperation : NSOperation {
    id target;
    SEL selector;
    id object;
    
    NSString * urlString;
    
    int status;
}


-(id) initWithURL:(NSString*)_urlString target:(id)_target selector:(SEL)_selector object:(id)_object;
-(void) start;
- (BOOL) isFinished;
- (BOOL) isExecuting;
- (BOOL) isConcurrent;
@end
