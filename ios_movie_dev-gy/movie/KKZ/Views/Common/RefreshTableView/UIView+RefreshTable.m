//
//  UIView+RefreshTable.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "UIView+RefreshTable.h"

@implementation UIView (RefreshTable)

- (void)setHeaderView_x:(CGFloat)headerView_x {
    CGRect frame = self.frame;
    frame.origin.x = headerView_x;
    self.frame = frame;
}

- (CGFloat)headerView_x {
    return self.frame.origin.x;
}

- (void)setHeaderView_y:(CGFloat)headerView_y {
    CGRect frame = self.frame;
    frame.origin.y = headerView_y;
    self.frame = frame;
}

- (CGFloat)headerView_y {
    return self.frame.origin.y;
}

- (void)setHeaderView_width:(CGFloat)headerView_width {
    CGRect frame = self.frame;
    frame.size.width = headerView_width;
    self.frame = frame;
}

- (CGFloat)headerView_width {
    return self.frame.size.width;
}

- (void)setHeaderView_height:(CGFloat)headerView_height {
    CGRect frame = self.frame;
    frame.size.height = headerView_height;
    self.frame = frame;
}

- (CGFloat)headerView_height {
    return self.frame.size.height;
}

@end
