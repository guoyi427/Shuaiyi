//
//  可以设置内边距的UILabel
//
//  Created by wuzhen on 16/8/24.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZLabel.h"

@implementation KKZLabel

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
