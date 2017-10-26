//
//  MovieSelectView.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/29.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieSelectView.h"
#import "MovieCommentViewController.h"
#import "UIButton+Layout.h"
#import "UIColor+Hex.h"
#import "ACustomButton.h"

/*****************选择视图的布局*******************/
static const CGFloat selectBtnWidth = 35.0f;
static const CGFloat selectBtnMargin = 30.0f;
static const CGFloat selectBtnTop = 10.0f;
static const CGFloat selectViewHeight = 30.0f;
static const CGFloat selectPointTop = 30.0f;
static const CGFloat selectPointWidth = 6.0f;

/*****************拍照按钮的布局*******************/
static const CGFloat takeBtnWidth = 87.0f;
static const CGFloat takeBtnTop = 49.0f;

/*****************选择相册的布局*******************/
static const CGFloat chooseAlbumLeft = 15.0f;

@interface MovieSelectView ()

/**
 *  拍照按钮
 */
@property (nonatomic, strong) UILabel *takeLbl;


/**
 *  音频录制按钮
 */
@property (nonatomic, strong) UILabel *audioLbl;

/**
 *  选择按钮的起始X坐标
 */
@property (nonatomic, assign) CGFloat selectBtnOriginX;

/**
 *  当前视图的下一个响应者
 */
@property (nonatomic, weak) MovieCommentViewController *controller;

/**
 *  视图视图
 */
@property (nonatomic, strong) UIView *selectView;

/**
 *  当前选中的圆点
 */
@property (nonatomic, strong) UIView *selectPointView;

/**
 *  拍照按钮尺寸
 */
@property (nonatomic, assign) CGRect takeBtnFrame;

/**
 *  选择相册
 */
@property (nonatomic, strong) UIButton *chooseAlbumButton;

@end

@implementation MovieSelectView

- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加选择按钮视图
        NSArray *titleArr = @[@"图文", @"语音"];
        
        //获取下一个响应者
        self.controller = (MovieCommentViewController *)controller;
        
        //显示当前选中的原点
        [self addSubview:self.selectPointView];
        
        //开始初始化选择按钮视图
        self.selectBtnOriginX = 0.0f;
        for (int i=0; i < titleArr.count; i++) {
            
            //添加切换选择按钮
            ACustomButton *button = [self chooseButton];
            button.frame = CGRectMake(self.selectBtnOriginX,0,selectBtnWidth,selectViewHeight);
            button.tag = imageAndWordButtonTag + i;
            [button setTitle:titleArr[i]
                    forState:UIControlStateNormal];
            [self.selectView addSubview:button];
            [self.buttonsArray addObject:button];
            
            //判断当前选择的类型
            if (self.controller.type == i) {
                self.currentSelectBtn = button;
            }
            
            //修改起始按钮的X轴坐标
            if (i == titleArr.count - 1) {
                self.selectBtnOriginX  += selectBtnWidth;
            }else {
                self.selectBtnOriginX  += selectBtnMargin + selectBtnWidth;
            }
        }
        
        //修改默认显示的拍照按钮
        [self changeSelectView:self.controller.type
              withChangeButton:self.currentSelectBtn
                   withAnimate:NO];
    }
    return self;
}

- (void)changeSelectView:(chooseType)type
        withChangeButton:(UIButton *)sender
             withAnimate:(BOOL)animated {
    
    CGFloat duration = 0.5f;
    if (!animated) {
        duration = 0.0f;
    }
    
    //按钮的选择属性
    [self.currentSelectBtn setTitleColor:[UIColor colorWithHex:@"#939298"]
                                forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHex:@"#f9c452"]
                 forState:UIControlStateNormal];
    self.currentSelectBtn = sender;
    
    //根据当前选择的类型来改变当前视图的布局
    [self changeTakeButtonStatus:type];
    
    //显示按钮
    UIButton *showButton = [self.selectView viewWithTag:type + imageAndWordButtonTag];
    CGRect selectViewFrame = CGRectMake(CGRectGetMinX(self.takeBtnFrame) - (showButton.center.x - CGRectGetWidth(self.takeBtnFrame)/2.0f),selectPointTop + selectPointWidth + selectBtnTop, self.selectBtnOriginX, selectViewHeight);
    
    //执行移动动画
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.selectView.frame = selectViewFrame;
                     } completion:nil];
}

- (void)changeTakeButtonStatus:(chooseType)type {
    if (type == chooseTypeImageAndWord) {
        self.takeLbl.hidden = FALSE;
        _audioLbl.hidden = TRUE;
        self.chooseAlbumButton.hidden = FALSE;
    }else if (type == chooseTypeAudio) {
        _takeLbl.hidden = TRUE;
        self.audioLbl.hidden = FALSE;
        _chooseAlbumButton.hidden = TRUE;
    }
}

- (void)longPress:(UIGestureRecognizer *)gesturer {
    if (gesturer.state == UIGestureRecognizerStateBegan) {
        if (self.controller.type == chooseTypeAudio) {
            [self.controller.movieCommentViewModel startRecordAudio];
            [self.controller.movieCommentViewModel showAudioCancelTitle];
        }
    }else if (gesturer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesturer locationInView:gesturer.view];
        CGRect frame = CGRectMake(0, 0, takeBtnWidth, takeBtnWidth);
        if (CGRectContainsPoint(frame, point)) {
            if (self.controller.type == chooseTypeAudio) {
                [self.controller.movieCommentViewModel showAudioCancelTitle];
            }
        }else {
            if (self.controller.type == chooseTypeAudio) {
                [self.controller.movieCommentViewModel showAudioLetGoCancelTitle];
            }
        }
    }else if (gesturer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesturer locationInView:gesturer.view];
        CGRect frame = CGRectMake(0, 0, takeBtnWidth, takeBtnWidth);
        if (CGRectContainsPoint(frame, point)) {
            if (self.controller.type == chooseTypeAudio) {
                [self.controller.movieCommentViewModel stopRecordVideo];
                [self.controller.movieCommentViewModel hidenAudioCancelTitle];
            }
        }else {
             if (self.controller.type == chooseTypeAudio) {
                [self.controller.movieCommentViewModel cancelRecord];
                [self.controller.movieCommentViewModel hidenAudioCancelTitle];
            }
        }
    }else if (gesturer.state == UIGestureRecognizerStateCancelled) {
         if (self.controller.type == chooseTypeAudio) {
            [self.controller.movieCommentViewModel stopRecordVideo];
            [self.controller.movieCommentViewModel hidenAudioCancelTitle];
        }
    }
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

- (UILabel *)audioLbl {
    
    if (!_audioLbl) {
        _audioLbl = [self commonLabel];
        _audioLbl.tag = clickAudioButton;
        [self addSubview:_audioLbl];
        
        //增加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_audioLbl addGestureRecognizer:longPress];
    }
    return _audioLbl;
}

- (CGRect)takeBtnFrame {
    return CGRectMake((self.frame.size.width - takeBtnWidth)/2.0f, selectPointTop + selectPointWidth + selectBtnTop + selectBtnWidth + takeBtnTop, takeBtnWidth, takeBtnWidth);
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, selectViewHeight)];
        _selectView.backgroundColor = self.backgroundColor;
        [self addSubview:_selectView];
    }
    return _selectView;
}

- (UIView *)selectPointView {
    if (!_selectPointView) {
        _selectPointView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - selectPointWidth /2.0f, selectPointTop, selectPointWidth, selectPointWidth)];
        _selectPointView.backgroundColor = [UIColor colorWithHex:@"#f9c452"];
        _selectPointView.layer.cornerRadius = selectPointWidth / 2.0f;
        _selectPointView.layer.masksToBounds = YES;
    }
    return _selectPointView;
}

- (ACustomButton *)chooseButton {
    
    //初始化切换选择按钮
    ACustomButton *button = [ACustomButton buttonWithType:0];
    button.frame = CGRectMake(0, 0, selectBtnWidth, selectViewHeight);
    [button setTitleColor:[UIColor colorWithHex:@"#939298"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:@"#939298"]
                 forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [button addTarget:self.controller
               action:@selector(commonBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = self.backgroundColor;
    return button;
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

- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}

@end
