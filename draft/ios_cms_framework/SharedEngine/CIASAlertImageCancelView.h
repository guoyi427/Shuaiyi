//
//  CIASAlertImageCancelView.h
//  CIASMovie
//
//  Created by avatar on 2017/4/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIASAlertImageCancelView : UIView

@property (strong, nonatomic) UIWindow *window2;


- (void) show:(NSString *)title
      message:(NSString *)message
        image:(UIImage *)image
  cancleTitle:(NSString *)cancleTitle
     callback:(void(^)(BOOL confirm))a_block;

@end
