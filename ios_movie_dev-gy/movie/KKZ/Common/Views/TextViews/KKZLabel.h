//
//  可以设置内边距的UILabel
//
//  Created by wuzhen on 16/8/24.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKZLabel : UILabel

@property (nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

@end
