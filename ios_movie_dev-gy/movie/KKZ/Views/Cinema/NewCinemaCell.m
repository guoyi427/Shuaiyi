//
//  影院列表的Cell
//
//  Created by KKZ on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "NewCinemaCell.h"

#import <QuartzCore/QuartzCore.h>

#import "CinemaDetail.h"
#import "CinemaCellLayout.h"
#import "UIConstants.h"
#import "KoMovie-Swift.h"
#import "Ticket.h"
#import <DateEngine_KKZ/DateEngine.h>
#import <Category_KKZ/UIColor+Hex.h>
#import "KKZUtility.h"
#define marginX 15

@interface NewCinemaCell ()

/**
 *  影院名称
 */
@property(nonatomic, strong) UILabel *cinemaLbl;

/**
 *  影院地址
 */
@property(nonatomic, strong) UILabel *addressLbl;

/**
 *  影院距离
 */
@property(nonatomic, strong) UILabel *distanceLbl;

/**
 *  影院收藏标识
 */
@property(nonatomic, strong) UIImageView *collectImgV;



/**
 *  影院活动信息
 */
@property(nonatomic, strong) UILabel *minPriceLbl;

/**
 *  cell的下划线
 */
@property(nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSArray *planList;

/**
 标签容器
 */
@property (nonatomic, strong) UIView *tagContainer;

@end

@implementation NewCinemaCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //加载影院名称
        [self addSubview:self.cinemaLbl];
        
        //加载影院地址
        [self addSubview:self.addressLbl];
        
        //加载影院距离
        [self addSubview:self.distanceLbl];
        
        //加载影院收藏标识
        [self addSubview:self.collectImgV];
        
        //加载影院最低票价
        [self addSubview:self.minPriceLbl];
        
        //加载cell的下划线
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(marginX));
            make.height.equalTo(@(K_ONE_PIXEL));
            make.bottom.equalTo(@1);
            make.right.equalTo(@0);
        }];
        
        self.tagContainer = [UIView new];
        [self addSubview:self.tagContainer];
        [self.tagContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@72);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@16);
        }];
        
    }
    return self;
}

/**
 *  加载影院信息
 */
- (void)updateCinemaCell {
  CinemaDetail *cinema = self.cinemaCellLayout.cinema;

  //影院名称
  self.cinemaLbl.text = cinema.cinemaName;
  self.cinemaLbl.font =
      [UIFont systemFontOfSize:self.cinemaCellLayout.nameFont];
  self.cinemaLbl.frame = self.cinemaCellLayout.cinemaNameFrame;

  //影院地址
  self.addressLbl.text = cinema.cinemaAddress;
  self.addressLbl.font =
      [UIFont systemFontOfSize:self.cinemaCellLayout.addressFont];
  self.addressLbl.frame = self.cinemaCellLayout.cinemaAddressFrame;

  //影院距离
  NSString *distanceStr;

  CGFloat meters = [cinema.distanceMetres floatValue];
  float kiloMeters = meters / 1000.0;

  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
      meters < 0 || meters > 100000000) {

  } else {
    if (meters < 1000) {
      distanceStr =
          [NSString stringWithFormat:@"%dm", [cinema.distanceMetres intValue]];
    } else {
      distanceStr = [NSString stringWithFormat:@"%.1fkm", kiloMeters];
    }
  }

  self.distanceLbl.text = distanceStr;
  self.distanceLbl.font =
      [UIFont systemFontOfSize:self.cinemaCellLayout.distanceFont];
  self.distanceLbl.frame = self.cinemaCellLayout.cinemaDistanceFrame;

    //去过和收藏的显示标示
  if (self.cinemaCellLayout.cinema.isCollected) {
    self.collectImgV.frame = self.cinemaCellLayout.cinemaCollectIconFrame;
    self.collectImgV.hidden = NO;
  } else {
    self.collectImgV.hidden = YES;
  }


    //加载短标题
    if (self.cinemaCellLayout.cinema.shortTitle.length &&
        [self.cinemaCellLayout.flags containsObject:self.cinemaCellLayout.cinema.shortTitle] == NO) {
        [self.cinemaCellLayout.flags addObject:self.cinemaCellLayout.cinema.shortTitle];
    }
    //加载影院特色信息
    [self addCinemaIcons];



  //加载影院最低价
  if (self.cinemaCellLayout.cinema.minPrice &&
      [self.cinemaCellLayout.cinema.minPrice floatValue] > 0) {
    self.minPriceLbl.frame = self.cinemaCellLayout.minPriceFrame;
    self.minPriceLbl.font =
        [UIFont systemFontOfSize:self.cinemaCellLayout.minPriceFont];
    self.minPriceLbl.text = self.cinemaCellLayout.minPrice;
    self.minPriceLbl.hidden = NO;
  } else {
    self.minPriceLbl.hidden = YES;
  }
}

/**
 *  添加影院特色信息
 */
- (void)addCinemaIcons {
  //先移除所有的iconBtn
    [self.tagContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat left = 0;
    UIFont *font = [UIFont systemFontOfSize:12];
    for (int i = 0; i < self.cinemaCellLayout.flags.count; i++) {
        CGSize size = [KKZUtility customTextSize:font
                                            text:self.cinemaCellLayout.flags[i]
                                            size:CGSizeMake(CGFLOAT_MAX, 15)];
        CGFloat labelWidth = size.width + 6;
        if (left + labelWidth > kCommonScreenWidth) {
            break;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, labelWidth, 15)];
        label.font = font;
        label.text = self.cinemaCellLayout.flags[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = appDelegate.kkzPink;//[UIColor colorWithHex:@"#6b8499"];
        label.layer.borderWidth = K_ONE_PIXEL;
        label.layer.borderColor = label.textColor.CGColor;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 2.0f;
        [self.tagContainer addSubview:label];
        left += label.frame.size.width + 5;
    }

}



/**
 *  影院名称
 */
- (UILabel *)cinemaLbl {
  if (!_cinemaLbl) {
    _cinemaLbl = [[UILabel alloc] init];
    _cinemaLbl.textColor = [UIColor blackColor];
  }
  return _cinemaLbl;
}

/**
 *  影院地址
 */
- (UILabel *)addressLbl {
  if (!_addressLbl) {
    _addressLbl = [[UILabel alloc] init];
    _addressLbl.textColor = [UIColor grayColor];
  }
  return _addressLbl;
}

/**
 *  影院距离
 */
- (UILabel *)distanceLbl {
  if (!_distanceLbl) {
    _distanceLbl = [[UILabel alloc] init];
    _distanceLbl.textColor = [UIColor grayColor];
  }
  return _distanceLbl;
}

/**
 *  加载影院收藏标识
 */
- (UIImageView *)collectImgV {
    if (!_collectImgV) {
        _collectImgV = [[UIImageView alloc] init];
        _collectImgV.contentMode = UIViewContentModeScaleAspectFill;
        _collectImgV.image = [UIImage imageNamed:@"cinemacollecIcon"];
        _collectImgV.hidden = YES;
    }
    return _collectImgV;
}



/**
 *  影院最低票价
 */
- (UILabel *)minPriceLbl {
  if (!_minPriceLbl) {
    _minPriceLbl = [[UILabel alloc] init];
    [_minPriceLbl setBackgroundColor:[UIColor clearColor]];
    _minPriceLbl.textColor = kUIColorOrange;
    _minPriceLbl.hidden = YES;
  }
  return _minPriceLbl;
}

/**
 *  cell的分割线
 */
- (UIView *)bottomLine {
  if (!_bottomLine) {
    _bottomLine = [[UIView alloc] init];
    [_bottomLine setBackgroundColor:kDividerColor];
  }
  return _bottomLine;
}

- (void) showMovieTimeList:(NSArray *)planList select:(void (^)(Ticket *plan))selectBlock
{
    if (planList.count == 0) {
        self.scrollContainer.hidden = YES;
        return;
    }
    
    if (self.scrollContainer == nil) {
        self.scrollContainer = [[UIScrollView alloc]init];
        self.scrollContainer.showsHorizontalScrollIndicator = NO;
        self.scrollContainer.layer.masksToBounds = NO;
        [self addSubview:self.scrollContainer];
        
    }else if(self.planList != planList){
        //clean subviews
        [self.scrollContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else{
        self.scrollContainer.hidden = NO;
        return;
    }
    
    UIView *container = [[UIView alloc]init];
    [self.scrollContainer addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollContainer);
        make.height.equalTo(self.scrollContainer);
    }];
    
    
    const NSInteger itemTagBase = 100;
    void (^itemSelectBlock)(MovieTimeView * sender) = ^(MovieTimeView * sender){
        NSInteger index = sender.tag - itemTagBase;
        if (selectBlock) {
            @try {
                selectBlock(planList[index]);
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    };
    
    UIView *preView = nil;
    for (NSInteger i = 0; i < planList.count; i++) {
        
        Ticket *plan = planList[i];
        
        MovieTimeView *movieTimeView = [MovieTimeView new];
        movieTimeView.tag = itemTagBase + i;
        movieTimeView.select = itemSelectBlock;
        //      NSDate *date = [[DateEngine sharedDateEngine] dateFromString:plan.featureTime];
        movieTimeView.movieTime = [[DateEngine sharedDateEngine] shortTimeStringFromDate:plan.movieTime];
        if (plan.screenType.length && plan.language.length) {
            movieTimeView.movieType = [NSString stringWithFormat:@"%@ %@",plan.screenType,plan.language];
        }else if(plan.screenType.length){
            movieTimeView.movieType = [NSString stringWithFormat:@"%@",plan.screenType];
        }else{
            movieTimeView.movieType = [NSString stringWithFormat:@"%@",plan.language];
        }
        //VIP价格
        NSString *vipString = nil;
        if (plan.promotionPrice) {
            //如果有特惠价，显示特惠价格
            vipString = [NSString stringWithFormat:@"￥%.2f", [plan.promotionPrice floatValue]];
        }else{
            vipString = [NSString stringWithFormat:@"￥%.2f", [plan.vipPrice floatValue]];
        }
        movieTimeView.price = vipString;
        movieTimeView.showOfferIcon = plan.hasPromotion;
        [container addSubview:movieTimeView];
        
        [movieTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (preView) {
                make.left.equalTo(preView.mas_right).insets(UIEdgeInsetsMake(0, 5, 0, 0));
            }else{
                make.left.equalTo(@15);
            }
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@75);
        }];
        
        preView = movieTimeView;
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(preView.mas_right).insets(UIEdgeInsetsMake(0, 0, 0, -15));
    }];
    
    self.planList = planList;
    
    self.scrollContainer.hidden = NO;
    
    CGFloat width = planList.count * 100;
    width = width < self.frame.size.width ? width : self.frame.size.width;
    
    [self.scrollContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@(width));
        make.height.equalTo(@60);
        make.bottom.equalTo(self.mas_bottom).offset(-17);
    }];
}

- (void) hideMovieTimeList
{
    self.scrollContainer.hidden = YES;
}

@end
