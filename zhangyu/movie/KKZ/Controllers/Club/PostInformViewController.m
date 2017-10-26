//
//  PostInformViewController.m
//  KoMovie
//
//  Created by KKZ on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "PostInformViewController.h"
#import "RoundCornersButton.h"
#import "ClubTask.h"
#import "TaskQueue.h"
#import "ClubPostReportWord.h"
#import "ReportWordBtn.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"

#define navBackgroundColor appDelegate.kkzBlue
#define btnBorderColor appDelegate.kkzBlue.CGColor
#define rightBtnWith 60
#define rightBtnHeight 44
#define marginX 15
#define rightBtnFont 16
#define wordFont 14
#define btnMargin 20
#define btnMarginX 10
#define btnMarginY 15
#define btnMarginTop 25
#define btnToTextVBg 25
#define textVToBg 10
#define textViewBgHeight 152
#define textViewHeight 120
#define btnHeightY 30
#define placeHolderToTextView 9
#define placeHolderToTextViewX 5

@interface PostInformViewController ()

@end

@implementation PostInformViewController

- (void)dealloc {
    [self removeForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载导航栏
    [self loadNavBar];
    //添加ScrollView
    [self addScrollView];
    //提示语
    remindWordArr = [[NSArray alloc] init];
    //选中的词组
    selectedRemindWordArr = [[NSMutableArray alloc] initWithCapacity:0];
    //注册键盘监听事件
    [self registerForKeyboardNotifications];
    
    [self refreshReportPostWords];
}

/**
 *  添加输入框
 */
- (void)addTextView {
    UIView *remindTextViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, lastMaxY + btnHeightY + btnToTextVBg, screentWith, textViewBgHeight)];
    [remindTextViewBg setBackgroundColor:[UIColor whiteColor]];
    [holder addSubview:remindTextViewBg];

    remindTextView = [[UITextView alloc] initWithFrame:CGRectMake(textVToBg, textVToBg, screentWith - textVToBg * 2, textViewHeight)];
    [remindTextView setBackgroundColor:[UIColor whiteColor]];
    remindTextView.textColor = [UIColor blackColor];
    remindTextView.font = [UIFont systemFontOfSize:wordFont];
    remindTextView.delegate = self;
    [remindTextViewBg addSubview:remindTextView];

    //举报框的提示信息
    [self addPlaceHolder];

    //添加键盘上方的完成按钮
    [self addKeyBoardFinishBtn];
    
    
    
    remindTextNum = [[UILabel alloc] initWithFrame:CGRectMake(marginX,remindTextViewBg.frame.size.height - 20 , remindTextView.frame.size.width - marginX, 11)];
    remindTextNum.textColor = [UIColor lightGrayColor];
    remindTextNum.text = @"0/140";
    remindTextNum.font = [UIFont systemFontOfSize:11];
    remindTextNum.textAlignment = NSTextAlignmentRight;
    [remindTextNum setBackgroundColor:[UIColor whiteColor]];
    [remindTextViewBg addSubview:remindTextNum];
}

/**
 *  添加键盘完成按钮
 */
- (void)addKeyBoardFinishBtn {
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    [topView setBarStyle:UIBarStyleDefault];

    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];

    btnToolBar.frame = CGRectMake(2, 5, 50, 30);

    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];

    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];

    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];

    [topView setItems:buttonsArray];

    [remindTextView setInputAccessoryView:topView];
    
 
}

- (void)dismissKeyBoard {
    [remindTextView resignFirstResponder];
}

/**
 * 举报框的提示信息
 */
- (void)addPlaceHolder {
    //举报框的提示信息
    remindTextViewPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(placeHolderToTextViewX,placeHolderToTextView, screentWith - marginX * 2, wordFont)];
    remindTextViewPlaceHolder.text = @"举报补充说明";
    remindTextViewPlaceHolder.textColor = [UIColor lightGrayColor];
    remindTextViewPlaceHolder.font = [UIFont systemFontOfSize:wordFont];
    [remindTextView addSubview:remindTextViewPlaceHolder];
}

//实现UITextView的代理
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        remindTextViewPlaceHolder.text = @"举报补充说明";
    } else {
        remindTextViewPlaceHolder.text = @"";
        if (textView.text.length > 140) {
            textView.text = [textView.text substringToIndex:140];
        }
    }
    remindTextNum.text = [NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length];
}


/**
 * 添加提示语信息
 */
- (void)addRemindWord {
    for (int i = 0; i < remindWordArr.count; i++) {
        
        ClubPostReportWord *reportWord = [remindWordArr objectAtIndex:i];
        [self addRoundCornersButtonWith:reportWord.typeName andIndex:i];
    }
    
    //添加输入框
    [self addTextView];
}

- (void)addRoundCornersButtonWith:(NSString *)title andIndex:(NSInteger)index {
    //计算当前词条的长度
    CGSize s = [title sizeWithFont:[UIFont systemFontOfSize:wordFont]];
    CGFloat btnWidth = s.width + btnMargin;
    CGFloat btnHeight = btnHeightY;

    //判定当前词条位置
    CGFloat x = 0;
    CGFloat y = 0;

    if (index == 0) {
        x = marginX;
        y = btnMarginTop;
    } else {
        x = lastMaxX + btnMarginX;
        y = lastMaxY;
    }

    if (btnWidth + lastMaxX + btnMarginX + marginX > screentWith) {
        x = marginX;
        y = lastMaxY + btnMarginY + btnHeightY;
    }

    //添加词条
    ReportWordBtn *remindBtn = [[ReportWordBtn alloc] initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
    [remindBtn setTitle:title forState:UIControlStateNormal];
    remindBtn.layer.cornerRadius = 3;
    [remindBtn setTitleColor:navBackgroundColor forState:UIControlStateNormal];
    [remindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    remindBtn.layer.borderWidth = 0.6;
    remindBtn.layer.borderColor = btnBorderColor;
    remindBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [remindBtn setBackgroundColor:[UIColor clearColor]];
    [remindBtn addTarget:self action:@selector(roundCornersButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    remindBtn.tag = index;
    [holder addSubview:remindBtn];

    lastMaxX = CGRectGetMaxX(remindBtn.frame);
    lastMaxY = CGRectGetMinY(remindBtn.frame);
}

/**
 * 词条被选中
 */
- (void)roundCornersButtonClicked:(UIButton *)btn {
    DLog(@"roundCornersButtonClicked");
    btn.selected = !btn.selected;
     ClubPostReportWord *reportWord = [remindWordArr objectAtIndex:btn.tag];
    if (btn.selected) {
        [btn setBackgroundColor:navBackgroundColor];
        if (![selectedRemindWordArr containsObject:[NSString stringWithFormat:@"%ld",(long)reportWord.typeId]]) {
            [selectedRemindWordArr addObject:[NSString stringWithFormat:@"%ld",(long)reportWord.typeId]];
        }

    } else {
        [btn setBackgroundColor:[UIColor clearColor]];
        if ([selectedRemindWordArr containsObject:[NSString stringWithFormat:@"%ld",(long)reportWord.typeId]]) {
            [selectedRemindWordArr removeObject:[NSString stringWithFormat:@"%ld",(long)reportWord.typeId]];
        }
    }
}


/**
 *  加载导航栏
 */
- (void)loadNavBar {
    //设置背景色
    [self.view setBackgroundColor:navBackgroundColor];
    //调整导航栏的背景色
    [self.navBarView setBackgroundColor:navBackgroundColor];

    //标题
    self.kkzTitleLabel.text = @"举报理由";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];

    //加载导航栏右边按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, 0, rightBtnWith, rightBtnHeight)];
    [leftBtn setImage:[UIImage imageNamed:@"loginCloseButton"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(7.5,3,7.5,28);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navBarView addSubview:leftBtn];
    

    //加载导航栏右边按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - marginX - rightBtnWith, 0, rightBtnWith, rightBtnHeight)];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(11,11,11,11);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:rightBtnFont];
    [self.navBarView addSubview:rightBtn];
}

/**
 *  添加UIScrollView
 */
- (void)addScrollView {
    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentHeight - (44 + self.contentPositionY))];
    [self.view addSubview:holder];
    [holder setBackgroundColor:[UIColor r:245 g:245 b:245]];
    holder.alwaysBounceVertical = YES;
    holder.delegate = self;
}

/**
 *  提交按钮被点击
 */
- (void)rightBtnClicked {
    DLog(@"提交按钮被点击");
    if (selectedRemindWordArr.count == 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请选择一种举报类型" cancelButton:@"OK"];
        return;
    }
    
    for (int i = 0; i < selectedRemindWordArr.count; i++) {
        
        if (i == 0) {
            self.typeId = selectedRemindWordArr[i];
        }else
            self.typeId = [NSString stringWithFormat:@"%@,%@",self.typeId,selectedRemindWordArr[i]];
    }
    
    ClubTask *task = [[ClubTask alloc] initCommitReportContentWithArticleId:self.articleId andTypeId:self.typeId andContent:remindTextView.text Finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self commitReportContentFinished:userInfo status:succeeded];
    }];
    
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self dismissKeyBoard];
}

- (void)commitReportContentFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    
    if (succeeded) {
        
        RIButtonItem *done = [RIButtonItem itemWithLabel:@"OK"];
        done.action = ^{
            [self performSelector:@selector(dismissViewCtr) withObject:nil afterDelay:0.0];
        };
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"提交成功"
                                               cancelButtonItem:done
                                               otherButtonItems:nil];
        [alert show];
        

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

-(void)dismissViewCtr{
 [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  关闭按钮被点击
 */
- (void)leftBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KeyboardNotifications
- (void)removeForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        [holder setFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44 + endFrame.size.height)];
        holder.contentOffset = CGPointMake(0, 100);
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];

        [holder setFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
        holder.contentOffset = CGPointMake(0, 0);
    }];
}


/**
 *  刷新列表数据
 */
- (void)refreshReportPostWords {
    ClubTask *task = [[ClubTask alloc] initReportPostWordsFinished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self ReportPostWordsFinished:userInfo status:succeeded];
    }];
    
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)ReportPostWordsFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    
    if (succeeded) {
        remindWordArr = userInfo[@"reportWordsM"];
        [self addRemindWord];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark -- scrollview delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self dismissKeyBoard];
}
#pragma mark override from CommonViewController

- (BOOL)showNavBar {

    return TRUE;
}

- (BOOL)showBackButton {

    return NO;
}

- (BOOL)showTitleBar {

    return TRUE;
}

@end
