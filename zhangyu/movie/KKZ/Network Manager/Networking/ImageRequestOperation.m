//
//  ImageRequestOperation.m
//  NetworkManager
//
//  Created by Nostalgia on 11-9-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageRequestOperation.h"
#import "CacheManager.h"
#import "ImageCache.h"
#import "NetworkManager.h"


@implementation ImageRequestOperation

@synthesize urlString;
@synthesize request;
@synthesize response;

- (id) initWithRequest:(NSURLRequest *)urlRequest urlString:(NSString*)_urlString target:(id)_target selector:(SEL)_selector object:(id)_object {
    if((self = [super init])) {
        
        buf = nil;
        
        target = _target;
        selector = _selector;
        object = _object;
        if(object == nil)
            object = @"nil";
        
        request = [urlRequest retain];
        
        urlString = [_urlString copy];
        
        status = 0;
        type = @"image";
        
    }
    return self;
}

- (void) start{
    
    assert(request);
    
    status = 1;
    error = nil;
    response = nil;
    
    // Receiving
    buf = [[NSData alloc]initWithData:[NSURLConnection sendSynchronousRequest:request
                                                            returningResponse:&response
                                                                        error:&error]];
    
    // Data check
	if ( buf==nil || error != nil 
        || response == nil || [[[response MIMEType] lowercaseString] rangeOfString:type].location == NSNotFound)
	{
        //Error
        NSLog(@"Error Downloading:%@",urlString);
	}
	else
	{
        [self dataDidFinishedDownloading];
	}
    
    if(buf!=nil)
        [buf release];
    
    status = 2;
}



- (void) dataDidFinishedDownloading{
    
    UIImage * image = [[UIImage alloc]initWithData: buf];
    
    CacheManager * cacheManager = [CacheManager sharedManager];
    
    NSString * localPath =  [NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    NSString * filename = [[[self request]URL]lastPathComponent];
    NSString * localFilePath = [localPath stringByAppendingString: filename];
    
    BOOL saveResult = [UIImageJPEGRepresentation(image,0) writeToFile:localFilePath atomically:YES];
    [image release];
    
    if (saveResult) {
        [cacheManager insertImageWithRemoteURL:urlString localURL:localFilePath];
    }
    [target performSelectorOnMainThread:selector withObject:[NSArray arrayWithObjects:object,localFilePath, nil] waitUntilDone:NO];
    
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


- (void) dealloc{
    [urlString release];
    [request release];
    [super dealloc];
}

@end
