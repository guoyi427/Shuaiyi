//
//  ImageSelectView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ImageSelectView.h"
#import "MovieSelectHeader.h"
#import "UIColor+Hex.h"
#import "MovieCommentViewController.h"

/*****************选择视图的布局*******************/
static const CGFloat selectBtnWidth = 35.0f;
static const CGFloat selectBtnTop = 10.0f;
static const CGFloat selectPointTop = 30.0f;
static const CGFloat selectPointWidth = 6.0f;

/*****************拍照按钮的布局*******************/
static const CGFloat takeBtnWidth = 87.0f;
static const CGFloat takeBtnTop = 49.0f;

/*****************选择相册的布局*******************/
static const CGFloat chooseAlbumLeft = 15.0f;

@interface ImageSelectView ()

/**
 *  拍照按钮
 */
@property (nonatomic, strong) UILabel *takeLbl;

/**
 *  当前视图的下一个响应者
 */
@property (nonatomic, weak) MovieCommentViewController *controller;

/**
 *  选择相册
 */
@property (nonatomic, strong) UIButton *chooseAlbumButton;

@end

@implementation ImageSelectView

- (id)initWithFrame:(CGRect)frame
     withController:(MovieCommentViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        [self addSubview:self.takeLbl];
        [self addSubview:self.chooseAlbumButton];
    }
    return self;
}

- (void)tapPress:(UIGestureRecognizer *)gesturer {
    [self.controller.movieCommentViewModel takePicture];
}

- (UILabel *)takeLbl {
    
    if (!_takeLbl) {
        _takeLbl = [self commonLabel];
        _takeLbl.tag = clickAudioButton;
        [_takeLbl viewWithTag:redCenterViewTag].backgroundColor = [UIColor whiteColor];
        [self addSubview:_takeLbl];
        
        //增加单击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [_takeLbl addGestureRecognizer:tapGesture];
    }
    return _takeLbl;
}

- (UILabel *)commonLabel {
    
    //初始化拍摄标签
    UILabel *commonLabel = [[UILabel alloc] initWithFrame:self.takeBtnFrame];
    commonLabel.backgroundColor = [UIColor blackColor];
    commonLabel.layer.cornerRadius = takeBtnWidth / 2.0f;
    commonLabel.layer.masksToBounds = YES;
    [commonLabel setTextColor:[UIColor whiteColor]];
    commonLabel.userInteractionEnabled = YES;
    commonLabel.layer.borderWidth = 3.0f;
    commonLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    commonLabel.textAlignment = NSTextAlignmentCenter;
    
    //增加一个红色圆心
    UIView *redCenterView = [[UIView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, CGRectGetWidth(commonLabel.frame) - 12.0f, CGRectGetHeight(commonLabel.frame) - 12.0f)];
    redCenterView.backgroundColor = [UIColor colorWithHex:@"#ff3b30"];
    redCenterView.layer.cornerRadius = CGRectGetHeight(redCenterView.frame)/2.0f;
    redCenterView.layer.masksToBounds = YES;
    redCenterView.tag = redCenterViewTag;
    [commonLabel addSubview:redCenterView];
    return commonLabel;
}

- (UIButton *)chooseAlbumButton {
    if (!_chooseAlbumButton) {
        _chooseAlbumButton = [UIButton buttonWithType:0];
        UIImage *albumImg = [UIImage imageNamed:@"movieComment_photo"];
        _chooseAlbumButton.frame = CGRectMake(chooseAlbumLeft, CGRectGetMidY(self.takeBtnFrame) - albumImg.size.width / 2.0f, albumImg.size.width, albumImg.size.height);
        [_chooseAlbumButton setImage:albumImg
                            forState:UIControlStateNormal];
        _chooseAlbumButton.tag = chooseAlbumButtonTag;
        [_chooseAlbumButton addTarget:self.controller
                               action:@selector(commonBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseAlbumButton];
    }
    return _chooseAlbumButton;
}

- (CGRect)takeBtnFrame {
    return CGRectMake((self.frame.size.width - takeBtnWidth)/2.0f, selectPointTop + selectPointWidth + selectBtnTop + selectBtnWidth + takeBtnTop, takeBtnWidth, takeBtnWidth);
}

@end
