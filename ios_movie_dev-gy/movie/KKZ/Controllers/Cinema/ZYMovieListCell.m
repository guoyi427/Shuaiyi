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
    UILabel *_publishTimeLabel;
    UIImageView *_postImageView;
    UILabel *_movieNameLabel;
    UILabel *_directorLabel;
    UILabel *_actorsLabel;
    UILabel *_typeLabel;
    UILabel *_scoreLabel;
}
@end

static CGFloat TopTimeLabelHeight = 48.0;

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
    
    _publishTimeLabel = [[UILabel alloc] init];
    _publishTimeLabel.font = [UIFont systemFontOfSize:14];
    _publishTimeLabel.textColor = [UIColor blackColor];
    _publishTimeLabel.hidden = true;
    [self.contentView addSubview:_publishTimeLabel];
    [_publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
        make.width.equalTo(self.contentView);
    }];
    
    _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 80, 110)];
    _postImageView.layer.cornerRadius = 5.0;
    _postImageView.layer.masksToBounds = true;
    [self.contentView addSubview:_postImageView];
    [_postImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(_publishTimeLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(80, 110));
    }];
    
    _movieNameLabel = [[UILabel alloc] init];
    _movieNameLabel.textColor = appDelegate.kkzBlack;
    _movieNameLabel.font = [UIFont systemFontOfSize:14];
    _movieNameLabel.text = @"";
    [self.contentView addSubview:_movieNameLabel];
    [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_postImageView.mas_right).offset(20);
        make.top.equalTo(_postImageView).offset(15);
    }];
    
    _directorLabel = [[UILabel alloc] init];
    _directorLabel.textColor = appDelegate.kkzGray;
    _directorLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_directorLabel];
    [_directorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_movieNameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.top.equalTo(_movieNameLabel.mas_bottom).offset(10);
    }];
    
    _actorsLabel = [[UILabel alloc] init];
    _actorsLabel.textColor = appDelegate.kkzGray;
    _actorsLabel.font = _directorLabel.font;
    [self.contentView addSubview:_actorsLabel];
    [_actorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_movieNameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.top.equalTo(_directorLabel.mas_bottom).offset(8);
    }];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = _directorLabel.font;
    _typeLabel.textColor = appDelegate.kkzGray;
    [self.contentView addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_movieNameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.top.equalTo(_actorsLabel.mas_bottom).offset(8);
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

- (void)update:(Movie *)model type:(ZYMovieListCellType)type {
    
    _publishTimeLabel.hidden = type == ZYMovieListCellType_Current;
    
    if (type == ZYMovieListCellType_Current) {
        [_publishTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0);
            make.width.equalTo(self.contentView);
        }];
        
        _scoreLabel.font = [UIFont systemFontOfSize:20];
        _scoreLabel.textColor = appDelegate.kkzPink;
        _scoreLabel.text = model.score;
        
    } else {
        _publishTimeLabel.text = [NSString stringWithFormat:@"%@ %@", [[DateEngine sharedDateEngine] shortLineDateStringFromDate:model.publishTime], [[DateEngine sharedDateEngine] weekDayFromDate:model.publishTime]];
        _scoreLabel.font = [UIFont systemFontOfSize:10];
        _scoreLabel.textColor = appDelegate.kkzGray;
        _scoreLabel.text = @"";//[NSString stringWithFormat:@"%ld人想看", model.lookCount.integerValue];
        
    }
    
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:model.pathVerticalS] placeholderImage:[UIImage imageNamed:@"post_black_shadow"]];
    _movieNameLabel.text = model.movieName;
    _directorLabel.text = [NSString stringWithFormat:@"导演：%@", model.movieDirector];
    _actorsLabel.text = [NSString stringWithFormat:@"主演：%@", model.actor];
    _typeLabel.text = [NSString stringWithFormat:@"类型：%@", model.movieType];
    
}

@end
