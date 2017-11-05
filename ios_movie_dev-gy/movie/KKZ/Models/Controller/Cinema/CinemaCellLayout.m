//
//  CinemaCellLayout.m
//  KoMovie
//
//  Created by KKZ on 16/4/11.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CinemaDetail.h"
#import "CinemaCellLayout.h"
#import "UIConstants.h"

#define kFirstFlagColor [UIColor r:230 g:86 b:78]
#define kSecondFlagColor [UIColor r:255 g:105 b:0]
#define kThirdFlagColor [UIColor r:234 g:104 b:162]
#define kForthFlagColor [UIColor r:14 g:150 b:212]
#define kSeatFlagColor [UIColor r:34 g:192 b:22]

/*****************左边距****************/
static const CGFloat marginLeft = 15.0f;

/*****************右边距****************/
static const CGFloat marginRight = 15.0f;

/*****************上边距****************/
static const CGFloat marginTop = 15.0f;

/*****************下边距****************/
static const CGFloat marginBottom = 15.0f;

/****************影院名称和影院地址之间的距离****************/
static const CGFloat marginNameToAdd = 13.0f;

/****************影院地址和影院特色信息之间的距离****************/
static const CGFloat marginAddToIcons = 10.0f;

/****************影院特色信息之间的距离距****************/
static const CGFloat marginIconToIcon = 2.7f;

/****************影院地址和影院距离之间的距离****************/
static const CGFloat marginAddToDistance = 10.0f;

/****************影院活动和最低票价之间的距离****************/
static const CGFloat marginActivityToMinPrice = 9.0f;

/****************影院名称****************/
static const CGFloat nameFontY = 16.0f;
static const CGFloat nameHeight = 18.0f;

/****************影院地址****************/
static const CGFloat addressFontY = 12.0f;
static const CGFloat addressHeight = 14.0f;

/****************影院特色信息****************/
static const CGFloat iconFontY = 12.0f;
static const CGFloat iconHeight = 18.0f;

/****************影院收藏标识****************/
static const CGFloat collectionIconWidth = 30.0f;
static const CGFloat collectionIconHeight = 30.0f;

/****************影院距离****************/
static const CGFloat distanceFontY = 12.0f;
static const CGFloat distanceHeight = 14.0f;

/****************影院活动标题****************/
static const CGFloat activityFontY = 12.0f;

/****************影院最低票价****************/
static const CGFloat minPriceFontY = 14.0f;

@interface CinemaCellLayout ()

@property(nonatomic, assign) CGFloat flagLengthT;

@end

@implementation CinemaCellLayout

- (instancetype)init {
  self = [super init];
  if (self) {
    self.nameFont = nameFontY;
    self.addressFont = addressFontY;
    self.distanceFont = distanceFontY;
    self.iconFont = iconFontY;
    self.activityFont = activityFontY;
    self.minPriceFont = minPriceFontY;
    self.flags = [[NSMutableArray alloc] initWithCapacity:0];
  }
  return self;
}

- (void)setCinema:(CinemaDetail *)cinema {
  if (cinema) {
    _cinema = cinema;

    //影院收藏的标示
    self.cinemaCollectIconFrame =
        CGRectMake(screentWith - collectionIconWidth, 0, collectionIconWidth,
                   collectionIconHeight);
    self.cinemaNameFrame =
        CGRectMake(marginLeft, marginTop,
                   screentWith - marginLeft - 80, nameHeight);

    //影院距离
    NSString *distanceStr;

    float kiloMeter = [_cinema.distanceMetres floatValue] / 1000.0;

    if (([CLLocationManager authorizationStatus] ==
         kCLAuthorizationStatusDenied) ||
        [_cinema.distanceMetres floatValue] == 99999999999) {

    } else {
      if (kiloMeter < 1) {
        distanceStr = [NSString
            stringWithFormat:@"%.1fm", [_cinema.distanceMetres floatValue]];
      } else {
        distanceStr = [NSString stringWithFormat:@"%.1fkm", kiloMeter];
      }
    }

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:distanceFontY];
    attributes[NSForegroundColorAttributeName] = appDelegate.kkzBlue;
    CGSize s = [distanceStr sizeWithAttributes:attributes];

    self.cinemaDistanceFrame =
        CGRectMake(screentWith - s.width - marginRight,
                   CGRectGetMaxY(self.cinemaNameFrame) + marginNameToAdd,
                   s.width, distanceHeight);

    //影院地址
    self.cinemaAddressFrame = CGRectMake(
        marginLeft, CGRectGetMaxY(self.cinemaNameFrame) + marginNameToAdd,
        CGRectGetMinX(self.cinemaDistanceFrame) - marginAddToDistance -
            marginLeft,
        addressHeight);

    //影院特色信息
    self.flagLengthT = marginLeft;

    if (self.flags.count > 0) {
      [self.flags removeAllObjects];
    }

    if (_cinema.platformType == PlatFormTicket) { // 在线选座
//      [self.flags insertObject:@"座" atIndex:0];
    }

    if (_cinema.flag.length > 0) {

      NSArray *arr = [_cinema.flag componentsSeparatedByString:@","];
      [self.flags addObjectsFromArray:arr];
    }

    //影院活动标题
    if (_cinema.shortTitle.length) {

      attributes[NSFontAttributeName] =
          [UIFont systemFontOfSize:self.activityFont];
      attributes[NSForegroundColorAttributeName] = kUIColorOrange;
      CGSize s = [_cinema.shortTitle sizeWithAttributes:attributes];

      self.activityTitleFrame =
          CGRectMake(self.flagLengthT + marginIconToIcon,
                     CGRectGetMaxY(self.cinemaAddressFrame) + marginAddToIcons,
                     s.width + 12, iconHeight);

      self.flagLengthT = CGRectGetMaxX(self.activityTitleFrame);
    }

    //影院最低票价
    if (_cinema.minPrice && [_cinema.minPrice floatValue] > 0) {

      self.minPrice = [NSString
          stringWithFormat:@"￥%.2f起", [_cinema.minPrice floatValue]];

      attributes[NSFontAttributeName] =
          [UIFont systemFontOfSize:self.minPriceFont];
      attributes[NSForegroundColorAttributeName] = kUIColorOrange;
      CGSize s = [self.minPrice sizeWithAttributes:attributes];

      self.minPriceFrame = CGRectMake(kAppScreenWidth - s.width - 14, 20, s.width + 12, iconHeight);
    }

    //影院cell的高度
    self.height = CGRectGetMaxY(self.cinemaAddressFrame) + marginAddToIcons +
                  iconHeight + marginBottom;
  }
}


@end
