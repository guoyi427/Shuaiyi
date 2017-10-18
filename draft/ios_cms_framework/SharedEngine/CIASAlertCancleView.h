//
//  CIASAlertCancleView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIASAlertCancleView : UIView

- (void) show:(NSString *)title
      message:(NSString *)message
  cancleTitle:(NSString *)cancleTitle
     callback:(void(^)(BOOL confirm))a_block;

- (void) show:(NSString *)title
      attributeMessage:(NSMutableAttributedString *)message
  cancleTitle:(NSString *)cancleTitle
     callback:(void(^)(BOOL confirm))a_block;

@end
