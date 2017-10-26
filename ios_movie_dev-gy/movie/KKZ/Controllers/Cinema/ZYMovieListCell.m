//
//  ZYMovieListCell.m
//  KoMovie
//
//  Created by kokozu on 25/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ZYMovieListCell.h"

#import "Movie.h"

@interface ZYMovieListCell ()
{
    UIImageView *_postImageView;
    UILabel *_movieNameLabel;
    UILabel *_movieContentLabel;
    UILabel *_actorsLabel;
    UILabel *_scoreLabel;
}
@end

@implementation ZYMovieListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 80, 110)];
    _postImageView.layer.cornerRadius = 5.0;
    _postImageView.layer.masksToBounds = true;
    [self.contentView addSubview:_postImageView];
    
    _movieNameLabel = [[UILabel alloc] init];
    _movieNameLabel.textColor = appDelegate.kkzBlack;
    _movieNameLabel.font = [UIFont systemFontOfSize:14];
    _movieNameLabel.text = @"";
    [self.contentView addSubview:_movieNameLabel];
    [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_postImageView.mas_right).offset(20);
        make.top.equalTo(_postImageView).offset(30);
    }];
    
    UIImageView *contentIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:contentIconView];
    [contentIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_movieNameLabel);
        make.top.equalTo(_movieNameLabel.mas_bottom).offset(10);
    }];
    
    _movieContentLabel = [[UILabel alloc] init];
    _movieContentLabel.textColor = appDelegate.kkzPink;
    _movieContentLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_movieContentLabel];
    [_movieContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIconView.mas_right).offset(2);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.centerY.equalTo(contentIconView);
    }];
    
    _actorsLabel = [[UILabel alloc] init];
    _actorsLabel.textColor = appDelegate.kkzTextColor;
    _actorsLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_actorsLabel];
    [_actorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_movieNameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.top.equalTo(contentIconView.mas_bottom).offset(25);
    }];
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.textColor = appDelegate.kkzPink;
    _scoreLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(30);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = appDelegate.kkzGray;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)update:(Movie *)model {
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:model.pathVerticalS] placeholderImage:[UIImage imageNamed:@"post_black_shadow"]];
    _movieNameLabel.text = model.movieName;
    _movieContentLabel.text = model.movieIntro;
    _actorsLabel.text = model.actor;
    _scoreLabel.text = model.score;
}

@end
