//
//  UserScoreMovieViewController.m
//  KoMovie
//
//  Created by kokozu on 08/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserScoreMovieViewController.h"

#import "RatingView.h"
#import "MovieRequest.h"

@interface UserScoreMovieViewController () <RatingViewDelegate>
{
    CGFloat _scoreValue;
}
@end

@implementation UserScoreMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkzTitleLabel.text = @"评分";
    self.view.backgroundColor = appDelegate.kkzLine;
    
    UIButton *commitBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBarButton.frame = CGRectMake(kAppScreenWidth - 44, 20, 44, 44);
    [commitBarButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitBarButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:commitBarButton];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
    postImageView.layer.cornerRadius = 5.0;
    postImageView.layer.masksToBounds = true;
    [postImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pathVerticalS]];
    [bgView addSubview:postImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"评分";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(postImageView.mas_right).offset(15);
        make.centerY.equalTo(postImageView);
    }];
    
    RatingView *scoreRatingView = [[RatingView alloc] init];
    [scoreRatingView setImagesDeselected:@"fav_star_no_yellow_match"
                           partlySelected:@"fav_star_half_yellow"
                             fullSelected:@"fav_star_full_yellow"
                                 iconSize:CGSizeMake(30, 30)
                            andDelegate:self];
    [bgView addSubview:scoreRatingView];
    [scoreRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(5);
        make.centerY.equalTo(postImageView);
        make.height.mas_equalTo(30);
        make.width.equalTo(bgView).offset(-80);
    }];
}

- (BOOL)showNavBar {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

#pragma mark - UIButton - Action

- (void)commitButtonAction {
    if (_scoreValue == 0) {
        return;
    }
    WeakSelf
    MovieRequest *req = [[MovieRequest alloc] init];
    [req addScoreMovieId:self.model.movieId point:[NSNumber numberWithFloat: _scoreValue*2] success:^{
        [weakSelf.navigationController popViewControllerAnimated:true];
    } failure:^(NSError * _Nullable err) {
        [UIAlertView showAlertView:@"提交失败，请稍后重试" buttonText:@"确定"];
    }];
}

#pragma mark - RatingView - Delegate

- (void)ratingChanged:(CGFloat)newRating {
    _scoreValue = newRating;
}

@end
