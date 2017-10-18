//
//  键盘上带有完成按钮的ToolBar
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZKeyboardTopView.h"

@implementation KKZKeyboardTopView

- (id)initWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 38);
    self = [super initWithFrame:newFrame];
    if (self) {
        [self setBarStyle:UIBarStyleDefault];
        self.backgroundColor = [UIColor whiteColor];

        UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnToolBar.frame = CGRectMake(2, 7, 50, 30);
        [btnToolBar addTarget:self
                          action:@selector(dismissKeyBoard)
                forControlEvents:UIControlEventTouchUpInside];
        btnToolBar.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];
        [btnToolBar setTitleColor:[UIColor colorWithRed:0
                                                  green:140 / 255.0
                                                   blue:255 / 255.0
                                                  alpha:1]
                         forState:UIControlStateNormal];

        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];
        NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];
        [self setItems:buttonsArray];
    }
    return self;
}

- (void)dismissKeyBoard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(KKZKeyboardDismissed)]) {
        [self.keyboardDelegate KKZKeyboardDismissed];
    }
}

@end
