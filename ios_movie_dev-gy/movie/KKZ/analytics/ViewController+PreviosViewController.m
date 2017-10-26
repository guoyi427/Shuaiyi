//
//  ViewController+PreviosViewController.m
//  KoMovie
//
//  Created by Albert on 09/01/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ViewController+PreviosViewController.h"
#import "CommonWebViewController.h"

@implementation UIViewController (PreviosViewController)

- (UIViewController *_Nullable) previosViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}


@end

@implementation UIViewController(KKZReferrer)

- (NSString *)kkz_referrer
{
    UIViewController *preVC = [self previosViewController];
    if (preVC == nil) {
        return nil;
    }
    NSString *name = nil;
    if ([preVC isKindOfClass:[CommonWebViewController class]]) {
        CommonWebViewController *webVC = (CommonWebViewController *)preVC;
        name = webVC.requestURL;
    }else{
        name = NSStringFromClass(preVC.class);
    }
    
    return name;
}

@end
