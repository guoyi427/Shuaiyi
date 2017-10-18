//
//  NetworkUtil.m
//  KoMovie
//
//  Created by zhang da on 14-6-10.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "NetworkUtil.h"
#import "Reachability.h"

static NetworkUtil *_me;

@implementation NetworkUtil

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    internetReach = nil;
    
}

- (id)init {
    self = [super init];
    if (self) {
        Constants.isConnected = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        internetReach = [Reachability reachabilityForInternetConnection];
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
            Constants.isConnected = NO;
            break;
        }
        case ReachableViaWWAN: {
            statusString = @"Reachable WWAN";
            Constants.isConnected = YES;
            break;
        }
        case ReachableViaWiFi: {
            statusString = @"Reachable WiFi";
            Constants.isConnected = YES;
            break;
        }
    }
    DLog(@"network status : %@ %@", [curReach description], statusString);
}

- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

- (BOOL)reachable {
    if (!Constants.isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
        if (!lastShow || [lastShow timeIntervalSinceNow] < -5) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"网络好像有点问题, 稍后再试吧"
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
    }
    return Constants.isConnected;
}


@end
