//
//  DataManager.m
//  KoMovie
//
//  Created by zhoukai on 1/17/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
// 找朋友。新未添加好友数量

#import "DataManager.h"
#import "TaskQueue.h"
#import "KKZUserTask.h"
#import "DataEngine.h"
#import <ShareSDK/ShareSDK.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressBook.h"
#import <malloc/malloc.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Cryptor.h"
#import "Constants.h"
#import "PlatformUser.h"
#import "ChineseToPinyin.h"
#import "KKZUserTask.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import "KKZUser.h"

static DataManager *_dataManager = nil;

@implementation DataManager
{
    

    
    NSMutableArray *kkzFriendArray;//<TKAddressBook>
    NSMutableArray *sinaFriendArray; //<PlatformUser>

    
    BOOL kkzFinished;
    BOOL sinaFinished;
    
    
}

@synthesize hasNews;
@synthesize phoneArrayStr;
@synthesize dataSource;


+(DataManager*)shareDataManager{
    @synchronized(self) {
		if (!_dataManager) {
			_dataManager = [[DataManager alloc] init];

		}
	}
	return _dataManager;
}

-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUsersHandler:) name:@"startCheck" object:nil];
    }
    return self;

}

-(void)findFriends{
    
    
//    for (int i = 0; i<1000; i++) {
//
//        [self addContactName: [NSString stringWithFormat:@"姓名%d",i] phoneNum:@"11111111111" withLabel:@"hhhhhhhh"];
//    }
//    return;
    
    if (hasNews) { //有新的，即未读，返回老的数据
        NSString * _path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"];
        NSFileManager * aFileManager = [NSFileManager defaultManager];
        if (![aFileManager fileExistsAtPath:_path]){
            NSMutableDictionary * aDefaultDict = [[NSMutableDictionary alloc] init];
            [aDefaultDict setObject:@"test" forKey:@"TestText"];
            // 使用NSMutableDictionary的写文件接口自动创建一个Plist文件
            if (![aDefaultDict writeToFile:_path atomically:YES]) {
                DLog(@"OMG!!!");
            }
        }
        NSMutableDictionary * aDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:_path];
//        NSString *defaultKey = [NSString stringWithFormat:@"%@|%@",[DataEngine sharedDataEngine].userId,@"defaultCount"];
        NSString *newKey = [NSString stringWithFormat:@"%@|%@",[DataEngine sharedDataEngine].userId,@"newCount"];
        
//        NSNumber *defaultCount = [aDataDict kkz_intNumberForKey:defaultKey];
        NSNumber *newCount = [aDataDict kkz_intNumberForKey:newKey ];
        dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FindFriendCountFinished" object:nil userInfo:@{@"newCount":newCount,@"newFriends":self.allFriendArray}];
        });

        
    }else{
        
        [NSThread detachNewThreadSelector:@selector(getContacts)
                                 toTarget:self
                               withObject:nil];
    }

}

-(NSString*)getPhoneArrayStr{
    return phoneArrayStr;
}

-(void)fatchContacts{
    self.phoneArrayStr = nil;
    if (self.phoneArrayStr && self.phoneArrayStr.length>0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsPhoneStringFinished" object:nil userInfo:@{@"dataSource":dataSource,@"phoneArrayStr":phoneArrayStr}];

        });
    
    }else{
        [NSThread detachNewThreadSelector:@selector(getContacts)
                                 toTarget:self
                               withObject:nil];
    }


}
- (void)getContacts {
    
    
    phoneArrayStr = nil;
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    
    CFErrorRef *error = nil;
    
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
#ifdef DEBUG
        NSLog(@"Fetching contact info ----> ");
#endif
        @autoreleasepool {
            
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        for (NSInteger i = 0; i < nPeople; i++)
        { 
            AddressBook *addressBook = [[AddressBook alloc] init];
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            
            
            DLog(@"%@ ===  ====  abFullName",abFullName);
            
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            } else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            
            addressBook.name = nameString;
            addressBook.namePY = [ChineseToPinyin pinyinFromChiniseString:nameString];
            addressBook.recordID = ABRecordGetRecordID(person);;
            
            NSString *ss = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty);
                ABMultiValueRef phones =(__bridge ABMultiValueRef)(ss);
                
                for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                    //获取电话值
                    NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                    NSString *finalMobile = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    CFRelease((CFTypeRef)personPhone);
                    
                    finalMobile = [finalMobile stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                    finalMobile = [finalMobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    finalMobile = [finalMobile stringByReplacingOccurrencesOfString:@")" withString:@""];
                    finalMobile = [finalMobile stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    addressBook.tel = finalMobile;
                }
                
                if ([addressBook.tel length] == 11 && [addressBook.name length]) {
                    [addressBookTemp addObject:addressBook];
                }
                
                //             DLog(@"%@,%@",addressBook.name,addressBook.tel);
                
                if (abName) CFRelease(abName);
                if (abLastName) CFRelease(abLastName);
                if (abFullName) CFRelease(abFullName);
                if (phones) CFRelease(phones);
            

            }
            
        
        CFRelease(allPeople);
        CFRelease(addressBooks);
        
        }
        // Sort data
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        dataSource = [[theCollation sortedArrayFromArray:addressBookTemp collationStringSelector:@selector(name)] copy];
        
        
        //通讯录成功
        
        [self prepareData];
        
        if(dataSource && dataSource.count > 0 && phoneArrayStr && phoneArrayStr.length > 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startCheck" object:nil userInfo:@{@"dataSource":dataSource,@"phoneArrayStr":phoneArrayStr}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsPhoneStringFinished" object:nil userInfo:@{@"dataSource":dataSource,@"phoneArrayStr":phoneArrayStr}];
            });

        }else{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hasNoContactsPhone" object:nil userInfo:nil];
            
        }


        
    }else {
#ifdef DEBUG
        NSLog(@"Cannot fetch Contacts :( ");
#endif
        [appDelegate showAlertViewForTitle:@"通讯录获取失败" message:@"请到系统设置-隐私-通讯录中打开应用的权限" cancelButton:@"OK"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNoAlertView" object:nil];
        
        
    }
    
}

-(void)prepareData{
    if (![dataSource count]) {
        [appDelegate hideIndicator];
        return;
    }
    //    int i = 0;
    phoneArrayStr = nil;
    for (AddressBook *phone in dataSource) {
        if (phoneArrayStr) {
            phoneArrayStr = [NSString stringWithFormat:@"%@,%@",phoneArrayStr,phone.tel];
        }else {
            phoneArrayStr = phone.tel;
        }
        //        i++;
    }
    phoneArrayStr = [NSString stringWithFormat:@"%@,",phoneArrayStr];
    
    //    NSString * phoneStrFinal = nil;
    //
    //    phoneStrFinal = [phoneArrayStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    phoneStrFinal = [phoneStrFinal stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    DLog(@"phoneStrFinal-----\n%@",phoneArrayStr);
    
    
    //    phoneStrFinal = @"13311213117,";
    //    phoneArrayStr = @"18611921396,";
     
    
}

-(void)checkUsersHandler:(NSNotification*)notification{
    [self refreshKKZUserContactList];
    [self refreshKKZUserSinaList];
}

- (void)refreshKKZUserContactList {
    
    kkzFinished = NO;
    if (phoneArrayStr && phoneArrayStr.length > 0) {
        KKZUserTask *task = [[KKZUserTask alloc] initIdentifyPhoneNum:phoneArrayStr page:1 isNewFriend:@"1" finished:^(BOOL succeeded, NSDictionary *userInfo) {
            [self checkContactFinished:userInfo status:succeeded];
        }];
        
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            
        }
    }else{
        kkzFinished = YES;
        [self checkFinished];
    }

    
}

- (void)refreshKKZUserSinaList {
    
    sinaFinished = NO;
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
    NSString *userId = [credential uid];
    NSString *accessToken = [credential token];
    if (userId && userId.length>0 && accessToken && accessToken.length>0) {
        
        KKZUserTask *task = [[KKZUserTask alloc] initSinaWeiboUserListWith:userId token:accessToken ForPage:1 isNewFriend:@"1" finished:^(BOOL succeeded, NSDictionary *userInfo) {
            [self checkSinaFinished:userInfo status:succeeded];
        }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            
        }
    }else{
        sinaFinished = YES;
        [self checkFinished];
    }
    
}

- (void)checkContactFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
        kkzFinished = YES;
    
    if (succeeded) {
        NSArray *phoneNumsData = [userInfo objectForKey:@"result"];

        KKZUser *user = [KKZUser getUserWithId:[DataEngine sharedDataEngine].userId.intValue];
        kkzFriendArray = [[NSMutableArray alloc] init];
        for (int i = 0; i< phoneNumsData.count; i++) {
            NSDictionary *phoneData = phoneNumsData[i];
            NSString *mobile = [phoneData kkz_stringForKey:@"username"];

            for (int j = 0; j<dataSource.count; j++) {
//                AddressBook *a = [dataSource objectAtIndex:j];
                AddressBook *address = [[dataSource objectAtIndex:j] copy]; //保证通讯录是原始的，可以被另一套程序逻辑重用
//                
//                a.nickname = @"nihao";
//                address.name = @"haha";
                
                if ([address.tel isEqualToString:mobile] //有号码，并且不是自己
                    && ![address.tel isEqualToString:user.mobile]){
                    [address updaInfoWithDic:phoneData];
                    [kkzFriendArray addObject:address];
                }
            }
        }
        
    } else {

//        NSDictionary *logicError = [userInfo objectForKey:@"LogicError"];
//        [appDelegate showAlertViewForTitle:nil
//                                   message:[logicError kkz_stringForKey:@"error"]
//                              cancelButton:@"知道了"];
        
    }
    [self checkFinished];
    
}

- (void)checkSinaFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    sinaFinished = YES;
    
    if (succeeded) {
        
        NSArray *friendList = [userInfo kkz_objForKey:@"friends"];

       sinaFriendArray = [[NSMutableArray alloc] initWithArray:friendList];
        


    }else {
        
        
//        NSDictionary *logicError = [userInfo objectForKey:@"LogicError"];
//        
//        [appDelegate showIndicatorWithTitle:[logicError kkz_stringForKey:@"error"]
//                                   animated:NO
//                                 fullScreen:NO
//                               overKeyboard:YES
//                                andAutoHide:YES];
    }
    
    [self checkFinished];
    
}

-(void)checkFinished{
    if (kkzFinished && sinaFinished) {
        
        self.allFriendArray = [[NSMutableArray alloc] init];
        [self.allFriendArray addObjectsFromArray:kkzFriendArray];
        [self.allFriendArray addObjectsFromArray:sinaFriendArray];
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:
                                    [[NSSortDescriptor alloc] initWithKey:@"registerTime" ascending:NO], nil];
        
        self.allFriendArray = [NSMutableArray arrayWithArray:[self.allFriendArray sortedArrayUsingDescriptors:sortDescriptors]];
        
        
        NSString * _path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"];
        NSFileManager * aFileManager = [NSFileManager defaultManager];
        if (![aFileManager fileExistsAtPath:_path]){
           NSMutableDictionary * aDefaultDict = [[NSMutableDictionary alloc] init];
            [aDefaultDict setObject:@"test" forKey:@"TestText"];
            // 使用NSMutableDictionary的写文件接口自动创建一个Plist文件
            if (![aDefaultDict writeToFile:_path atomically:YES]) {
//                NSLog(@"OMG!!!");
            }
        }
        
        NSMutableDictionary * aDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:_path];
        NSString *defaultKey = [NSString stringWithFormat:@"%@|%@",[DataEngine sharedDataEngine].userId,@"defaultCount"];
        NSString *newKey = [NSString stringWithFormat:@"%@|%@",[DataEngine sharedDataEngine].userId,@"newCount"];
        
        NSNumber *defaultCount = [aDataDict kkz_intNumberForKey:defaultKey];
        NSNumber *newCount = [aDataDict kkz_intNumberForKey:newKey ];
        

        if (defaultCount == nil){
            defaultCount = @0;
        }
        if (newCount == nil) {
            newCount = @0;
        }
        // 写入数据
        [aDataDict setObject:defaultCount forKey:defaultKey];
        [aDataDict setObject:newCount forKey:newKey];
        
        //---------
        
        NSNumber *currentCount = @(kkzFriendArray.count + sinaFriendArray.count);

        if (currentCount > defaultCount) {
            newCount = @([currentCount intValue] - [defaultCount intValue]);
//            self.newCount0 = [newCount intValue];
            // 写入数据
            [aDataDict setObject:currentCount forKey:defaultKey];
            [aDataDict setObject:newCount forKey:newKey];
        }else if(currentCount == 0){
            newCount = 0;
            [aDataDict setObject:currentCount forKey:defaultKey];
            [aDataDict setObject:newCount forKey:newKey];
        }
        
        self.newCount0 = [newCount intValue];
        
        if (![aDataDict writeToFile:_path atomically:YES]) {
            DLog(@"OMG!!!");
        }
        
        hasNews = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FindFriendCountFinished" object:nil userInfo:@{@"newCount":newCount,@"newFriends":self.allFriendArray}];
        });

    }
}

-(NSDate*)dateForObj:(NSObject*)obj{
    NSDate *d = nil;
    if ([obj isKindOfClass:[AddressBook class]]) {
        d = ((AddressBook*)obj).registerTime;
    }else{
        d = ((PlatformUser*)obj).registerTime;
    }
    return d;
}

-(void)readedMessage{
    self.newCount0 = 0;
    NSString * _path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"];
    NSFileManager * aFileManager = [NSFileManager defaultManager];
    if (![aFileManager fileExistsAtPath:_path]){
        NSMutableDictionary * aDefaultDict = [[NSMutableDictionary alloc] init];
        [aDefaultDict setObject:@"test" forKey:@"TestText"];
        // 使用NSMutableDictionary的写文件接口自动创建一个Plist文件
        if (![aDefaultDict writeToFile:_path atomically:YES]) {
            DLog(@"OMG!!!");
        }
    }
    NSMutableDictionary * aDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:_path];
    NSString *newKey = [NSString stringWithFormat:@"%@|%@",[DataEngine sharedDataEngine].userId,@"newCount"];
    [aDataDict setObject:@0 forKey:newKey];
    if (![aDataDict writeToFile:_path atomically:YES]) {
        DLog(@"OMG!!!");
    }
    hasNews = NO;
}


// 添加联系人（联系人名称、号码、号码备注标签）
- (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num withLabel:(NSString*)label {
    //创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    //设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    //添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)num, (__bridge CFTypeRef)label, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    CFRelease((CFTypeRef)multi);
    
    ABAddressBookRef addressBook = nil;
    //如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        addressBook = ABAddressBookCreate();
    }
    
    //将新建联系人记录添加如通讯录中
    BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
    CFRelease((CFTypeRef)addressBook);
    CFRelease((CFTypeRef)record);

    if (!success) {
        return NO;
    } else {
        //如果添加记录成功，保存更新到通讯录数据库中
        success = ABAddressBookSave(addressBook, &error);
        return success ? YES : NO;
    }
}
@end
