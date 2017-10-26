//
//  影院详情页面的HeaderView
//
//  Created by 艾广华 on 16/4/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaDetailHeaderView.h"

#import "KKZUtility.h"
#import "RatingView.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"

/****************影院名称********************/
const static CGFloat cinemaTitleLeft = 15.0f;
const static CGFloat cinemaTitleTop = 26.0f;
const static CGFloat cinemaTitleHeight = 20.0f;

/****************影院评分********************/
const static CGFloat rateViewTop = 7.0f;
const static CGFloat rateViewWidth = 150.0f;
const static CGFloat rateLabelWidth = 20.0f;
const static CGFloat rateLabelLeft = 110.0f;
const static CGFloat rateViewHeight = 30.0f;

/****************影院介绍********************/
static const CGFloat cinemaIntroLabelDefault = 63.0f;
static const CGFloat cinemaIntroLabelTop = 17.0f;
static const CGFloat cinemaIntroLabelLeft = 16.0f;
static const CGFloat cinemaIntroLabelBottom = 15.0f;
static const CGFloat cinemaIntroArrowBottom = 10.0f;

/***************定位视图和打电话视图******************/
const static CGFloat locationTop = 76.0f;
const static CGFloat cinemaInfoTop = 10.0f;

/****************分割线********************/
static const NSUInteger kListViewDivideOriginMax = 67;

typedef enum : NSUInteger {
  phoneButtonTag = 1000,
  locationButtonTag,
  phoneIconTag,
  phoneArrowTag,
  phoneLabelTag,
  showMoreCinemaIntroTag,
} allButtonTag;

@interface CinemaDetailHeaderView ()

/**
 *  影院名称
 */
@property(nonatomic, strong) UILabel *cinemaTitleLabel;

/**
 *  评分视图
 */
@property(nonatomic, strong) RatingView *rateView;

/**
 *  评分分数标签
 */
@property(nonatomic, strong) UILabel *rateScore1Label;

/**
 *  评分分数
 */
@property(nonatomic, strong) UILabel *rateScore2Label;

/**
 *  影院介绍视图
 */
@property(nonatomic, strong) UIButton *cinemaIntroView;

/**
 *  影院介绍标签
 */
@property(nonatomic, strong) UILabel *cinemaIntroLabel;

/**
 *  影院介绍箭头
 */
@property(nonatomic, strong) UIImageView *cinemaIntroArrow;

/**
 *  当前视图的y坐标
 */
@property(nonatomic, assign) CGFloat currentPointY;

/**
 *  影院信息是否显示箭头
 */
@property(nonatomic, assign) BOOL cinemaArrowShow;

/**
 *  当前是否正在展示更多的影院详情
 */
@property(nonatomic, assign) BOOL cinemaIntroIsShowMore;

/**
 *  存放已经显示过的视图
 */
@property(nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation CinemaDetailHeaderView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self addSubview:self.cinemaTitleLabel];
    [self addSubview:self.rateView];
    [self addSubview:self.rateScore1Label];
    [self addSubview:self.rateScore2Label];
    [self setCurrentViewFrameWithHeight:CGRectGetMaxY(self.rateView.frame)];
  }
  return self;
}

- (void)setCinemaName:(NSString *)cinemaName {
  _cinemaName = cinemaName;
  self.cinemaTitleLabel.text = _cinemaName;
}

- (void)updateCinemaDisplay {
  //设置影院评分
  [self setTextAttributeScore:self.point];

  //设置分数图标
  [self.rateView displayRating:self.point * 0.5];

  //设置电话和定位视图
  [self updateLocationAndPhoneView];
}

- (void)setCurrentViewFrameWithHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height + 10.0f;
  self.frame = frame;

  //代理对象执行
  if (self.delegate &&
      [self.delegate
          respondsToSelector:@selector(cinemaDetailHeaderHeightChange)]) {
    [self.delegate cinemaDetailHeaderHeightChange];
  }
}

- (void)updateLocationAndPhoneView {

  //电话和定位视图
  NSArray *imageArray = @[ @"cinemaDetail_phone", @"cinemaDetail_location" ];
  NSArray *isDrawArr = @[ @TRUE, @FALSE ];
  if (!self.cinemaTel) {
    self.cinemaTel = @"--";
  }
  if (!self.cinemaAddress) {
    self.cinemaAddress = @"--";
  }
  NSArray *titleArray = @[ self.cinemaTel, self.cinemaAddress ];
  self.currentPointY = locationTop;
  if (self.viewArray.count == 0) {
    for (int i = 0; i < imageArray.count; i++) {
      UIButton *addView =
          [self addSettingLayout:titleArray[i]
                            icon:[UIImage imageNamed:imageArray[i]]
                       positionY:self.currentPointY
                          action:@selector(commonBtnClick:)
                         withTag:phoneButtonTag + i
                isDrawBottomLine:[isDrawArr[i] boolValue]];

      [self addSubview:addView];
      self.currentPointY += addView.frame.size.height;
      [self.viewArray addObject:addView];
    }
  } else {
    for (int i = 0; i < self.viewArray.count; i++) {
      UIView *addView = self.viewArray[i];
      [self changeFrameWithLabel:[addView viewWithTag:phoneLabelTag]
                        withText:titleArray[i]
                        withIcon:[addView viewWithTag:phoneIconTag]
                       withArrow:[addView viewWithTag:phoneArrowTag]
                        withView:addView];
      self.currentPointY += addView.frame.size.height;
    }
  }

  //影院详情视图
  if (self.cinemaIntro && self.cinemaIntro.length) {
    self.cinemaIntroIsShowMore = FALSE;
    [self updateCinemaIntroLayout];
  } else {
    [self setCurrentViewFrameWithHeight:self.currentPointY];
  }
}

- (void)updateCinemaIntroLayout {

  //修改影院介绍的尺寸
  self.cinemaIntroLabel.text = self.cinemaIntro;
  CGRect cinemaFrame = self.cinemaIntroLabel.frame;
  CGSize textSize = [KKZUtility
      customTextSize:self.cinemaIntroLabel.font
                text:self.cinemaIntroLabel.text
                size:CGSizeMake(self.cinemaIntroLabel.frame.size.width,
                                CGFLOAT_MAX)];
  //如果需要显示更多文字
  if (self.cinemaIntroIsShowMore) {

    //将计算好的整个文本的高度赋值
    cinemaFrame.size.height = textSize.height;

    //需要显示箭头
    self.cinemaArrowShow = TRUE;

  } else {
    if (textSize.height > cinemaIntroLabelDefault) {

      //如果不需要显示更多文字则显示默认最大高度
      cinemaFrame.size.height = cinemaIntroLabelDefault;

      //需要显示箭头
      self.cinemaArrowShow = TRUE;

    } else {

      //如果文本小于默认文字高度则全部显示
      cinemaFrame.size.height = textSize.height;

      //不需要显示箭头
      self.cinemaArrowShow = FALSE;
    }
  }
  self.cinemaIntroLabel.frame = cinemaFrame;

  //修改展开箭头
  if (self.cinemaArrowShow) {

    //影院介绍展开箭头
    CGRect arrowRect = self.cinemaIntroArrow.frame;
    arrowRect.origin.y = CGRectGetMaxY(cinemaFrame) + cinemaIntroLabelBottom;
    self.cinemaIntroArrow.frame = arrowRect;

    //修改影院介绍背景视图
    CGRect introRect = self.cinemaIntroView.frame;
    introRect.size.height = CGRectGetMaxY(arrowRect) + cinemaIntroArrowBottom;
    self.cinemaIntroView.frame = introRect;

  } else {

    //修改影院介绍背景视图
    CGRect introRect = self.cinemaIntroView.frame;
    introRect.size.height = CGRectGetMaxY(cinemaFrame) + cinemaIntroLabelBottom;
    self.cinemaIntroView.frame = introRect;
  }
  [self addSubview:self.cinemaIntroView];
  [self
      setCurrentViewFrameWithHeight:CGRectGetMaxY(self.cinemaIntroView.frame)];
}

- (UIButton *)addSettingLayout:(NSString *)title
                          icon:(UIImage *)icon
                     positionY:(CGFloat)y
                        action:(SEL)selector
                       withTag:(NSInteger)buttonTag
              isDrawBottomLine:(BOOL)isDrawBottom {

  //背景视图
  CGFloat titleLabelOriginY = 18.0f;
  CGFloat titleLabelLeft = 19.0f;

  UIButton *settingLayout =
      [[UIButton alloc] initWithFrame:CGRectMake(0, y, screentWith, 50)];
  settingLayout.backgroundColor = [UIColor whiteColor];
  settingLayout.tag = buttonTag;
  [settingLayout addTarget:self
                    action:selector
          forControlEvents:UIControlEventTouchUpInside];

  UIImageView *ivIcon = [[UIImageView alloc]
      initWithFrame:CGRectMake(15, 10, icon.size.width, icon.size.height)];
  ivIcon.image = icon;
  ivIcon.tag = phoneIconTag;
  [settingLayout addSubview:ivIcon];

  CGFloat arrowRight = 14.0f;
  UIImage *arrowImg = [UIImage imageNamed:@"arrowRightGray"];
  UIImageView *arrow = [[UIImageView alloc]
      initWithFrame:CGRectMake(screentWith - arrowImg.size.width - arrowRight,
                               16, arrowImg.size.width, 18)];
  arrow.tag = phoneArrowTag;
  arrow.image = arrowImg;
  [settingLayout addSubview:arrow];

  CGFloat titleLabelOriginX = titleLabelLeft + CGRectGetMaxX(ivIcon.frame);
  UILabel *titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(titleLabelOriginX, titleLabelOriginY,
                               settingLayout.frame.size.width -
                                   titleLabelOriginX - arrowRight -
                                   arrowImg.size.width - 35.0f,
                               30)];
  titleLabel.text = title;
  titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.tag = phoneLabelTag;
  titleLabel.numberOfLines = 0;
  titleLabel.font = [UIFont systemFontOfSize:15.0f];
  [settingLayout addSubview:titleLabel];

  //修改视图尺寸
  [self changeFrameWithLabel:titleLabel
                    withText:title
                    withIcon:ivIcon
                   withArrow:arrow
                    withView:settingLayout];

  //底部分割线
  if (isDrawBottom) {
    [settingLayout
        addSubview:[self drawLineWithOriginX:kListViewDivideOriginMax
                                 withOriginY:settingLayout.frame.size.height -
                                             1]];
  }
  return settingLayout;
}

- (void)changeFrameWithLabel:(UILabel *)titleLabel
                    withText:(NSString *)title
                    withIcon:(UIImageView *)ivIcon
                   withArrow:(UIImageView *)arrow
                    withView:(UIView *)settingLayout {
  CGSize textSize = [KKZUtility
      customTextSize:titleLabel.font
                text:title
                size:CGSizeMake(titleLabel.frame.size.width, CGFLOAT_MAX)];
  //设置地址尺寸
  CGRect titltRect = titleLabel.frame;
  titltRect.size.height = textSize.height;
  titleLabel.frame = titltRect;

  //设置视图尺寸
  CGRect layoutRect = settingLayout.frame;
  layoutRect.size.height =
      titltRect.size.height + titleLabel.frame.origin.y * 2;
  settingLayout.frame = layoutRect;

  //设置icon位置
  ivIcon.center =
      CGPointMake(ivIcon.center.x, settingLayout.frame.size.height / 2.0f);

  //设置箭头位置
  arrow.center =
      CGPointMake(arrow.center.x, settingLayout.frame.size.height / 2.0f);
}

- (UIView *)drawLineWithOriginX:(CGFloat)originX withOriginY:(CGFloat)originY {
  UIView *bottomDivider = [[UIView alloc]
      initWithFrame:CGRectMake(originX, originY, screentWith - originX,
                               kDimensDividerHeight)];
  bottomDivider.backgroundColor = kUIColorDivider;
  return bottomDivider;
}

- (void)setTextAttributeScore:(CGFloat)score {

  //计算的分数
  NSString *originStr = [NSString stringWithFormat:@"%.1f\n", score];
  NSArray *array = [originStr componentsSeparatedByString:@"."];
  if (array.count >= 2) {

    //计算十位
    NSString *ten = [NSString stringWithFormat:@"%@.", array[0]];
    self.rateScore1Label.text = ten;

    //计算十位的数字的尺寸
    CGSize tenSize = [KKZUtility
        customTextSize:self.rateScore1Label.font
                  text:self.rateScore1Label.text
                  size:CGSizeMake(100, self.rateScore1Label.frame.size.height)];
    CGRect rate1Frame = self.rateScore1Label.frame;
    rate1Frame.size.width = tenSize.width;
    rate1Frame.size.height = self.rateScore1Label.frame.size.height;
    self.rateScore1Label.frame = rate1Frame;

    //计算个位
    NSString *unit = array[1];
    self.rateScore2Label.text = unit;

    //计算个位数字的尺寸
    CGSize unitSize = [KKZUtility
        customTextSize:self.rateScore2Label.font
                  text:self.rateScore2Label.text
                  size:CGSizeMake(100, self.rateScore2Label.frame.size.height)];
    CGRect rate2Frame = self.rateScore2Label.frame;
    rate2Frame.size.width = unitSize.width;
    rate2Frame.size.height = self.rateScore2Label.frame.size.height;
    rate2Frame.origin.x = CGRectGetMaxX(rate1Frame) + 2;
    self.rateScore2Label.frame = rate2Frame;
  }
}

- (void)setCinemaArrowShow:(BOOL)cinemaArrowShow {
  _cinemaArrowShow = cinemaArrowShow;
  if (_cinemaArrowShow) {
    self.cinemaIntroArrow.hidden = FALSE;
  } else {
    self.cinemaIntroArrow.hidden = YES;
  }
}

- (UILabel *)cinemaTitleLabel {
  if (!_cinemaTitleLabel) {
    _cinemaTitleLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(cinemaTitleLeft, cinemaTitleTop,
                                 kCommonScreenWidth - cinemaTitleLeft * 2,
                                 cinemaTitleHeight)];
    _cinemaTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    _cinemaTitleLabel.textColor = [UIColor whiteColor];
    _cinemaTitleLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _cinemaTitleLabel;
}

- (UILabel *)rateScore1Label {
  if (!_rateScore1Label) {
    CGFloat rateLabelOriginY =
        cinemaTitleHeight + cinemaTitleTop + rateViewTop - 2;
    _rateScore1Label = [[UILabel alloc]
        initWithFrame:CGRectMake(rateLabelLeft, rateLabelOriginY,
                                 rateLabelWidth, 20)];
    _rateScore1Label.font = [UIFont boldSystemFontOfSize:22.0f];
    _rateScore1Label.textColor = [UIColor colorWithHex:@"#f9c452"];
    _rateScore1Label.backgroundColor = [UIColor clearColor];
    _rateScore1Label.textAlignment = NSTextAlignmentLeft;
  }
  return _rateScore1Label;
}

- (UILabel *)rateScore2Label {
  if (!_rateScore2Label) {
    CGFloat rateLabelOriginY =
        cinemaTitleHeight + cinemaTitleTop + rateViewTop - 2;
    _rateScore2Label = [[UILabel alloc]
        initWithFrame:CGRectMake(rateLabelLeft + rateLabelWidth + 2,
                                 rateLabelOriginY, 9, 18)];
    _rateScore2Label.font = [UIFont boldSystemFontOfSize:15.0f];
    _rateScore2Label.textColor = [UIColor colorWithHex:@"#f9c452"];
    _rateScore2Label.backgroundColor = [UIColor blackColor];
    _rateScore2Label.textAlignment = NSTextAlignmentLeft;
  }
  return _rateScore2Label;
}

- (RatingView *)rateView {
  if (!_rateView) {
    _rateView = [[RatingView alloc]
        initWithFrame:CGRectMake(cinemaTitleLeft,
                                 cinemaTitleHeight + cinemaTitleTop +
                                     rateViewTop,
                                 rateViewWidth, rateViewHeight)];
    [_rateView setImagesDeselected:@"scoreUnstar"
                    partlySelected:@"scoreHalfstar"
                      fullSelected:@"scoreStar"
                          iconSize:CGSizeMake(14, 14)
                       marginWidth:4
                       andDelegate:nil];
    _rateView.userInteractionEnabled = NO;
  }
  return _rateView;
}

- (UIButton *)cinemaIntroView {
  if (!_cinemaIntroView) {
    //影院介绍视图
    _cinemaIntroView = [UIButton buttonWithType:0];
    _cinemaIntroView.frame = CGRectMake(0, self.currentPointY + cinemaInfoTop,
                                        kCommonScreenWidth, 0);
    _cinemaIntroView.backgroundColor = [UIColor whiteColor];
    _cinemaIntroView.tag = showMoreCinemaIntroTag;
    [_cinemaIntroView addTarget:self
                         action:@selector(commonBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];

    //添加影院介绍标签
    [_cinemaIntroView addSubview:self.cinemaIntroLabel];

    //添加箭头
    [_cinemaIntroView addSubview:self.cinemaIntroArrow];
  }
  return _cinemaIntroView;
}

- (UILabel *)cinemaIntroLabel {
  if (!_cinemaIntroLabel) {
    _cinemaIntroLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(cinemaIntroLabelLeft, cinemaIntroLabelTop,
                                 kCommonScreenWidth - cinemaIntroLabelLeft * 2,
                                 10)];
    _cinemaIntroLabel.backgroundColor = [UIColor clearColor];
    _cinemaIntroLabel.font = [UIFont systemFontOfSize:13.0f];
    _cinemaIntroLabel.numberOfLines = 0;
    _cinemaIntroLabel.textColor = [UIColor colorWithHex:@"#333333"];
    _cinemaIntroLabel.lineBreakMode = NSLineBreakByCharWrapping;
  }
  return _cinemaIntroLabel;
}

- (UIImageView *)cinemaIntroArrow {
  if (!_cinemaIntroArrow) {
    UIImage *arrowImg = [UIImage imageNamed:@"cinemaDetail_arrow"];
    _cinemaIntroArrow = [[UIImageView alloc]
        initWithFrame:CGRectMake(kCommonScreenWidth / 2.0f -
                                     arrowImg.size.width / 2.0f,
                                 0, arrowImg.size.width, arrowImg.size.height)];
    _cinemaIntroArrow.image = arrowImg;
  }
  return _cinemaIntroArrow;
}

- (NSMutableArray *)viewArray {
  if (!_viewArray) {
    _viewArray = [[NSMutableArray alloc] init];
  }
  return _viewArray;
}

- (void)commonBtnClick:(UIButton *)sender {
  switch (sender.tag) {
  case showMoreCinemaIntroTag: {
    if (self.cinemaArrowShow) {
      if (self.cinemaIntroIsShowMore) {
        self.cinemaIntroArrow.transform = CGAffineTransformMakeRotation(0);
      } else {
        self.cinemaIntroArrow.transform = CGAffineTransformMakeRotation(M_PI);
      }
      self.cinemaIntroIsShowMore = !self.cinemaIntroIsShowMore;
      [self updateCinemaIntroLayout];
    }
    break;
  }
  case phoneButtonTag: {
    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(didSelectCallPhoneButton)]) {
      [self.delegate didSelectCallPhoneButton];
    }
    break;
  }
  case locationButtonTag: {
    if (self.delegate &&
        [self.delegate
            respondsToSelector:@selector(didSelectCallLocationButton)]) {
      [self.delegate didSelectCallLocationButton];
    }
    break;
  }
  default:
    break;
  }
}

@end
