//
//  VipCardPageControl.h
//  CIASMovie
//
//  Created by avatar on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipCardPageControl : UIView
@property (nonatomic) NSUInteger currentPage;

- (void) setPageNumbers:(NSUInteger)count;

@end
