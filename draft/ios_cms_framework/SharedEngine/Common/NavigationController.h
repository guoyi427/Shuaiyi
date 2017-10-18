//
//  NavigationController.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController<UIGestureRecognizerDelegate>{
    UIScreenEdgePanGestureRecognizer *_screenEdgePanGesture;
}

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGesture;

@end
