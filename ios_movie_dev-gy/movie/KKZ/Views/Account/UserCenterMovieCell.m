//
//  UserCenterMovieCell.m
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterMovieCell.h"

#import "RatingView.h"

@interface UserCenterMovieCell ()
{
    UIImageView *_posterImageView;
    UILabel *_movieNameLabel;
    UILabel *_actorsLabel;
    
    UILabel *_scoreTitleLabel;
    RatingView *_scoreView;
    UILabel *_scoreNumberLabel;
}
@end

@implementation UserCenterMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _posterImageView = [[UIImageView alloc] init];
        _posterImageView.layer.cornerRadius = 5.0;
        _posterImageView.layer.masksToBounds = true;
        [self.contentView addSubview:_posterImageView];
        [_posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(80, 110));
        }];
        
        _movieNameLabel = [[UILabel alloc] init];
        _movieNameLabel.font = [UIFont systemFontOfSize:14];
        _movieNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_movieNameLabel];
        [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_posterImageView.mas_right).offset(20);
            make.top.equalTo(_posterImageView).offset(18);
        }];
        
        _actorsLabel = [[UILabel alloc] init];
        _actorsLabel.font = [UIFont systemFontOfSize:12];
        _actorsLabel.textColor = appDelegate.kkzGray;
        [self.contentView addSubview:_actorsLabel];
        [_actorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_movieNameLabel);
            make.right.lessThanOrEqualTo(self.contentView).offset(-20);
            make.top.equalTo(_movieNameLabel.mas_bottom).offset(10);
        }];
        
        _scoreTitleLabel = [[UILabel alloc] init];
        _scoreTitleLabel.textColor = [UIColor blackColor];
        _scoreTitleLabel.font = [UIFont systemFontOfSize:12];
        _scoreTitleLabel.text = @"我的评分";
        [self.contentView addSubview:_scoreTitleLabel];
        [_scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_movieNameLabel);
            make.top.equalTo(_actorsLabel.mas_bottom).offset(15);
        }];
        
        _scoreNumberLabel = [[UILabel alloc] init];
        _scoreNumberLabel.textColor = appDelegate.kkzPink;
        _scoreNumberLabel.font = [UIFont systemFontOfSize:20];
        _scoreNumberLabel.text = @"0";
        [self.contentView addSubview:_scoreNumberLabel];
        [_scoreNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(_movieNameLabel);
        }];
        
        _scoreView = [[RatingView alloc] init];
        [_scoreView setImagesDeselected:@"fav_star_no_yellow_match"
                         partlySelected:@"fav_star_half_yellow"
                           fullSelected:@"fav_star_full_yellow"
                               iconSize:CGSizeMake(14, 14)
                            andDelegate:nil];
        _scoreView.userInteractionEnabled = false;
        [self.contentView addSubview:_scoreView];
        [_scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scoreTitleLabel.mas_right).offset(10);
            make.centerY.equalTo(_scoreTitleLabel);
            make.size.mas_equalTo(CGSizeMake(130, 20));
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = appDelegate.kkzLine;
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)updateModel:(NSDictionary *)model isScore:(BOOL)isScore {
    _scoreTitleLabel.hidden = !isScore;
    _scoreView.hidden = !isScore;
    _scoreNumberLabel.hidden = !isScore;
    
    [_posterImageView sd_setImageWithURL:[NSURL URLWithString:model[@"movie"][@"pathVerticalS"]]];
    
    _movieNameLabel.text = model[@"movie"][@"movieName"];
    _actorsLabel.text = model[@"movie"][@"actor"];
    
    if (isScore) {
        [_scoreView displayRating:[model[@"movie"][@"score"] floatValue]/2.0];
        _scoreNumberLabel.text = model[@"movie"][@"score"];
    }
}
@end
