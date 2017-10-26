//
//  CustomAlertView.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger buttonIndex);

@interface CustomAlertView : UIView

- (id)initWithTitle:(NSString *)titleString
        detailTitle:(NSString *)detailString
       cancelButton:(NSString *)cancelString
         clickBlock:(ClickBlock)block
  otherButtonTitles:(NSString *)otherButtonTitles,...;

- (void)show;

@end
