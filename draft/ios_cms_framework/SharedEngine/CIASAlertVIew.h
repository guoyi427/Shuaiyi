//
//  CIASAlertVIew.h
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIASAlertVIew : UIView

- (void) show:(NSString *)title
      message:(NSString *)message
        image:(UIImage *)image
  cancleTitle:(NSString *)cancleTitle
   otherTitle:(NSString *)otherTitle
     callback:(void(^)(BOOL confirm))a_block;

@end
