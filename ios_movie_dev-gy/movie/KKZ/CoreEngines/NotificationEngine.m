//
//  NotificationEngine.m
//  KoMovie
//
//  Created by zhang da on 13-5-1.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Activity.h"
#import "DataEngine.h"
#import "KKZUtility.h"
#import "NotificationEngine.h"
#import "PushComponent.h"
#import "TaskQueue.h"
#import "Ticket.h"
#import "UIAlertView+Blocks.h"
#import "UMessage.h"
#import "UserDefault.h"

static NotificationEngine *_sharedInstance = nil;

@implementation NotificationEngine

+ (NotificationEngine *)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[NotificationEngine alloc] init];
        }
        return _sharedInstance;
    }
}

- (void)handleRomoteNotification:(NSDictionary *)userInfo showAlertView:(BOOL)showAlertView {

    if (!userInfo)
        return;

    NSDictionary *alert = [[userInfo kkz_objForKey:@"aps"] objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]) {
        //友盟推送
        if ([userInfo kkz_objForKey:@"m"] == nil) {
            [PushComponent receiveNotification:userInfo showAlertView:showAlertView];
        }
        //环信推送
        else {
            if ([userInfo kkz_objForKey:@"f"]) { //f:消息发送方的环信id t:消息接收方的环信id m:消息id
                OPEN_FROM_APNS_WRITE([userInfo kkz_objForKey:@"f"]);
            }
        }
    }
}

@end
