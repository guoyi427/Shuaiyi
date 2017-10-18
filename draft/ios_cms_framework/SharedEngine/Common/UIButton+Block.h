//
//  UIButton+Block.h
//  CIASMovie
//
//  Created by avatar on 2017/6/29.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CMSHandlerBlock)(UIButton *button);

@interface UIButton (Block)


- (void)handleWithBlock:(CMSHandlerBlock)block;


@end
