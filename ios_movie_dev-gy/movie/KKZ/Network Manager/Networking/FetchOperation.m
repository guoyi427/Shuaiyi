//
//  FetchOperation.m
//  NetworkManager
//
//  Created by Nostalgia on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FetchOperation.h"
#import "NetworkManager.h"
#import "CacheManager.h"


@implementation FetchOperation

-(id) initWithURL:(NSString*)_urlString target:(id)_target selector:(SEL)_selector object:(id)_object{
    if((self = [super init])) {
        target = _target;
        selector = _selector;
        object = _object;
        if(object == nil)
            object = @"nil";
        
        urlString = [_urlString copy];
        
        status = 0;
    }
    return self;
}

-(void) start{
    
    status = 1;
    
    CacheManager * cm = [CacheManager sharedManager];
    
    // Fetch from coredata
    NSString * imagePath = [cm fetchImageWithURLString: urlString];
    
    // Require downloading
    if(imagePath == nil){
        [[NetworkManager sharedManager] sendImageRequestWithImageURL:urlString target:target selector:selector object:object];
    }
    // Data already downloaded
    else{
        [target performSelectorOnMainThread:selector withObject:[NSArray arrayWithObjects:object,imagePath, nil] waitUntilDone:NO];
    }
    status = 2;
}



- (BOOL) isFinished{
    return status == 2 ;
}
- (BOOL) isExecuting{
    return status == 1 ; 
}
- (BOOL) isConcurrent{
    return YES;
}


-(void) dealloc{
    [urlString release];
    [super dealloc];
}
@end
