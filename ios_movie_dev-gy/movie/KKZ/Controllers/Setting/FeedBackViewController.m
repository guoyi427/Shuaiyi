//
//  意见反馈页面
//
//  Created by da zhang on 11-7-19.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "FeedBackViewController.h"

#import "DateEngine.h"
#import "FeedbackTask.h"
#import "KKZTextView.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "UIColor+HEX.h"
#import "UIConstants.h"
#import "ZipArchive.h"
#import "AppRequest.h"

#define INPUT_MAX_CHARS 140

@interface FeedBackViewController ()<UITextViewDelegate>

/**
 * 页面内容布局。
 */
@property (nonatomic, strong) UIScrollView *contentHolder;

/**
 * 文字输入框。
 */
@property (nonatomic, strong) KKZTextView *inputTextView;

/**
 * 剩余字数的提示信息。
 */
@property (nonatomic, strong) UILabel *remainCountTipLabel;

/**
 * 提交按钮。
 */
@property (nonatomic, strong) RoundCornersButton *doneButton;

/**
 * 是否上传错误报告的按钮。
 */
@property (nonatomic, strong) UISwitch *uploadLogSwitcher;

/**
 * 上传错误报告的提示文字。
 */
@property (nonatomic, strong) UILabel *uploadLogHintLabel;

@end

@implementation FeedBackViewController

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"意见反馈";
    self.statusView.backgroundColor = self.navBarView.backgroundColor;

    [self.view addSubview:self.contentHolder];
    [self.contentHolder addSubview:self.inputTextView];
    [self.contentHolder addSubview:self.remainCountTipLabel];
    [self.contentHolder addSubview:self.uploadLogSwitcher];
    [self.contentHolder addSubview:self.uploadLogHintLabel];
    [self.contentHolder addSubview:self.doneButton];
    WeakSelf
    [self.inputTextView textChange:^{
        [weakSelf textFieldDidChange];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self.inputTextView becomeFirstResponder];
}

#pragma mark - Init views
- (UIScrollView *)contentHolder {
    if (!_contentHolder) {
        CGFloat top = self.contentPositionY + 44;
        CGRect frame = CGRectMake(0, top, screentWith, self.view.frame.size.height - top);

        _contentHolder = [[UIScrollView alloc] initWithFrame:frame];
        _contentHolder.backgroundColor = kUIColorGrayBackground;
        _contentHolder.alwaysBounceVertical = YES;
    }
    return _contentHolder;
}

- (KKZTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[KKZTextView alloc]
                initWithFrame:CGRectMake(15, 10, screentWith - 15 * 2, 135)];
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.placeHoderText = @"我们的进步离不开您的建议";
        _inputTextView.placeHolderTextColor = HEX(@"#C8C8C8");
        _inputTextView.returnKeyType = UIReturnKeyDone;
        _inputTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (UILabel *)remainCountTipLabel {
    if (!_remainCountTipLabel) {
        _remainCountTipLabel =
                [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 100, 16)];
        _remainCountTipLabel.textColor = HEX(@"#999999");
        _remainCountTipLabel.text =
                [NSString stringWithFormat:@"%d个字", INPUT_MAX_CHARS];
        _remainCountTipLabel.textAlignment = NSTextAlignmentLeft;
        _remainCountTipLabel.font = [UIFont systemFontOfSize:13];
        _remainCountTipLabel.backgroundColor = [UIColor clearColor];
    }
    return _remainCountTipLabel;
}

- (UISwitch *)uploadLogSwitcher {
    if (!_uploadLogSwitcher) {
        _uploadLogSwitcher =
                [[UISwitch alloc] initWithFrame:CGRectMake(15, 180, 45, 35)];
        _uploadLogSwitcher.onTintColor = appDelegate.kkzPink;
        [_uploadLogSwitcher sizeToFit];
        _uploadLogSwitcher.on = YES;
    }
    return _uploadLogSwitcher;
}

- (UILabel *)uploadLogHintLabel {
    if (!_uploadLogHintLabel) {
        CGFloat positionX = runningOniOS7 ? 75 : 95;
        _uploadLogHintLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(positionX, 180 + 7, screentWith - 100, 15)];
        _uploadLogHintLabel.text = @"上传错误报告";
        _uploadLogHintLabel.textColor = [UIColor grayColor];
        _uploadLogHintLabel.font = [UIFont systemFontOfSize:14];
        [_uploadLogHintLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _uploadLogHintLabel;
}

- (RoundCornersButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[RoundCornersButton alloc]
                initWithFrame:CGRectMake(15, 180 + 50, screentWith - 15 * 2, 40)];
        _doneButton.cornerNum = 5;
        _doneButton.titleName = @"发送";
        _doneButton.titleFont = [UIFont systemFontOfSize:14];
        _doneButton.titleColor = [UIColor whiteColor];
        _doneButton.backgroundColor = appDelegate.kkzPink;
        [_doneButton addTarget:self
                          action:@selector(doneButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

#pragma mark - Actions
- (void)doneButtonTapped {
    NSString *text = [self.inputTextView.text
            stringByTrimmingCharactersInSet:[NSCharacterSet
                                                    whitespaceAndNewlineCharacterSet]];

    if (!self.uploadLogSwitcher.isOn && text.length == 0) {
        [UIAlertView showAlertView:@"请输入内容" buttonText:@"确定"];
        return;
    }

    if (text.length > INPUT_MAX_CHARS) {
        NSString *message = [NSString stringWithFormat:@"最多输入%d个字哦～", INPUT_MAX_CHARS];
        [UIAlertView showAlertView:message buttonText:@"确定"];
        return;
    }


    if (self.uploadLogSwitcher.isOn) {
        [self uploadAppLog:text];
    } else {
        [self sendAddFeedback:text];
    }
}

- (void)uploadAppLog:(NSString *)text {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(
            NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory =
            [[documentPaths objectAtIndex:0] stringByAppendingString:@"/"];
    NSString *fileName = [NSString
            stringWithFormat:@"KoMovie/%@", [[DateEngine sharedDateEngine]
                                                    stringFromDate:[NSDate date]
                                                        withFormat:@"yyyy-MM-dd"]];
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    NSString *zipFilePath =
            [directory stringByAppendingPathComponent:@"KoMovie/UserLog.zip"];

    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        
        [appDelegate showIndicatorWithTitle:@"发送中..."
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:NO];
        
        ZipArchive *zipFile = [[ZipArchive alloc] init];
        [zipFile CreateZipFile2:zipFilePath];
        [zipFile addFileToZip:filePath newname:@"UserLog.txt"];
        [zipFile CloseZipFile2];
        
        
        AppRequest *request = [[AppRequest alloc] init];
        [request uploadLog:zipFilePath success:^{
            [appDelegate hideIndicator];
            
            [self uploadLogFinish];
            
        } failure:^(NSError * _Nullable err) {
            [self uploadLogFinish];
        }];

    } else if (text.length == 0) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"Oops，刚清了缓存，章鱼希望你说点什么再发"
                              cancelButton:@"确定"];
    } else {
        [self sendAddFeedback:text];
    }
}

- (void) uploadLogFinish
{
    NSString *text = [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length) {
        [self sendAddFeedback:text];
    } else {
        [self showSucceedAlertView];
    }

}

- (void)sendAddFeedback:(NSString *)text {
    [appDelegate showIndicatorWithTitle:@"发送中..."
                               animated:YES
                             fullScreen:NO
                           overKeyboard:YES
                            andAutoHide:NO];
    
    FeedbackTask *task = [[FeedbackTask alloc]
            initFeedback:text
                finished:^(BOOL succeed, NSDictionary *userInfo) {

                    [self feedbackFinished:userInfo status:succeed];
                }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)feedbackFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    if (succeeded) {
        [self showSucceedAlertView];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)showSucceedAlertView {
    [self.inputTextView resignFirstResponder];
    [self showHint:@"我们已经收到您的反馈，感谢您的支持！"];
    [self cancelViewController];
}

#pragma mark - PlaceHolderTextView delegate
- (void)textFieldDidChange {
    if (self.inputTextView.text.length > INPUT_MAX_CHARS) {
        self.inputTextView.text =
                [self.inputTextView.text substringToIndex:INPUT_MAX_CHARS];
    }

    unsigned long remainCount =
            INPUT_MAX_CHARS - [self.inputTextView.text length];
    self.remainCountTipLabel.text =
            [NSString stringWithFormat:@"%lu个字", remainCount];
}

@end
