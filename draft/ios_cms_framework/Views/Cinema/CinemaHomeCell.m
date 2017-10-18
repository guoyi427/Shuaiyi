//
//  CinemaHomeCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/20.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "CinemaHomeCell.h"
#import "MovieSmallPosterCollectionViewCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "KKZTextUtility.h"
#import "LocationEngine.h"

@implementation CinemaHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.bgView = [UIView new];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor yellowColor];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        cinemaNameLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        cinemaNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:cinemaNameLabel];

        nearLabel = [self getFlagLabelWithFont:10 withBgColor:@"#66CCFF" withTextColor:@"#FFFFFF"];
        nearLabel.text = @"最近";
        nearLabel.hidden = YES;
        [self addSubview:nearLabel];
        
        comeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#3CC192" withTextColor:@"#FFFFFF"];
        comeLabel.text = @"来过";
        comeLabel.hidden = YES;
        [self addSubview:comeLabel];

        locationImageView = [UIImageView new];
        locationImageView.backgroundColor = [UIColor clearColor];
        locationImageView.clipsToBounds = YES;
        locationImageView.image = [UIImage imageNamed:@"list_location_icon"];
        locationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:locationImageView];
        
        cinemaAddressLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:cinemaAddressLabel];
        
        huiImageView = [UIImageView new];
        huiImageView.backgroundColor = [UIColor clearColor];
        huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
        huiImageView.contentMode = UIViewContentModeScaleAspectFit;
        huiImageView.clipsToBounds = YES;
        [self addSubview:huiImageView];
        huiImageView.hidden = YES;
        
        promotionLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:promotionLabel];
        promotionLabel.hidden = YES;
        
        priceLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#ff9900"] textAlignment:NSTextAlignmentRight];
        [self addSubview:priceLabel];
        
        distanceLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentRight];
        [self addSubview:distanceLabel];
        
        [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(15));
            make.width.equalTo(@(kCommonScreenWidth-200));
            make.height.equalTo(@(15));
            
        }];
        [nearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cinemaNameLabel.mas_right).offset(5);
            make.width.equalTo(@(29));
            make.top.equalTo(@(15));
            make.height.equalTo(@(15));
        }];
        [comeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cinemaNameLabel.mas_right).offset(5);
            make.width.equalTo(@(29));
            make.top.equalTo(@(15));
            make.height.equalTo(@(15));
        }];

        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(6);
            make.width.equalTo(@(12));
            make.height.equalTo(@(14));
        }];

        [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(5);
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(6);
            make.width.equalTo(@(kCommonScreenWidth-170));
            make.height.equalTo(@(15));
            
        }];
        //MARK: 加入标签位置
        cinemaFeatureView = [[UIView alloc] init];
        cinemaFeatureView.backgroundColor = [UIColor clearColor];
        [self addSubview:cinemaFeatureView];
        [cinemaFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
            make.height.equalTo(@0);
        }];

        [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(cinemaFeatureView.mas_bottom).offset(10);
            make.width.equalTo(@(16));
            make.height.equalTo(@(16));
                    }];

        [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(huiImageView.mas_right).offset(5);
            make.top.equalTo(cinemaFeatureView.mas_bottom).offset(10);
            make.width.equalTo(@(kCommonScreenWidth-50));
            make.height.equalTo(@(15));
            
        }];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(15));
            make.width.equalTo(@(80));
            make.height.equalTo(@(15));
            
        }];

        [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(8);
            make.width.equalTo(@(80));
            make.height.equalTo(@(15));
            
        }];
        _movieList = [[NSMutableArray alloc] initWithCapacity:0];
        UICollectionViewFlowLayout *movieFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [movieFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _movieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 91, kCommonScreenWidth-15, 134) collectionViewLayout:movieFlowLayout];
        _movieCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_movieCollectionView];
        _movieCollectionView.showsHorizontalScrollIndicator = NO;
        _movieCollectionView.delegate = self;
        _movieCollectionView.dataSource = self;
        [_movieCollectionView registerClass:[MovieSmallPosterCollectionViewCell class] forCellWithReuseIdentifier:@"MovieSmallPosterCollectionViewCell"];
//        [_movieList addObjectsFromArray:[NSArray arrayWithObjects:@"全部",@"2017年1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil]];
//        [_movieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(15);
//            make.top.equalTo(huiImageView.mas_bottom).offset(15);
//            make.width.equalTo(@(kCommonScreenWidth-15));
//            make.height.equalTo(self.mas_bottom).offset(-15);
//        }];
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];
        
        
        UIImage *noHotMovieAlertImage = [UIImage imageNamed:@"movie_nodata"];
        NSString *noHotMovieAlertStr = @"准备排片中，请稍后";
        CGSize noHotMovieAlertStrSize = [KKZTextUtility measureText:noHotMovieAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
        self.noMovieListAlertView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - noHotMovieAlertImage.size.width)/2, (134 - (noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenWidthRate))/2, noHotMovieAlertImage.size.width, noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenWidthRate)];
        UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
        [self.noMovieListAlertView addSubview:noOrderAlertImageView];
        noOrderAlertImageView.image = noHotMovieAlertImage;
        noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
        [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.noMovieListAlertView);
            make.height.equalTo(@(noHotMovieAlertImage.size.height));
        }];
        UILabel *noOrderAlertLabel = [KKZTextUtility getLabelWithText:noHotMovieAlertStr font:[UIFont systemFontOfSize:15*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentCenter];
        [self.noMovieListAlertView addSubview:noOrderAlertLabel];
        [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.noMovieListAlertView);
            make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
            make.height.equalTo(@(noHotMovieAlertStrSize.height));
        }];
        

    }
    return self;
}

- (void)updateLayout{
    
    
    //没有影片信息，展示展位图
    if (self.movieList.count > 0) {
        if (self.noMovieListAlertView.superview) {
            [self.noMovieListAlertView removeFromSuperview];
        }
    } else {
        if (self.noMovieListAlertView.superview) {
        } else {
            [_movieCollectionView addSubview:self.noMovieListAlertView];
        }
    }
    
    nearLabel.hidden = YES;
    comeLabel.hidden = YES;

    cinemaNameLabel.text = self.selectCinema.cinemaName;
    cinemaAddressLabel.text = self.selectCinema.address;
    
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    
    //MARK: 加入标签
#if kIsHaveTipLabelInCinemaList
    if (self.featureArr.count > 0) {
        for (UIView *view in cinemaFeatureView.subviews) {
            [view removeFromSuperview];
        }
        CGFloat leftGap = 15.0;
        NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
        if (self.featureArr.count > 4) {
            for (int i = 0; i < 4; i++) {
                [tmpArr addObject:[self.featureArr objectAtIndex:i]];
            }
        } else {
            [tmpArr addObjectsFromArray:self.featureArr];
        }
        for (NSDictionary *dic in tmpArr) {
            NSString *featureStr = [dic kkz_stringForKey:@"name"];
            CGSize featureStrSize = [KKZTextUtility measureText:featureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
            UILabel *featureLabel = [[UILabel alloc] init];
            featureLabel.text = featureStr;
            featureLabel.font = [UIFont systemFontOfSize:10];
//            featureLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
//            featureLabel.layer.borderColor = [UIColor colorWithHex:@"#ff9900"].CGColor;
            featureLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
            featureLabel.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor].CGColor;

            featureLabel.layer.borderWidth = 1.0f;
            featureLabel.layer.cornerRadius = 2.0;
            featureLabel.clipsToBounds = YES;
            [cinemaFeatureView addSubview:featureLabel];
            featureLabel.textAlignment = NSTextAlignmentCenter;
            [featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cinemaFeatureView.mas_left).offset(leftGap);
                make.centerY.equalTo(cinemaFeatureView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(featureStrSize.width+5, featureStrSize.height+5));
            }];
            leftGap += featureStrSize.width+10;
        }
        
        [cinemaFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
            make.height.equalTo(@(cinemaFeatureStrSize.height+10));
        }];
        _movieCollectionView.frame = CGRectMake(15, 91+cinemaFeatureStrSize.height+10, kCommonScreenWidth-15, 134);
    }else {
        //没有标签
        for (UIView *view in cinemaFeatureView.subviews) {
            [view removeFromSuperview];
        }
        [cinemaFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
            make.height.equalTo(@(0));
        }];
        _movieCollectionView.frame = CGRectMake(15, 91, kCommonScreenWidth-15, 134);
    }
#endif
    
    
    if (self.selectCinema.discount.length > 0) {
        promotionLabel.text = [NSString stringWithFormat:@"%@", self.selectCinema.discount];
        huiImageView.hidden = NO;
        promotionLabel.hidden = NO;

    } else {
        promotionLabel.text = @"";
        huiImageView.hidden = YES;
        promotionLabel.hidden = YES;
    }
    
    priceLabel.text = [NSString stringWithFormat:@"￥%@元起", self.selectCinema.isMoney];
    if (self.selectCinema.distance.length>0 && ![self.selectCinema.distance isEqualToString:@"(null)"]  && [LocationEngine sharedLocationEngine].isHasLocation) {
        distanceLabel.text = [NSString stringWithFormat:@"%@KM", self.selectCinema.distance];
    }else{
        distanceLabel.text = @"";
    }
    if (huiImageView.hidden) {
#if kIsHaveTipLabelInCinemaList
    if (self.featureArr.count>0) {
        [_movieCollectionView setFrame:CGRectMake(15, 62+cinemaFeatureStrSize.height+10, kCommonScreenWidth-15, 134)];
    } else {
        [_movieCollectionView setFrame:CGRectMake(15, 62, kCommonScreenWidth-15, 134)];
    }
#else
     [_movieCollectionView setFrame:CGRectMake(15, 62, kCommonScreenWidth-15, 134)];
#endif
        
        
    }else{
#if kIsHaveTipLabelInCinemaList
    if (self.featureArr.count>0) {
        [_movieCollectionView setFrame:CGRectMake(15, 91+cinemaFeatureStrSize.height+10, kCommonScreenWidth-15, 134)];
    } else {
        [_movieCollectionView setFrame:CGRectMake(15, 91, kCommonScreenWidth-15, 134)];
    }
#else
    [_movieCollectionView setFrame:CGRectMake(15, 91, kCommonScreenWidth-15, 134)];
#endif
        
        
    }
    
    if ([self.selectCinema.isNear integerValue]) {
        CGSize cinemaNameSize = [KKZTextUtility measureText:self.selectCinema.cinemaName font:[UIFont systemFontOfSize:16]];
        NSInteger cinemaNameLabelLength = cinemaNameSize.width>(kCommonScreenWidth-180)?(kCommonScreenWidth-180):cinemaNameSize.width;
        [nearLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(cinemaNameLabelLength+15+5));
            make.width.equalTo(@(29));
            make.top.equalTo(@(15));
            make.height.equalTo(@(15));
        }];
        
        nearLabel.hidden = NO;

        if ([self.selectCinema.isCome integerValue]) {
            comeLabel.hidden = NO;

            [comeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nearLabel.mas_right).offset(5);
                make.width.equalTo(@(29));
                make.top.equalTo(@(15));
                make.height.equalTo(@(15));
            }];

        }
    }else{
        
        if ([self.selectCinema.isCome integerValue]) {
            comeLabel.hidden = NO;

            CGSize cinemaNameSize = [KKZTextUtility measureText:self.selectCinema.cinemaName font:[UIFont systemFontOfSize:16]];
            NSInteger cinemaNameLabelLength = cinemaNameSize.width>(kCommonScreenWidth-180)?(kCommonScreenWidth-180):cinemaNameSize.width;
            [comeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(cinemaNameLabelLength+15+5));
                make.width.equalTo(@(29));
                make.top.equalTo(@(15));
                make.height.equalTo(@(15));
            }];

        }

    }

    [_movieCollectionView reloadData];
}
- (void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        self.movieCollectionView.hidden = NO;
    }else{
        self.movieCollectionView.hidden = YES;
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        
        self.bgView.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
    }else{
        self.bgView.backgroundColor = [UIColor whiteColor];

//        if (self.isCurrentCinema == YES) {
//            self.bgView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
//        }else{
//            self.bgView.backgroundColor = [UIColor whiteColor];
//        }
    }
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.0f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}

- (void) hideMovieTimeList
{
    self.movieCollectionView.hidden = YES;
}




#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.movieList.count;//
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return 1;
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(73, 110+8+15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identify = @"MovieSmallPosterCollectionViewCell";
    MovieSmallPosterCollectionViewCell *cell = (MovieSmallPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    

    Movie *movie = [self.movieList objectAtIndex:indexPath.row];
    cell.movieName = movie.filmName;
    cell.imageUrl = movie.filmPoster;
    //    cell.point = movie.point;
    //    cell.availableScreenType = movie.availableScreenType;
    [cell updateLayout];

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Movie *movie = [self.movieList objectAtIndex:indexPath.row];
//    MovieSmallPosterCollectionViewCell *movieCell = (MovieSmallPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    Class ticketViewController= NSClassFromString(@"TicketViewController");
//    UIViewController *tickVC = [[ticketViewController alloc] init];
//    tickVC.sf_targetView = movieCell;
//    MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
//    ctr.myMovie = movie;
//    [Constants.rootNav pushViewController:ctr animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMovieWithMovie:andIndex:)]) {
        [self.delegate didSelectedMovieWithMovie:movie andIndex:self.indexRow];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
