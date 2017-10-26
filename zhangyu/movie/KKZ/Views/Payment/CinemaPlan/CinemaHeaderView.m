//
//  排期列表页面的Header View
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaHeaderView.h"

#import "CinemaActivityDetailView.h"
#import "CinemaTitleHeader.h"
#import "KKZUtility.h"
#import "SwitchMovieView.h"
#import "UIColor+Hex.h"
#import "CinemaDetail.h"

typedef enum : NSUInteger {
  moreButtonTag,
} viewButtonTag;

#define maxActivityCount 2


/****************影院影片*************/
static const CGFloat cinemaMovieHeight = 220.0f;

/****************分割线*************/
static const CGFloat lineViewHeight = 0.3f;

@interface CinemaHeaderView () <CinemaTitleHeaderDelegate>

/**
 *  影院标题视图
 */
@property(nonatomic, strong) CinemaTitleHeader *cinemaTitleHeader;

/**
 *  影院电影视图
 */
@property(nonatomic, strong) CinemaMovieView *cinemaMovieView;

/**
 *  电影活动详情视图
 */
@property(nonatomic, strong) CinemaActivityDetailView *cinemaActivityDetailView;

/**
 *  分割线视图
 */
@property(nonatomic, strong) UIView *lineView;

@end

@implementation CinemaHeaderView

- (void)didMoveToSuperview {
  [self addSubview:self.cinemaTitleHeader];
  [self updateCurrenViewLayout:CGRectGetMaxY(self.cinemaTitleHeader.frame)];
}

- (void)updateActivityViewData {

  if (self.cinemaDetail.cinemaName) {
    self.cinemaTitleHeader.cinemaName = self.cinemaDetail.cinemaName;
  }
  if (self.cinemaDetail.cinemaAddress) {
    self.cinemaTitleHeader.cinemaAddress = self.cinemaDetail.cinemaAddress;
  }

}


- (void)updateCinemaViewData {
  self.cinemaMovieView.movieId = self.movieId;
  self.cinemaMovieView.movieList = self.movieList;
  [self.cinemaMovieView updateLayout];
  [self addSubview:self.cinemaMovieView];
  [self updateCinemaViewLayout];
}

- (void)updateCinemaLabelsData {
  NSMutableArray *listArr = [[NSMutableArray alloc] init];
  for (int i = 0; i < _specilaInfoList.count; i++) {
    NSString *str = _specilaInfoList[i];
    if (str.length > 0) {
      [listArr addObject:str];
    }
  }
  self.cinemaTitleHeader.labelArray = listArr;
}

- (void)updateCinemaViewLayout {
  if (self.movieList.count == 0) {
    return;
  }
    
  [self addSubview:self.cinemaMovieView];
  CGRect frame = self.cinemaMovieView.frame;
  frame.origin.y = CGRectGetMaxY(self.cinemaTitleHeader.frame) - 1;
  self.cinemaMovieView.frame = frame;

  //更新当前视图尺寸
  [self updateCurrenViewLayout:CGRectGetMaxY(self.cinemaMovieView.frame)];
}

- (void)updateCurrenViewLayout:(CGFloat)height {

  //修改当前表头视图尺寸
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;

  //修改表头上的分割线
  CGRect lineFrame = self.lineView.frame;
  lineFrame.origin.y = CGRectGetMaxY(self.frame) - lineViewHeight;
  self.lineView.frame = lineFrame;
  [self addSubview:self.lineView];

  //通知代理对象当前视图尺寸改变
  if (self.delegate &&
      [self.delegate respondsToSelector:@selector(cinemHeaderHeightChanged:)]) {
    [self.delegate cinemHeaderHeightChanged:CGRectGetHeight(self.frame)];
  }
}
#pragma mark - delegate Method
- (void)cinemaTitleHeaderChangeHeight:(CGFloat)viewHight {
    [self updateCinemaViewLayout];
}


- (void)didSelectCinemaTitleHeaderView {
  //通知代理对象当前视图尺寸改变
  if (self.delegate &&
      [self.delegate
          respondsToSelector:@selector(didSelectCinemaTitleHeaderView)]) {
    [self.delegate didSelectCinemaTitleHeaderView];
  }
}

#pragma mark - setter Method

- (void)setCinemaDetail:(CinemaDetail *)cinemaDetail {
  _cinemaDetail = cinemaDetail;
  [self updateActivityViewData];
}

- (void)setMovieList:(NSArray *)movieList {
  _movieList = movieList;
  [self updateCinemaViewData];
}

- (void)setSpecilaInfoList:(NSArray *)specilaInfoList {
  _specilaInfoList = specilaInfoList;
  [self updateCinemaLabelsData];
}

- (void)setCinemaName:(NSString *)cinemaName {
  _cinemaName = cinemaName;
  self.cinemaTitleHeader.cinemaName = _cinemaName;
}

- (void)setCinemaAddress:(NSString *)cinemaAddress {
  _cinemaAddress = cinemaAddress;
  self.cinemaTitleHeader.cinemaAddress = cinemaAddress;
}

#pragma mark - getter Method
- (CinemaTitleHeader *)cinemaTitleHeader {
  if (!_cinemaTitleHeader) {
    _cinemaTitleHeader = [[CinemaTitleHeader alloc]
        initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    _cinemaTitleHeader.backgroundColor = [UIColor clearColor];
    _cinemaTitleHeader.delegate = self;
  }
  return _cinemaTitleHeader;
}

- (CinemaMovieView *)cinemaMovieView {
  if (!_cinemaMovieView) {
    _cinemaMovieView = [[CinemaMovieView alloc]
        initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, cinemaMovieHeight)];
    _cinemaMovieView.backgroundColor = [UIColor whiteColor];
    _cinemaMovieView.delegate = self.delegate;
  }
  return _cinemaMovieView;
}

- (CinemaActivityDetailView *)cinemaActivityDetailView {
  if (!_cinemaActivityDetailView) {
    _cinemaActivityDetailView =
        [[CinemaActivityDetailView alloc] initWithFrame:kCommonScreenBounds];
    _cinemaActivityDetailView.backgroundColor =
        [[UIColor blackColor] colorWithAlphaComponent:0.5];
  }
  return _cinemaActivityDetailView;
}

- (UIView *)lineView {
  if (!_lineView) {
    _lineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, lineViewHeight)];
    _lineView.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
  }
  return _lineView;
}


@end
