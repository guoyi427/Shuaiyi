//
//  EditUserInfoViewController.m
//  KoMovie
//
//  Created by kokozu on 30/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EditUserInfoViewController.h"

#import "UIActionSheet+Blocks.h"
#import "KKZUtility.h"
#import "UserManager.h"
#import "UserRequest.h"

#import "AccountRequest.h"

#import "EditNickNameViewController.h"

@interface EditUserInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UILabel *_nickNameLabel;
}
@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkzTitleLabel.text = @"个人信息";
    
    UIScrollView *backgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, screentHeight-64)];
    backgroundView.contentSize = CGSizeMake(0, 0);
    backgroundView.backgroundColor = appDelegate.kkzLine;
    [self.view addSubview:backgroundView];
    
    CGFloat CellHeight = 50.0f;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, CellHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:headView];
    
    UIView *nickNameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+10, kAppScreenWidth, CellHeight)];
    nickNameView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:nickNameView];
    
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nickNameView.frame), kAppScreenWidth, CellHeight)];
    mobileView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:mobileView];
    
    CGFloat Padding = 15.0f;
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = @"安全头像";
    headLabel.textColor = appDelegate.kkzTextColor;
    headLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.mas_equalTo(Padding);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRightGray"]];
    [headView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.mas_equalTo(-Padding);
    }];
    
    UILabel *nickNameTitleLabel = [[UILabel alloc] init];
    nickNameTitleLabel.text = @"昵称";
    nickNameTitleLabel.textColor = headLabel.textColor;
    nickNameTitleLabel.font = headLabel.font;
    [nickNameView addSubview:nickNameTitleLabel];
    [nickNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNameView);
        make.left.mas_equalTo(Padding);
    }];
    
    UIImageView *arrowImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRightGray"]];
    [nickNameView addSubview:arrowImageView2];
    [arrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNameView);
        make.right.mas_equalTo(-Padding);
    }];
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.text = [DataEngine sharedDataEngine].userName;
    _nickNameLabel.textColor = [UIColor blackColor];
    _nickNameLabel.font = [UIFont systemFontOfSize:14];
    [nickNameView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNameView);
        make.right.equalTo(arrowImageView2.mas_left).offset(-5);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = appDelegate.kkzLine;
    [nickNameView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *mobileTitleLabel = [[UILabel alloc] init];
    mobileTitleLabel.textColor = headLabel.textColor;
    mobileTitleLabel.font = headLabel.font;
    mobileTitleLabel.text = @"手机号码";
    [mobileView addSubview:mobileTitleLabel];
    [mobileTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.centerY.equalTo(mobileView);
    }];
    
   
    UILabel *mobileNumberLabel = [[UILabel alloc] init];
    if ([DataEngine sharedDataEngine].phoneNum.length == 11) {
        NSString *originStr = [DataEngine sharedDataEngine].phoneNum;
        NSString *mobileStr = [NSString stringWithFormat:@"%@****%@",
                               [originStr substringToIndex:3], [originStr substringFromIndex:8]];
        mobileNumberLabel.text = mobileStr;
    }
    mobileNumberLabel.textColor = [UIColor blackColor];
    mobileNumberLabel.font = [UIFont systemFontOfSize:14];
    [mobileView addSubview:mobileNumberLabel];
    [mobileNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mobileView);
        make.right.mas_equalTo(-Padding);
    }];
    
    
    //  手势
    UITapGestureRecognizer *tapHeadView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadViewGestureRecognizerAction)];
    [headView addGestureRecognizer:tapHeadView];
    
    UITapGestureRecognizer *tapNicknameView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNicknameViewGestureRecognizerAction)];
    [nickNameView addGestureRecognizer:tapNicknameView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _nickNameLabel.text = [DataEngine sharedDataEngine].userName;
}

- (BOOL)showNavBar {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

- (BOOL)showBackButton {
    return true;
}

#pragma mark - Action

- (void)tapHeadViewGestureRecognizerAction {
    if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.editing = YES;
    imageController.allowsEditing = YES;
    imageController.delegate = self;
    
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        [[UIApplication sharedApplication]
         setStatusBarStyle:UIStatusBarStyleLightContent];
    };
    
    RIButtonItem *camera = [RIButtonItem
                            itemWithLabel:@"相册"
                            action:^{
                                
                                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                                    
                                    imageController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                    [self presentViewController:imageController
                                                       animated:NO
                                                     completion:nil];
                                }
                            }];
    
    RIButtonItem *album = [RIButtonItem
                           itemWithLabel:@"相机"
                           action:^{
                               
                               if ([UIImagePickerController
                                    isSourceTypeAvailable:
                                    UIImagePickerControllerSourceTypeCamera]) {
                                   imageController.sourceType =
                                   UIImagePickerControllerSourceTypeCamera;
                                   [self presentViewController:imageController
                                                      animated:NO
                                                    completion:nil];
                               }
                           }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                            cancelButtonItem:cancel
                       destructiveButtonItem:nil
                            otherButtonItems:camera, album, nil];
        [actionSheet showInView:appDelegate.window];
    } else {
        UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                            cancelButtonItem:cancel
                       destructiveButtonItem:nil
                            otherButtonItems:album, nil];
        [actionSheet showInView:self.view];
    }
}

- (void)tapNicknameViewGestureRecognizerAction {
    EditNickNameViewController *vc = [[EditNickNameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - Network - Request

/**
 *  上传用户头像
 */
- (void)avatarDoneWithImage:(UIImage *)image {
    
    [appDelegate showIndicatorWithTitle:@"正在上传..." animated:true fullScreen:true overKeyboard:true andAutoHide:true];
    UserRequest *request = [[UserRequest alloc] init];
    [request editHeadImage:image success:^{
        [appDelegate hideIndicator];
        [UIAlertView showAlertView:@"上传成功" buttonText:@"确定"];
    } failure:^(NSError * _Nullable err) {
        [appDelegate hideIndicator];
        [KKZUtility showAlertTitle:@"提示"
                            detail:@"头像上传失败"
                            cancel:@"确定"
                         clickCall:nil
                            others:nil];
    }];
}

#pragma mark - UIImagePickerControllerDelagate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self avatarDoneWithImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
