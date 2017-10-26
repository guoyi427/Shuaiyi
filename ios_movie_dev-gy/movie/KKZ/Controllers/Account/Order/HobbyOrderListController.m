//
//  HobbyOrderListController.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "HobbyOrderListController.h"

@interface HobbyOrderListController ()

@end

@implementation HobbyOrderListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.requestURL = Order_Requset_URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)showNavBar {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
