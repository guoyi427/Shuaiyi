//
//  ClubTextView.m
//  KoMovie
//
//  Created by KKZ on 16/2/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubTask.h"
#import "ClubTextView.h"
#import "TaskQueue.h"
#import "KKZUtility.h"
#import "DataEngine.h"
#define marginX 15
#define marginY 6
#define clubSupportBtnHeight 34
#define clubSupportBtnWidth 50
#define clubIconMargin 10
#define clubTextFont 14
#define marginIconToText 7

@interface ClubTextView()
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextView *clubTextView;
@property (nonatomic, copy) void (^replayBlock)(NSString *text);
@end

@implementation ClubTextView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setBackgroundColor:[UIColor r:242 g:242 b:242]];
        //添加输入框
        [self addClubTextView];

        //实现placeholder
        [self addClubPlaceHolder];

        //添加点赞按钮
        [self addSupportBtn];
    }
    return self;
}

/**
 *  添加输入框
 */
- (void)addClubTextView {

    //圆角背景
    clubTextViewBg = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY, screentWith - marginX * 3 - clubSupportBtnWidth, clubSupportBtnHeight)];
    [clubTextViewBg setBackgroundColor:[UIColor whiteColor]];
    clubTextViewBg.layer.cornerRadius = 17;
    [self addSubview:clubTextViewBg];

    //右边图标
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(clubIconMargin, clubIconMargin, clubSupportBtnHeight - clubIconMargin * 2, clubSupportBtnHeight - clubIconMargin * 2)];
    icon.image = [UIImage imageNamed:@"ClubCommentIcon"];
    [clubTextViewBg addSubview:icon];

    //输入框
    clubTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + marginIconToText, 0, screentWith - marginX * 3 - clubSupportBtnWidth * 2, clubSupportBtnHeight)];
    [clubTextViewBg addSubview:clubTextView];
    [clubTextView setBackgroundColor:[UIColor clearColor]];
    clubTextView.textColor = [UIColor blackColor];
    clubTextView.font = [UIFont systemFontOfSize:clubTextFont];
    clubTextView.delegate = self;

    self.clubTextView = clubTextView;
}

/**
 *  实现placeholder
 */
- (void)addClubPlaceHolder {
    clubPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, clubTextView.frame.size.width, clubSupportBtnHeight)];
    clubPlaceHolder.textColor = [UIColor lightGrayColor];
    clubPlaceHolder.text = @"回复楼主...";
    clubPlaceHolder.font = [UIFont systemFontOfSize:clubTextFont];
    clubPlaceHolder.enabled = NO;
    clubPlaceHolder.backgroundColor = [UIColor clearColor];
    [clubTextView addSubview:clubPlaceHolder];
}

/**
 *  添加点赞按钮
 */
- (void)addSupportBtn {
    UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(clubTextViewBg.frame) + marginX, marginY, clubSupportBtnWidth, clubSupportBtnHeight)];
    [self addSubview:supportBtn];
    [supportBtn setBackgroundColor:appDelegate.kkzBlue];
    [supportBtn setTitle:@"发送" forState:UIControlStateNormal];
    supportBtn.layer.cornerRadius = 17.0f;
    [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    supportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [supportBtn addTarget:self action:@selector(sendReplyWords) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = supportBtn;
}

//实现UITextView的代理
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        clubPlaceHolder.text = @"回复楼主...";
    } else {
        clubPlaceHolder.text = @"";
    }
}

- (void) replayCallback:(void(^)(NSString *text))a_block
{
    self.replayBlock = [a_block copy];
}

- (void)sendReplyWords {
    
    if (self.replayBlock) {
        self.replayBlock(clubTextView.text);
    }
    
}


@end
