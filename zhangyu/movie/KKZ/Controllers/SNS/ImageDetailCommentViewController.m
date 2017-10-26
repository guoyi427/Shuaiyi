//
//  ImageDetailCommentViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//
//  发布图文帖子的页面
//

#import "ImageDetailCommentViewController.h"
#import "CustomTextView.h"
#import "UIColor+Hex.h"
#import "MovieCommentData.h"
#import "ImageReviewViewController.h"
#import "MovieCommentViewController.h"
#import "KKZUtility.h"
#import "DataEngine.h"

/**************左导航栏视图*******************/
static const CGFloat closeButtonOriginX = 15.0f;
static const CGFloat closeButtonOriginY = 13.0f;
static const CGFloat closeButtonWidth = 17.0f;

/**************右导航栏视图*******************/
static const CGFloat submitButtonRight = 15.0f;
static const CGFloat submitButtonWidth = 30.0f;

/************文本输入框的尺寸***************/
static const CGFloat textViewLeft = 15.0f;
static const CGFloat textViewTop = 10.0f;
static const CGFloat textViewHeight = 100.0f;

/************图片预览尺寸***************/
static const CGFloat preViewTop = 10.0f;
static const CGFloat preCellDiff = 10.0f;
static const CGFloat preViewLeft = 15.0f;

typedef enum : NSUInteger {
    closeButtonTag = 4000,
    clickAddButtonTag,
    clickPreImageButtonTag,
} imageDetailAllButtonTag;

@interface ImageDetailCommentViewController ()

/**
 *  用户的评论
 */
@property (nonatomic, strong) CustomTextView *textView;

/**
 *  增加图片的按钮
 */
@property (nonatomic, strong) UIButton *addImageButton;

/**
 *  存储图片的缓存数组
 */
@property (nonatomic, strong) NSMutableArray *imageCacheArray;

/**
 *  关闭按钮
 */
@property (nonatomic, strong) UIButton *closelButton;

/**
 *   提交按钮
 */
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation ImageDetailCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航视图
    [self loadNavBar];

    //加载文本输入视图
    [self loadMainView];

    //加载通知
    [self loadNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //加载图片视图
    [self loadPreView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)loadNavBar {

    //视图背景
    self.view.backgroundColor = [UIColor whiteColor];

    //导航栏背景
    self.navBarView.backgroundColor = [UIColor colorWithHex:@"#191821"];
    self.kkzTitleLabel.text = @"发表内容";
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
    self.kkzTitleLabel.textColor = [UIColor whiteColor];

    //左导航按钮
    [self.navBarView addSubview:self.closelButton];

    //右导航按钮
    [self.navBarView addSubview:self.submitButton];
}

- (void)loadMainView {

    //添加文本框
    [self.view addSubview:self.textView];
    self.textView.customText = [[MovieCommentData sharedInstance] getCommentContentWithType:chooseTypeImageAndWord];
}

- (void)loadPreView {

    //移除图片预览所有按钮
    [self removeAlreadyExistingPreviewImageView];

    //初始化图片缓存视图
    [self loadImageCacheArrayCount];

    //加载图片预览视图
    int horizonCount = 4;
    CGFloat imageX = preViewLeft;
    CGFloat imageY = CGRectGetMaxY(_textView.frame) + preViewTop;
    CGFloat imageWidth = (kCommonScreenWidth - preViewLeft * 2 - (horizonCount - 1) * preCellDiff) / horizonCount;

    //遍历图片数组
    for (int i = 0; i < self.imagesArray.count; i++) {
        //创建图片按钮
        //        UIButton *button = self.imageCacheArray[i];
        //        button.tag = clickPreImageButtonTag + i;
        //        button.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);
        //        [button setImage:self.imagesArray[i]
        //                forState:UIControlStateNormal];
        //        [self.view addSubview:button];

        //创建图片按钮
        UIImageView *imageView = self.imageCacheArray[i];
        imageView.tag = clickPreImageButtonTag + i;
        imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);
        imageView.image = self.imagesArray[i];
        [self.view addSubview:imageView];

        //计算下一个控件的坐标
        if ((i + 1) % horizonCount != 0) {
            imageX += imageWidth + preCellDiff;
        } else {
            imageX = preViewLeft;
            imageY += preViewTop + imageWidth;
        }
    }

    //如果图片数组不足8个就创建添加按钮
    if (self.imagesArray.count < 8) {
        self.addImageButton.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);
        [self.view addSubview:self.addImageButton];
    }
}

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reciveCommonMethod:)
                                                 name:cameraEditorChooseButtonNotification
                                               object:nil];
}

- (void)loadImageCacheArrayCount {
    if (self.imageCacheArray.count < self.imagesArray.count) {
        NSInteger diff = self.imagesArray.count - self.imageCacheArray.count;
        for (int i = 0; i < diff; i++) {
            //            UIButton *button = [self getButton];
            //            [button removeFromSuperview];
            //            [self.imageCacheArray addObject:button];
            UIImageView *imageView = [self getImageView];
            [self.imageCacheArray addObject:imageView];
        }
    }
}

- (void)reciveCommonMethod:(NSNotification *)note {
    [self.navigationController popToViewController:self
                                          animated:YES];
}

- (void)removeAlreadyExistingPreviewImageView {
    for (int i = 0; i < self.imageCacheArray.count; i++) {
        //        UIButton *button = self.imageCacheArray[i];
        //        [button removeFromSuperview];
        UIImageView *imageView = self.imageCacheArray[i];
        [imageView removeFromSuperview];
    }
    [self.addImageButton removeFromSuperview];
}

#pragma mark - public Method
- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case closeButtonTag: {
            //取消键盘响应
            [self.textView resignFirstResponder];
            //弹出加载框
            [KKZUtility showAlertTitle:@"是否关闭此页面"
                                detail:@""
                                cancel:@"取消"
                             clickCall:^(NSInteger buttonIndex) {
                                 if (buttonIndex == 1) {
                                     [self closeViewController];
                                 } else if (buttonIndex == 0) {
                                     [self.textView becomeFirstResponder];
                                 }
                             }
                                others:@"关闭"];
            break;
        }
        case clickAddButtonTag: {

            //将清空图片标识置为FALSE
            [MovieCommentData sharedInstance].isClearImgArr = FALSE;

            //返回类型
            MovieCommentViewController *comment = [[MovieCommentViewController alloc] init];
            comment.viewType = addImageViewType;
            [self pushViewController:comment
                             animation:CommonSwitchAnimationBounce];

            break;
        }
        case submitButtonTag: {

            //取消键盘
            [self.textView resignFirstResponder];

            //判断上传字符串是否为空
            if ([KKZUtility inputStringIsEmptyWith:self.textView.text]) {
                [KKZUtility showAlertTitle:@"提示"
                                    detail:@"内容不能为空"
                                    cancel:@"重新填写"
                                 clickCall:nil
                                    others:nil];
                return;
            }

            //提交图片请求
            [KKZUtility showIndicatorWithTitle:@"正在发表"
                                        atView:self.view.window];

            //上传图片到服务器
            if (self.imagesArray.count) {
                [self uploadImageFileToServer];
            } else {
                [self sendMoviePostWithAttaches:@[]];
            }
        }
        default:
            break;
    }
}

- (void)uploadImageFileToServer {
    NSMutableArray *array =  [MovieCommentData sharedInstance].imagesArray;
    
    ClubRequest *request = [ClubRequest new];
    [request uploadPictures:array success:^(NSArray * _Nullable attaches) {
        [self sendMoviePostWithAttaches:attaches];
    } failure:^(NSError * _Nullable err) {
        [KKZUtility hidenIndicator];
        [KKZUtility showAlertTitle:@"发表帖子失败,请重试"
                            detail:@""
                            cancel:@"确定"
                         clickCall:nil
                            others:nil];
    }];
    
}

- (void)sendMoviePostWithAttaches:(NSArray *)attaches {
    
    ClubRequest *request = [ClubRequest new];
    [request requestCreatArticle:1 content:self.textView.text attaches:attaches success:^(ClubPost * _Nullable post) {
        
        [KKZUtility hidenIndicator];
        
        [self joinMovieCommentSuccessWithArticle:post];
        
    } failure:^(NSError * _Nullable err) {
        [KKZUtility hidenIndicator];
        [KKZUtility showAlertTitle:@"发表帖子失败,请重试"
                            detail:@""
                            cancel:@"确定"
                         clickCall:nil
                            others:nil];

    }];
    
}

- (void)joinMovieCommentSuccessWithArticle:(ClubPost *)article {
    //友盟事件：发送图文帖子成功
    StatisEventWithAttributes(EVENT_SNS_PUBLISH_POSTER, @{ @"type" : @"图文" });
    
    MovieCommentSuccessViewController *ctr = [[MovieCommentSuccessViewController alloc] init];
    ctr.pageFrom = self.pageFrom;
    ctr.clubPost = article;
    [self pushViewController:ctr
                     animation:CommonSwitchAnimationFlipL];
}

- (void)closeViewController {

    //将清空图片标识置为FALSE
    [MovieCommentData sharedInstance].isClearImgArr = TRUE;

    //页面销毁
    if (self.pageFrom == joinCurrentPageFromLibrary) {
        [self dismissViewControllerAnimated:NO
                                   completion:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:movieCommentSuccessCompleteNotification
                                                        object:nil];
}

- (void)chooseImage:(UITapGestureRecognizer *)tap {
    UIImageView *sender = (UIImageView *) tap.view;
    //如果图片预览按钮
    if (sender.tag >= clickPreImageButtonTag && sender.tag < clickPreImageButtonTag + self.imagesArray.count) {
        ImageReviewViewController *review = [[ImageReviewViewController alloc] init];
        review.showIndex = sender.tag - clickPreImageButtonTag;
        review.imagesArray = self.imagesArray;
        [self pushViewController:review
                         animation:CommonSwitchAnimationFlipR];
    }
}

#pragma mark - pulic Method

- (BOOL)showBackButton {
    return FALSE;
}

#pragma mark - getter Method
- (UITextView *)textView {

    if (!_textView) {
        _textView = [[CustomTextView alloc] initWithFrame:CGRectMake(textViewLeft, textViewTop + CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth - textViewLeft * 2, textViewHeight)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeHoder = @"说说你的想法吧...";
        _textView.font = [UIFont systemFontOfSize:15.0f];
        [_textView becomeFirstResponder];
    }
    return _textView;
}

- (UIButton *)addImageButton {

    if (!_addImageButton) {
        _addImageButton = [UIButton buttonWithType:0];
        UIImage *addImg = [UIImage imageNamed:@"movieComment_add"];
        [_addImageButton setImage:addImg
                         forState:UIControlStateNormal];
        [_addImageButton addTarget:self
                            action:@selector(commonBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        _addImageButton.tag = clickAddButtonTag;
        _addImageButton.layer.borderColor = [UIColor colorWithHex:@"#d8d8d8"].CGColor;
        _addImageButton.layer.borderWidth = 1.0f;
        [self.view addSubview:_addImageButton];
    }
    return _addImageButton;
}

- (UIButton *)getButton {
    UIButton *button = [UIButton buttonWithType:0];
    button.contentMode = UIViewContentModeScaleAspectFill;
    button.layer.masksToBounds = YES;
    [button addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImageView *)getImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(chooseImage:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

- (UIButton *)closelButton {
    if (!_closelButton) {
        UIImage *closeImg = [UIImage imageNamed:@"loginCloseButton"];
        _closelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closelButton.frame = CGRectMake(0.0f, 0.0f, closeButtonWidth + closeButtonOriginX * 2, closeButtonWidth + closeButtonOriginY * 2);
        _closelButton.backgroundColor = [UIColor clearColor];
        [_closelButton setImage:closeImg forState:UIControlStateNormal];
        [_closelButton setImageEdgeInsets:UIEdgeInsetsMake(closeButtonOriginY, closeButtonOriginX, closeButtonOriginY, closeButtonOriginX)];
        _closelButton.tag = closeButtonTag;
        [_closelButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _closelButton;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:0];
        CGFloat totalWidth = submitButtonWidth + 2 * submitButtonRight;
        _submitButton.frame = CGRectMake(kCommonScreenWidth - totalWidth, 0, totalWidth, CGRectGetHeight(self.navBarView.frame));
        [_submitButton setTitle:@"提交"
                       forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_submitButton setTitleColor:[UIColor colorWithHex:@"#f9c452"]
                            forState:UIControlStateNormal];
        _submitButton.tag = submitButtonTag;
        [_submitButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (NSMutableArray *)imageCacheArray {
    if (!_imageCacheArray) {
        _imageCacheArray = [[NSMutableArray alloc] init];
    }
    return _imageCacheArray;
}

- (void)dealloc {
    //将清空图片标识置为FALSE
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
