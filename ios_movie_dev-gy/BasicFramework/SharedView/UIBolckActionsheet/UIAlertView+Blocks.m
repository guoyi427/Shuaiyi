//
//  UIAlertView+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "UIAlertView+Blocks.h"

#import "KKZUtility.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";

@implementation UIAlertView (Blocks)

+ (void)showAlertView:(NSString *)message
           buttonText:(NSString *)text {

    return [self showAlertView:message
                    buttonText:text
                  buttonTapped:nil];
}

+ (void)showAlertView:(NSString *)message
           buttonText:(NSString *)text
         buttonTapped:(void (^)())buttonTapped {

    return [self showAlertViewWithTitle:@""
                                message:message
                             buttonText:text
                           buttonTapped:buttonTapped];
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    buttonText:(NSString *)text {

    return [self showAlertViewWithTitle:title
                                message:message
                             buttonText:text
                           buttonTapped:nil];
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    buttonText:(NSString *)text
                  buttonTapped:(void (^)())buttonTapped {

    return [self showAlertViewWithTitle:title
                                message:message
                             cancelText:text
                           cancelTapped:buttonTapped
                                 okText:nil
                               okTapped:nil];
}

+ (void)showAlertView:(NSString *)message
           cancelText:(NSString *)cancelText
         cancelTapped:(void (^)())cancelTapped
               okText:(NSString *)okText
             okTapped:(void (^)())okTapped {

    return [self showAlertViewWithTitle:@""
                                message:message
                             cancelText:cancelText
                           cancelTapped:cancelTapped
                                 okText:okText
                               okTapped:okTapped];
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    cancelText:(nullable NSString *)cancelText
                  cancelTapped:(void (^)())cancelTapped
                        okText:(nullable NSString *)okText
                      okTapped:(void (^)())okTapped {

    RIButtonItem *cancelButtonItem = nil;
    if (![KKZUtility stringIsEmpty:cancelText]) {
        cancelButtonItem = [RIButtonItem itemWithLabel:cancelText action:cancelTapped];
    }

    RIButtonItem *okButtonItem = nil;
    if (![KKZUtility stringIsEmpty:okText]) {
        okButtonItem = [RIButtonItem itemWithLabel:okText action:okTapped];
    }

    if ([title isEqual:nil]) {
        title = @"";
    }

    // 适配iOS9 更新UI在主线程进行
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:cancelButtonItem otherButtonItems:okButtonItem, nil];
        [alertView show];
    });
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
   cancelButtonItem:(RIButtonItem *)cancelButtonItem
   otherButtonItems:(RIButtonItem *)otherButtonItems, ... {

    if ((self = [self initWithTitle:title
                            message:message
                           delegate:self
                  cancelButtonTitle:cancelButtonItem.label
                  otherButtonTitles:nil])) {

        NSMutableArray *buttonsArray = [NSMutableArray array];

        RIButtonItem *eachItem;
        va_list argumentList;
        if (otherButtonItems) {
            [buttonsArray addObject:otherButtonItems];
            va_start(argumentList, otherButtonItems);
            while ((eachItem = va_arg(argumentList, RIButtonItem *) )) {
                [buttonsArray addObject:eachItem];
            }
            va_end(argumentList);
        }

        for (RIButtonItem *item in buttonsArray) {
            [self addButtonWithTitle:item.label];
        }

        if (cancelButtonItem)
            [buttonsArray insertObject:cancelButtonItem atIndex:0];

        objc_setAssociatedObject(self, (const void *) RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [self setDelegate:self];
    }

    return self;
}

- (NSInteger)addButtonItem:(RIButtonItem *)item {
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, (const void *) RI_BUTTON_ASS_KEY);

    NSInteger buttonIndex = [self addButtonWithTitle:item.label];
    [buttonsArray addObject:item];

    return buttonIndex;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If the button index is -1 it means we were dismissed with no selection
    if (buttonIndex >= 0) {
        NSArray *buttonsArray = objc_getAssociatedObject(self, (const void *) RI_BUTTON_ASS_KEY);
        RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if (item.action)
            item.action();
    }

    objc_setAssociatedObject(self, (const void *) RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
