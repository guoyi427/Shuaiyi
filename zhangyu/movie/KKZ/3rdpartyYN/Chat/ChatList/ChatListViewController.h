//
//  ChatListViewController.h
//  KoMovie
//
//  Created by avatar on 15/7/10.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "KKZViewController.h"
@class AlertViewY;
@class nodataViewY;


@interface ChatListViewController : KKZViewController
{
    UIScrollView *holder;
    AlertViewY *noAlertView ;
    nodataViewY *nodataView;
    
}


- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@property (nonatomic, strong) NSMutableArray *userInfosArrM;

@end
