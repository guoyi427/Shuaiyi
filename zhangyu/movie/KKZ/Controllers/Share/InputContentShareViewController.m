//
//  输入自定义内容的分享预览页面
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "InputContentShareViewController.h"

#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>

#import <SDWebImage/SDWebImageDownloader.h>

#import "AudioPlayerManager.h"
#import "Comment.h"
#import "ImageEngine.h"
#import "KKZLabel.h"
#import "KKZTextView.h"
#import "Movie.h"
#import "RoundCornersButton.h"
#import "ShareEngine.h"
#import "UIColor+Hex.h"
#import "UIViewController+HideKeyboard.h"

@interface InputContentShareViewController ()

@property (nonatomic, strong) KKZLabel *contentLabel;

@property (nonatomic, strong) UIView *contentInput;

@property (nonatomic, strong) KKZTextView *inputTextView;

@property (nonatomic, strong) UIImageView *shareImageView;

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) RoundCornersButton *doneButton;


/**
 海报图 根据imageURL下载
 */
@property (nonatomic, strong) UIImage *imagePoster;

@end

@implementation InputContentShareViewController

#pragma mark - Lifecycle methods
- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
              image:(UIImage *)image
                url:(NSString *)url
               sUrl:(NSString *)sUrl
          mediaType:(int)mediaType
          shareType:(ShareType)shareType {

    self = [self init];
    if (self) {
        self.image = image;
        self.title = title;
        self.content = content;
        self.url = url;
        self.sUrl = sUrl;
        self.mediaType = mediaType;
        self.shareType = shareType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = HEX(@"#E5E5E5");

    if (self.shareType == ShareTypeSinaWeibo) {
        self.kkzTitleLabel.text = @"分享到新浪微博";
    } else if (self.shareType == ShareTypeQQSpace) {
        self.kkzTitleLabel.text = @"分享到QQ空间";
    }

    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.contentInput];
    [self.view addSubview:self.doneButton];

    [self.contentInput addSubview:self.inputTextView];
    [self.contentInput addSubview:self.shareImageView];
    
    if (self.imageURL || self.image) {
        //有图或图片路径
        
        self.shareImageView.hidden = NO;
        
        
        self.inputTextView.frame = CGRectMake(8, 6, self.contentInput.frame.size.width - 103 - 8 - 16, self.contentInput.frame.size.height - 12);
        
        if (self.imageURL == nil) {
            self.shareImageView.image = self.image;
        }else{
            //下载海报图
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageURL]
                                                                  options:SDWebImageDownloaderHighPriority
                                                                 progress:nil
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.imagePoster = image;
                                                                        self.shareImageView.image = image;
                                                                    });

                                                                }];
        }
        

        


    }else if (!self.image) {
        //没有分享图片
        self.shareImageView.hidden = YES;
        
        self.inputTextView.frame = CGRectMake(8, 6, self.contentInput.frame.size.width - 16, self.contentInput.frame.size.height - 12);

    }

    [self setupHideKeyboardForTapAnywhere];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelViewController) name:@"shareSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelViewController) name:@"shareFailed" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self dismissKeyBoard];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Init views
- (KKZLabel *)contentLabel {
    if (!_contentLabel) {
        CGRect contentRect = [self.content
                boundingRectWithSize:CGSizeMake(screentWith - 30, 40)
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }
                             context:nil];
        CGRect frame = CGRectMake(15, self.contentPositionY + 44 + 10, screentWith - 30, contentRect.size.height + 16);

        _contentLabel = [[KKZLabel alloc] initWithFrame:frame andInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = appDelegate.kkzBlue;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.text = self.content;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}

- (UIView *)contentInput {
    if (!_contentInput) {
        CGRect frame = CGRectMake(15, CGRectGetMaxY(self.contentLabel.frame) + 8, screentWith - 30, 140);

        _contentInput = [[UIView alloc] initWithFrame:frame];
        _contentInput.backgroundColor = [UIColor whiteColor];
    }
    return _contentInput;
}

- (KKZTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[KKZTextView alloc] initWithFrame:CGRectMake(8, 6, self.contentInput.frame.size.width - 16, self.contentInput.frame.size.height - 12)];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.font = [UIFont systemFontOfSize:14.0];
        _inputTextView.textColor = appDelegate.kkzTextColor;
        _inputTextView.maxWordCount = 140;
        _inputTextView.placeHoderText = @"我想说...";
        _inputTextView.placeHolderTextColor = HEX(@"#C0C0C0");
        _inputTextView.showsVerticalScrollIndicator = NO;
        _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _inputTextView;
}

- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        CGRect frame = CGRectMake(self.contentInput.frame.size.width - 8 - 103, 8, 89, 124);

        _shareImageView = [[UIImageView alloc] initWithFrame:frame];
        _shareImageView.backgroundColor = HEX(@"#F5F5F5");
        _shareImageView.hidden = YES;
    }
    return _shareImageView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        CGRect frame = CGRectMake(15, CGRectGetMaxY(self.contentInput.frame) + 16, screentWith - 30, 44);

        _doneButton = [[RoundCornersButton alloc] initWithFrame:frame];
        _doneButton.backgroundColor = appDelegate.kkzBlue;
        _doneButton.titleColor = [UIColor whiteColor];
        _doneButton.titleName = @"发送";
        _doneButton.titleFont = [UIFont systemFontOfSize:14];
        _doneButton.cornerNum = 4;
        [_doneButton addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

#pragma mark - Private
- (void)publishButtonClickHandler:(id)sender {
    if (self.inputTextView.text.length > 140) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，请不要输入超过140个字啊。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.shareType == ShareTypeSinaWeibo) {
        NSString *content = nil;
        content = [NSString stringWithFormat:@"%@ %@", self.content, self.inputTextView.text];
        [[ShareEngine shareEngine] shareToSinaWeiBo:[NSString stringWithFormat:@"%@", content]
                                              title:self.title
                                              image:self.imagePoster ? self.imagePoster : self.image
                                                url:self.url
                                           delegate:nil
                                          mediaType:self.mediaType
                                               type:self.shareType];
    }
}

- (void)dismissKeyBoard {
    [self.inputTextView resignFirstResponder];
}

- (void)keyboardWillShowHandler:(NSNotification *)notif {
    CGRect keyboardFrame;
    NSValue *value = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    [value getValue:&keyboardFrame];

    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        _keyboardHeight = keyboardFrame.size.width;
    } else {
        _keyboardHeight = keyboardFrame.size.height;
    }

    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.15];

    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.inputTextView.text.length > 140) {
        [self showHint:@"不能超过140个字哦～"];

        self.inputTextView.text = [self.inputTextView.text substringToIndex:self.inputTextView.text.length - 1];
        return;
    }
}

@end
