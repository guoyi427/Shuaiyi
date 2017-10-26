//
//  ClubTextView.h
//  KoMovie
//
//  Created by KKZ on 16/2/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTextView : UIView <UITextViewDelegate> {
    //添加输入框
    UITextView *clubTextView;
    //实现placeholder
    UILabel *clubPlaceHolder;
    //圆角背景
    UIView *clubTextViewBg;
}

@property (nonatomic, strong, readonly) UITextView *clubTextView;
@property (nonatomic, strong, readonly) UIButton *sendBtn;
@property (nonatomic, copy) NSNumber *articleId;

- (void) replayCallback:(void(^)(NSString *text))a_block;

@end
