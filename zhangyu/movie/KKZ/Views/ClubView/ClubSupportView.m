//
//  ClubSupportView.m
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

//#import "ClubPost.h"
#import "ClubSupportView.h"
#import "ClubTask.h"
#import "DataEngine.h"
#import "ImageEngineNew.h"
#import "TaskQueue.h"

#define ClubSupportViewWith 220
#define ClubSupportViewHeight 103
#define marginX 15
#define headerImgWith 30
#define headerImgBgWith 38
#define headerImgBgHeight 30
#define marginImgBgToImgBg 9
#define marginBgToImg 0
#define headerImgBgTopMargin 10
#define headerImgTopMargin 17
#define supportImgMarginY 20
#define supportLblHeight 18
#define supportLblFont 13

@implementation ClubSupportView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        //加载点赞的区域
        [self loadSupportView];

        self.supportHeaderImgV = [[NSMutableArray alloc] initWithCapacity:0];

        for (int i = 0; i < 10; i++) {
            [self addSupportHeaderImgWith:i andImgPath:@"avatarSImg"];
        }
    }
    return self;
}

/**
 *  加载点赞头像的区域
 */
- (void)loadSupportUserHeadImg {

    CGFloat count = self.supportUsers.count > 10 ? 10 : self.supportUsers.count;
    for (int i = 0; i < count; i++) {
        KKZAuthor *user = self.supportUsers[i];

        UIImageView *imgV = self.supportHeaderImgV[i];
        if (user.head.length) {
            [imgV loadImageWithURL:user.head andSize:ImageSizeOrign imgNameDefault:@"avatarSImg"];
        } else
            [imgV setImage:[UIImage imageNamed:@"avatarSImg"]];
    }
}

/**
 *  添加点赞头像
 */
- (void)addSupportHeaderImgWith:(NSInteger)index andImgPath:(NSString *)imagePath {
    UIView *imgVBg = [[UIView alloc] initWithFrame:CGRectMake(marginX + (index % 5) * headerImgBgWith, headerImgTopMargin + (index / 5) * (headerImgBgHeight + marginImgBgToImgBg), headerImgBgWith, headerImgBgHeight)];
    [imgVBg setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imgVBg];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(marginBgToImg, 0, headerImgWith, headerImgWith)];
    imgV.layer.cornerRadius = headerImgWith * 0.5;
    imgV.clipsToBounds = YES;
    [imgVBg addSubview:imgV];
    [imgV setBackgroundColor:[UIColor lightGrayColor]];

    [imgV setImage:[UIImage imageNamed:@"avatarSImg"]];

    [self.supportHeaderImgV addObject:imgV];
}

/**
 *  加载用户点赞的区域
 */
- (void)loadSupportView {
    //竖分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ClubSupportViewWith, headerImgTopMargin, 1, ClubSupportViewHeight - headerImgTopMargin * 2)];
    [line setBackgroundColor:[UIColor r:235 g:235 b:235]];
    [self addSubview:line];

    //点按区域
    UIButton *supportView = [[UIButton alloc] initWithFrame:CGRectMake(ClubSupportViewWith + 1, 0, screentWith - ClubSupportViewWith - 1, ClubSupportViewHeight)];
    [supportView setBackgroundColor:[UIColor clearColor]];
    [supportView addTarget:self action:@selector(supportViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:supportView];

    //点赞的图标
    UIImage *img = [UIImage imageNamed:@"unsupportIconYN"];
    supportImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(supportView.frame) - img.size.width) * 0.5, supportImgMarginY, img.size.width, img.size.height)];
    supportImgV.image = img;
    [supportView addSubview:supportImgV];
    supportImgV.userInteractionEnabled = NO;

    //共有多少人点赞的文字提示
    supportLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, ClubSupportViewHeight - supportLblHeight - supportImgMarginY, CGRectGetWidth(supportView.frame), supportLblHeight)];
    supportLbl.textColor = [UIColor blackColor];
    supportLbl.font = [UIFont systemFontOfSize:supportLblFont];
    supportLbl.textAlignment = NSTextAlignmentCenter;
    [supportView addSubview:supportLbl];
    supportLbl.userInteractionEnabled = NO;

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ClubSupportViewHeight - 1, screentWith, 1)];
    [bottomLine setBackgroundColor:[UIColor r:235 g:235 b:235]];
    [self addSubview:line];
}

/**
 *  加载数据
 */
- (void)reloadData {
    //加载点赞头像的区域
    [self loadSupportUserHeadImg];

    if (self.clubPost.upNum) {
        supportLbl.text = [NSString stringWithFormat:@"%@人赞过", [self.clubPost.upNum stringValue]];
    }

    if (self.clubPost.isUp) {
        supportImgV.image = [UIImage imageNamed:@"supportIconYN"];
    } else {
        supportImgV.image = [UIImage imageNamed:@"unsupportIconYN"];
    }
}

/**
 *  用户点赞事件
 */
- (void)supportViewClicked {
    if (self.clubPost.isUp == 0) {
        self.clubPost.isUp = 1;

        WeakSelf;
        ClubRequest *supportPostRequest = [[ClubRequest alloc] init];
        [supportPostRequest requestSupportThePostWithArticleId:self.articleId success:^(id  _Nullable responseData) {
    
            self.clubPost.isUp = 1;
            self.clubPost.upNum = [NSNumber numberWithInteger:self.clubPost.upNum.integerValue + 1 ];
            [appDelegate showAlertViewForTitle:@"" message:@"点赞成功" cancelButton:@"OK"];
            
            KKZAuthor *user = [[KKZAuthor alloc] init];
            user.userId = 0;
            user.head = responseData[@"result"];
            [weakSelf.supportUsers insertObject:user atIndex:0];
            [weakSelf reloadData];
            
            if (self.clubPost.upNum) {
                supportLbl.text = [NSString stringWithFormat:@"%@人赞过",  [self.clubPost.upNum stringValue]];
            }
            
            if (self.clubPost.isUp) {
                supportImgV.image = [UIImage imageNamed:@"supportIconYN"];
            } else {
                supportImgV.image = [UIImage imageNamed:@"unsupportIconYN"];
            }
            
            
            
        } failure:^(NSError * _Nullable err) {
        
            self.clubPost.isUp = 0;
            
        }];
    } else {
        [appDelegate showAlertViewForTitle:@"" message:@"已赞过该贴" cancelButton:@"确定"];
    }
}

@end
