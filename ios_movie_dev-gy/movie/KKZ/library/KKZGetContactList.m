//
//  KKZGetContactList.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "KKZGetContactList.h"
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"
#import "ChineseToPinyin.h"

#define MaxCacheTime 2*60*60

@interface KKZGetContactList ()

/**
 *  手机号码字符串
 */
@property (nonatomic,strong) NSString *phoneArrayStr;

/**
 *  当前时间
 */
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation KKZGetContactList

@synthesize dataSource;
@synthesize phoneArrayStr;

+ (KKZGetContactList *)sharedEngine{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

/**
 *  获取联系人
 */
- (void)getContacts {
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:self.currentDate];
    if (interval > MaxCacheTime) {
        phoneArrayStr = nil;
    }
    
    if (phoneArrayStr.length > 0) {
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:contactListFinished
                                                            object:@{phoneListString:phoneArrayStr}
                                                          userInfo:nil];
        
    }else {
        NSMutableArray *addressBookTemp = [NSMutableArray array];
        
        CFErrorRef *error = nil;
        ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, error);
        __block BOOL accessGranted = NO;
        if (&ABAddressBookRequestAccessWithCompletion != NULL) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }else {
            accessGranted = YES;
        }
        
        if (accessGranted) {
            @autoreleasepool {
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
                CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
                for (CFIndex i=0; i < nPeople; i++) {
                    //初始化通讯录model类
                    AddressBook *addressBook = [[AddressBook alloc] init];
                    
                    ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                    //名
                    CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                    //姓
                    CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
                    //
                    CFStringRef abFullName = ABRecordCopyCompositeName(person);
                    
                    //CF转换为F
                    NSString *nameString = (__bridge NSString*)abName;
                    NSString *lastNameString = (__bridge NSString *)abLastName;
                    NSString *fullName = (__bridge NSString *)abFullName;
                    
                    if (fullName !=nil) {
                        nameString = (__bridge NSString *)abFullName;
                    }else {
                        if (lastNameString != nil)
                        {
                            nameString = [NSString stringWithFormat:@"%@ %@", nameString,lastNameString];
                        }
                    }
                    
                    //地址model赋值
                    addressBook.name = nameString;
                    addressBook.namePY = [ChineseToPinyin pinyinFromChiniseString:nameString];
                    addressBook.recordID = ABRecordGetRecordID(person);
                    
                    //获取手机号
                    NSString *ss = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty);
                    ABMultiValueRef phones =(__bridge ABMultiValueRef)(ss);
                    
                    //遍历每个人的电话数量
                    
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
                
                    //如果检测出来的model手机号符合11位就添加model到数据数组里
                    if ([addressBook.tel length] == 11 && [addressBook.name length]) {
                        [addressBookTemp addObject:addressBook];
                    }
                    
                    if (abName) CFRelease(abName);
                    if (abLastName) CFRelease(abLastName);
                    if (abFullName) CFRelease(abFullName);
                    if (phones) CFRelease(phones);
                }
                CFRelease(allPeople);
                
                //全局数组赋值
                dataSource = addressBookTemp;
                
                //将手机号码字符串初始化
                [self preparePhoneData];
                
                //发送通知
                if (!phoneArrayStr) {
                    phoneArrayStr = @"";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:contactListFinished
                                                                    object:@{phoneListString:phoneArrayStr}
                                                                  userInfo:nil];
            }
        }else {
            
            //消息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:contactListFailed
                                                                object:nil];
            
            //提示框
            [appDelegate showAlertViewForTitle:@"通讯录获取失败"
                                       message:@"请到系统设置-隐私-通讯录中打开应用的权限"
                                  cancelButton:@"OK"];
            
        }
        if (addressBooks) {
             CFRelease(addressBooks);
        }
        
        //记录当前时间
        self.currentDate = [NSDate date];
    }
}


-(void)preparePhoneData{
    
    //如果排序后的手机号数组为空直接返回
    if (![dataSource count]) {
        return;
    }
    
    //拼接手机字符串
    phoneArrayStr = nil;
    for (AddressBook *phone in dataSource) {
        if (phoneArrayStr) {
            phoneArrayStr = [NSString stringWithFormat:@"%@,%@",phoneArrayStr,phone.tel];
        }else {
            phoneArrayStr = phone.tel;
        }
    }
    phoneArrayStr = [NSString stringWithFormat:@"%@,",phoneArrayStr];
}

@end
