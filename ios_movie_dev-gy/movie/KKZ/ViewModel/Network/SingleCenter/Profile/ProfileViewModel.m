//
//  ProfileViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileView.h"
#import "EditProfileViewController.h"
#import "KKZUtility.h"
#import "ProfileViewModel.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import "AccountRequest.h"
#import <objc/runtime.h>

@interface ProfileViewModel () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  控制器
 */
@property (nonatomic, weak) EditProfileViewController *controller;

/**
 *  视图
 */
@property (nonatomic, weak) EditProfileView *view;

/**
 *  回调block对象
 */
@property (nonatomic, strong) ProfileViewModel_CAll_BACK callBack;

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *userAvatar;

@end

@implementation ProfileViewModel


- (id)initWithController:(EditProfileViewController *)controller
                withView:(EditProfileView *)view {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.view = view;
    }
    return self;
}

- (void)didSelectRowAtRowNum:(NSInteger)rowNum {
    [self choosePhoto];
}

- (void)choosePhoto {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.editing = YES;
    imageController.allowsEditing = YES;
    imageController.delegate = self;

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    };

    RIButtonItem *camera = [RIButtonItem
        itemWithLabel:@"相册"
               action:^{

                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                       imageController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                       [self.controller presentViewController:imageController
                                                     animated:NO
                                                   completion:nil];
                   }
               }];

    RIButtonItem *album = [RIButtonItem
        itemWithLabel:@"相机"
               action:^{

                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                       imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
                       [self.controller presentViewController:imageController
                                                     animated:NO
                                                   completion:nil];
                   }
               }];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                                                         cancelButtonItem:cancel
                                                    destructiveButtonItem:nil
                                                         otherButtonItems:camera, album, nil];
        [actionSheet showInView:self.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                                                         cancelButtonItem:cancel
                                                    destructiveButtonItem:nil
                                                         otherButtonItems:album, nil];
        [actionSheet showInView:self.view];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    self.userAvatar = image;
    [self.controller dismissViewControllerAnimated:YES
                                        completion:nil];
    [self loadPostPhotoRequestWithImage:image];
}

- (void)loadPostPhotoRequestWithImage:(UIImage *)image {

    //加载框
    [self showIndicator];

    //上传头像请求
    AccountRequest *request = [[AccountRequest alloc] init];
    [request startHeadimg:image Sucuess:^() {
        [self updatePhotoRequestSuccess];
    }
        Fail:^(NSError *o) {
            [self updateProfileRequestFail];
        }];
}

- (void)hidenIndicator {
    [KKZUtility hidenIndicator];
}

- (void)showIndicator {
    [KKZUtility showIndicatorWithTitle:@"正在加载"];
}

- (void)updatePhotoRequestSuccess {
    [self hidenIndicator];
    if (self.callBack) {
        self.callBack(self.userAvatar);
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.userAvatar forKey:CHANGE_PHOTO_SUCCESS];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAvatar"
                                                        object:dic];
}

- (void)updateProfileRequestFail {
    [KKZUtility showAlert:@"提交失败,请重试"];
    [self hidenIndicator];
}

- (void)setBlockMethod:(ProfileViewModel_CAll_BACK)callBack {
    self.callBack = callBack;
}

@end
