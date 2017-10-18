//
//  HasEmptySeatView.h
//  CIASMovie
//
//  Created by cias on 2017/3/1.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasEmptySeatView : UIView{
    UIControl   *_overlayView;
}

- (void)show;
- (void)dismiss;

@end
