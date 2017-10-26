//
//  NetworkUtil.m
//  KoMovie
//
//  Created by zhang da on 14-6-10.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "NetworkUtil.h"
#import "Reachability.h"
#import "UserDefault.h"

static NetworkUtil *_me;

@implementation NetworkUtil

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [internetReach release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        isConnected = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        internetReach = [[Reachability reachabilityForInternetConnection] retain];
        [internetReach startNotifier];
        [self updateInterfaceWithReachability:internetReach];
    }
    return self;
}

+ (NetworkUtil *)me {
    if (!_me) {
        _me = [[NetworkUtil alloc] init];
    }
    return _me;
}


#pragma mark Reachability management
- (BOOL)isWIFI {
    return [internetReach currentReachabilityStatus] == ReachableViaWWAN;
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach {
    NSString *statusString = nil;
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable: {
            statusString = @"Access Not Available";
            isConnected = NO;
            break;
        }
        case ReachableViaWWAN: {
            statusString = @"Reachable WWAN";
            isConnected = YES;
            break;
        }
        case ReachableViaWiFi: {
            statusString = @"Reachable WiFi";
            isConnected = YES;
            break;
        }
    }
    
    
    if (netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi) {
//        if (netStatus == ReachableViaWiFi) {
//            DLog(@"reachablityChanged  ======  ReachableViaWiFi");
//        }
        
        if (netStatus == ReachableViaWWAN) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reachablityChangedWWAN" object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reachablityChanged" object:nil];
    }
    DLog(@"network status : %@ %@", [curReach description], statusString);
}

- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
    
   
}

- (BOOL)reachable {
//    DLog(@"Need_ALERT === %d",Need_ALERT);
    if (!isConnected && Need_ALERT) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
        if (!lastShow || [lastShow timeIntervalSinceNow] < -8) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"网络好像有点问题, 稍后再试吧"
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
    }
    return isConnected;
}

-(BOOL)reachable:(BOOL)isLandscape
{
    return isConnected;
}


@end
