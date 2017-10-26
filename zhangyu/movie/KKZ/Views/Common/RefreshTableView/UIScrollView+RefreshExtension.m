//
//  UIScrollView+RefreshExtension.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "UIScrollView+RefreshExtension.h"

@implementation UIScrollView (RefreshExtension)

- (void)setTable_contentOffsetY:(CGFloat)table_contentOffsetY {
    CGPoint offset = self.contentOffset;
    offset.y = table_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)table_contentOffsetY {
    return self.contentOffset.y;
}

- (void)setTable_contentOffsetX:(CGFloat)table_contentOffsetX {
    CGPoint offset = self.contentOffset;
    offset.x = table_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)table_contentOffsetX {
    return self.contentOffset.x;
}

- (void)setTable_contentInsetTop:(CGFloat)table_contentInsetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = table_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)table_contentInsetTop {
    return self.contentInset.top;
}

@end
