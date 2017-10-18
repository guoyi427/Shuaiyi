//
//  CommentViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CommentViewController.h"
#import "CIASActivityIndicatorView.h"
#import "UserRequest.h"
#import "DataEngine.h"
#import "KKZTextUtility.h"

@interface CommentViewController ()<UITextViewDelegate>
{
    UILabel     * titleLabel;
    //    评论输入框
    UITextView *commentInputView;
    //    评论数提示
    UILabel *tipsLabel;
    UIView *bgView;
    UILabel *placeHolderLabel;
}
@property (nonatomic, strong) UIView      * titleViewOfBar;
@end

@implementation CommentViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.topItem.title = @"意见反馈";
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    //MARK: 添加设置view
    //    添加
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kCommonScreenWidth, kCommonScreenHeight - 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    commentInputView = [[UITextView alloc] init]; //初始化大小
    commentInputView.frame = CGRectMake(15, 5, kCommonScreenWidth - 30, 180);
    commentInputView.textColor = [UIColor colorWithHex:@"#333333"];//设置textview里面的字体颜色
    commentInputView.font = [UIFont systemFontOfSize:14.0];//设置字体名字和字体大小
    commentInputView.delegate = self;//设置它的委托方法
    commentInputView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    commentInputView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    commentInputView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    commentInputView.scrollEnabled = YES;//是否可以拖动
    commentInputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    commentInputView.layer.borderWidth = 1.5;
    commentInputView.layer.cornerRadius = 4.0f;
    commentInputView.layer.masksToBounds = YES;
    commentInputView.layer.borderColor = [[UIColor colorWithHex:@"#e0e0e0"] CGColor];
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 20)];
    placeHolderLabel.text = @"用得不爽，有好的想法，请大声说出来...";
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    placeHolderLabel.textColor = [UIColor colorWithHex:@"b2b2b2"];
    
    [commentInputView addSubview:placeHolderLabel];
    
    
    [bgView addSubview: commentInputView];//加入到整个页面中
    
    tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonScreenWidth - 60, CGRectGetMaxY(commentInputView.frame) - 20, 30, 15)];
    tipsLabel.text = @"1000";
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [bgView addSubview:tipsLabel];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    topView.barTintColor = [UIColor whiteColor];
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    okBtn.backgroundColor = [UIColor whiteColor];
    [okBtn setTitleColor:[UIColor colorWithRed:0 green:140.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:okBtn];
    
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:flexibleSpace,barBtnItem,nil];
    [topView setItems:buttonsArray];
    [commentInputView setInputAccessoryView:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    [bgView addGestureRecognizer:tap];
    
}

-(void) dismissKeyBoard {
    [commentInputView resignFirstResponder];
}

#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:bgView];
    if (!CGRectContainsPoint(commentInputView.frame, point)) {
        [commentInputView resignFirstResponder];
    }
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    self.title = @"意见反馈";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"titlebar_back1"] WithHighlighted:[UIImage imageNamed:@"titlebar_back1"] Target:self action:@selector(cancelViewController)];
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_back1"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width, leftBarImage.size.height);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    submitCommitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitCommitBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [submitCommitBtn sizeToFit];
//    submitCommitBtn.frame = CGRectMake(10, kCommonScreenWidth-15-28, 28, 28);
    [submitCommitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitCommitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    submitCommitBtn.userInteractionEnabled = YES;
    [submitCommitBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor] forState:UIControlStateNormal];
    submitCommitBtn.backgroundColor = [UIColor clearColor];
    [submitCommitBtn addTarget:self action:@selector(submitCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:submitCommitBtn];
    self.navigationItem.rightBarButtonItem = mapItem;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithImage:nil WithHighlightedImage:nil Target:self action:@selector(submitCommentBtnClick:) title:@"提交"];
//    self.navigationItem.titleView = self.titleViewOfBar;
}

- (void)submitCommentBtnClick:(id)sender {
    DLog(@"意见可以提交审核了");
    [commentInputView resignFirstResponder];
    if (commentInputView.text.length <= 0) {
        [[CIASAlertCancleView new] show:@"" message:@"请输入评论" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
        return;
    }
    if (commentInputView.text.length >1000) {
        [[CIASAlertCancleView new] show:@"" message:@"最多能输入1000字" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
        return;
    }
    //MARK: 发送反馈
    [[UIConstants sharedDataEngine] loadingAnimation];
    UserRequest *request = [[UserRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [params setValue:[DataEngine sharedDataEngine].userName forKey:@"userName"];
    [params setValue:commentInputView.text forKey:@"context"];
    [request requestSenderSuggestionParams:params success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"感谢您的宝贵意见!" cancleTitle:@"好的" callback:^(BOOL confirm) {
            if (!confirm) {
                 [self.navigationController popToRootViewControllerAnimated:YES];
            }
           
        }];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

//MARK: UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    //  显示提示文本
    if(textView.text.length != 0)
    {
        placeHolderLabel.hidden = YES;
        [submitCommitBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];

    } else {
        placeHolderLabel.hidden = NO;
        [submitCommitBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
    }
    //    输入表情提示
//    if([self isContainsEmoji:textView.text]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告！" message:@"输入内容含有表情，请重新输入" preferredStyle:(UIAlertControllerStyleAlert)];
//        
//        // 创建按钮
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//            
//        }];
//        [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        textView.text = [textView.text substringToIndex:textView.text.length -2];
//        [textView becomeFirstResponder];
//    }
    int count;
    count = (int)(1000 - textView.text.length);
    [tipsLabel setText:[NSString stringWithFormat:@"%d", count]];  //显示剩余可输入数字
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    /*
     NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
     NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
     NSUInteger location = replacementTextRange.location;
     if (textView.text.length + text.length > 1000){
     if (location != NSNotFound){
     [textView resignFirstResponder];
     }
     return NO;
     }
     else if (location != NSNotFound){
     [textView resignFirstResponder];
     return NO;
     }
     
     //emoji无效
     
     return YES;
     */
    
    NSString *tmpStr = textView.text;
    tmpStr = [tmpStr stringByReplacingCharactersInRange:range
                                             withString:text];
    if (range.length > 0) {
        return YES;
    }
    if (tmpStr.length > 1000) {
        return NO;
    }
    return YES;
}


- (void) cancelViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 35, kCommonScreenWidth - 60*2, 15)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        NSString *titleStr = @"意见反馈";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr;
        
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width - 10)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
