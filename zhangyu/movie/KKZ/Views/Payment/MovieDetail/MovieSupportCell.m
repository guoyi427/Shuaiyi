//
//  电影详情页面电影评价的Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "MovieSupportCell.h"
#import "MovieTask.h"
#import "TaskQueue.h"

#define marginX 15
#define marginY 20
#define titleFont 14
#define marginLineToTitle 20
#define supportBtnWidth 50
#define supportBtnHeight 80
#define supportBtnMarginY 50

#define supportImgVWidth 37

#define marginImgVToLbl 10
#define marginLblToLbl 7

#define likeLblFont 13
#define likeNumLblFont 13

@implementation MovieSupportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加title信息
        [self addTitleView];
        
        //喜欢
        [self addLikeView];
        
        //不喜欢
        [self addUnlikeView];
    }
    return self;
}
- (void)addTitleView {
    NSString *title = @"如何评价此影片";
    CGSize s = [title sizeWithFont:[UIFont systemFontOfSize:titleFont]];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - s.width) * 0.5, marginY, s.width, titleFont)];
    [self addSubview:titleLbl];
    titleLbl.font = [UIFont systemFontOfSize:titleFont];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = title;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY + titleFont * 0.5, (screentWith - s.width - marginX * 2) * 0.5 - marginLineToTitle, 0.5)];
    [self addSubview:leftLine];
    
    [leftLine setBackgroundColor:[UIColor r:211 g:211 b:211]];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLbl.frame) + marginLineToTitle, marginY + titleFont * 0.5, (screentWith - s.width - marginX * 2) * 0.5 - marginLineToTitle, 0.5)];
    [self addSubview:rightLine];
    [rightLine setBackgroundColor:[UIColor r:211 g:211 b:211]];
}

- (void)addLikeView {
    
    UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - 100) * 0.5 - supportBtnWidth, supportBtnMarginY, supportBtnWidth, supportBtnHeight)];
    UIImageView *supportImgV = [[UIImageView alloc] initWithFrame:CGRectMake((supportBtnWidth - supportImgVWidth) * 0.5, 0, supportImgVWidth, supportImgVWidth)];
    supportImgV.image = [UIImage imageNamed:@"movie_like"];
    [supportBtn addSubview:supportImgV];
    supportImgV.userInteractionEnabled = NO;
    
    [supportBtn addTarget:self action:@selector(supportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //喜欢lbl
    UILabel *likeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(supportImgV.frame) + marginImgVToLbl, supportBtnWidth, likeLblFont)];
    likeLbl.textColor = [UIColor blackColor];
    likeLbl.font = [UIFont systemFontOfSize:likeLblFont];
    likeLbl.textAlignment = NSTextAlignmentCenter;
    likeLbl.text = @"喜欢";
    [supportBtn addSubview:likeLbl];
    
    likeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(-supportBtnWidth, CGRectGetMaxY(likeLbl.frame) + marginLblToLbl, supportBtnWidth * 3, likeLblFont)];
    likeNumLbl.textColor = [UIColor lightGrayColor];
    likeNumLbl.font = [UIFont systemFontOfSize:likeLblFont];
    likeNumLbl.textAlignment = NSTextAlignmentCenter;
    likeNumLbl.text = @"";
    [supportBtn addSubview:likeNumLbl];
    [self addSubview:supportBtn];
}

- (void)addUnlikeView {
    UIButton *opposedBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith * 0.5 + 100 * 0.5, supportBtnMarginY, supportBtnWidth, supportBtnHeight)];
    UIImageView *supportImgV = [[UIImageView alloc] initWithFrame:CGRectMake((supportBtnWidth - supportImgVWidth) * 0.5, 0, supportImgVWidth, supportImgVWidth)];
    [opposedBtn addSubview:supportImgV];
    supportImgV.image = [UIImage imageNamed:@"movie_unlike"];
    supportImgV.userInteractionEnabled = NO;
    
    [opposedBtn addTarget:self action:@selector(opposedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //不喜欢lbl
    UILabel *unlikeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(supportImgV.frame) + marginImgVToLbl, supportBtnWidth, likeLblFont)];
    unlikeLbl.textColor = [UIColor blackColor];
    unlikeLbl.font = [UIFont systemFontOfSize:likeLblFont];
    unlikeLbl.textAlignment = NSTextAlignmentCenter;
    unlikeLbl.text = @"不喜欢";
    [opposedBtn addSubview:unlikeLbl];
    
    unlikeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(-supportBtnWidth, CGRectGetMaxY(unlikeLbl.frame) + marginLblToLbl, supportBtnWidth * 3, likeLblFont)];
    unlikeNumLbl.textColor = [UIColor lightGrayColor];
    unlikeNumLbl.font = [UIFont systemFontOfSize:likeLblFont];
    unlikeNumLbl.textAlignment = NSTextAlignmentCenter;
    unlikeNumLbl.text = @"";
    [opposedBtn addSubview:unlikeNumLbl];
    
    [self addSubview:opposedBtn];
}

/**
 *  更新数据
 */
- (void)upLoadData {
    if (self.likeNum.integerValue > 0) {
        likeNumLbl.text = [NSString stringWithFormat:@"%@人", self.likeNum];
    } else {
        likeNumLbl.text = [NSString stringWithFormat:@"0人"];
    }
    
    if (self.unlikeNum.integerValue > 0) {
        unlikeNumLbl.text = [NSString stringWithFormat:@"%@人", self.unlikeNum];
    } else {
        unlikeNumLbl.text = [NSString stringWithFormat:@"0人"];
    }
}

- (void)supportBtnClicked:(UIButton *)btn {
    if (![self checkCommentEnable]) {
        return;
    }
    
    if (self.relation == 0) {
        self.relation = 1;
        NSInteger num = [self.likeNum integerValue];
        num += 1;
        self.likeNum = [NSNumber numberWithInteger:num];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.likeNum], @"likeNum", [NSString stringWithFormat:@"%@", self.unlikeNum], @"unlikeNum", [NSString stringWithFormat:@"%ld", (long) self.relation], @"relation", nil];
        self.supportFinished(YES, dict);
        
        [self supportMovie];
        KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
        event.movie_id = self.movieId.stringValue;
        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionFilm_like];
    }
    
    DLog(@"支持点赞");
}

- (void)opposedBtnClicked:(UIButton *)btn {
    if (![self checkCommentEnable]) {
        return;
    }
    
    if (self.relation == 0) {
        
        self.relation = 2;
        NSInteger num = [self.unlikeNum integerValue];
        num += 1;
        self.unlikeNum = [NSNumber numberWithInteger:num];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.likeNum], @"likeNum", [NSString stringWithFormat:@"%@", self.unlikeNum], @"unlikeNum", [NSString stringWithFormat:@"%ld", (long) self.relation], @"relation", nil];
        self.supportFinished(YES, dict);
        
        [self supportMovie];
        
        KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
        event.movie_id = self.movieId.stringValue;
        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionFilm_unlike];
    }
}

- (BOOL)checkCommentEnable {
    if (self.relation == 1 || self.relation == 2) {
        [UIAlertView showAlertView:@"您已经评价过了" buttonText:@"确定" buttonTapped:nil];
        return NO;
    }
    
    if (!appDelegate.isAuthorized) {
        [UIAlertView showAlertView:@"登录之后才能进行评价，请先登录"
                        buttonText:@"确定"
                      buttonTapped:^{
                          [[DataEngine sharedDataEngine] startLoginFinished:nil];
                      }];
        return NO;
    }
    
    return YES;
}

/**
 *  关注某电影 / 取消关注
 */
- (void)supportMovie {
    
    MovieRequest *supportMovieRequest = [[MovieRequest alloc] init];
    [supportMovieRequest requestSupportMovieWithMovieId:self.movieId.integerValue relation:self.relation success:^(id  _Nullable responseObject) {
        [UIAlertView showAlertView:@"操作成功" buttonText:@"确定" buttonTapped:nil];
    } failure:^(NSError * _Nullable err) {
        //         [appDelegate showAlertViewForTaskInfo:userInfo];
        [UIAlertView showAlertView:@"操作失败" buttonText:@"确定" buttonTapped:nil];
    }];
}


@end
