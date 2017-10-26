//
//  添加通讯录好友页面
//
//  Created by alfaromeo on 12-3-30.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "AddContractCell.h"
#import "AddressBook.h"
#import "CommonViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <malloc/malloc.h>

@class AlertViewY;

typedef void (^ContactsFinishedBlock)(BOOL succeeded);

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;

@interface ContactsViewController : CommonViewController <MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddContractCellDelegate> {

    UITableView *fansTable;
    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;

    BOOL tableLocked;
    UILabel *noFansAlertLabel;

    NSMutableArray *filteredArray, *dataSource;
    NSString *phoneArrayStr; //@"13581530359,13910183438,......"

    NSString *invitedUser;

    UIViewController *KoMovieMessageComposeViewController;

    MFMessageComposeViewController *picker;

    UIImageView *headview;
    AlertViewY *noAlertView;
}

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, copy) ContactsFinishedBlock finishBlock;

@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, assign) BOOL isMyList;
@property (nonatomic, assign) SiteType siteType;

@end
