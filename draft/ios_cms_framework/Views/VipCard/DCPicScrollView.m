////
////  DCPicScrollView.m
////  DCPicScrollView
////
////  Created by dengchen on 15/12/4.
////  Copyright © 2015年 name. All rights reserved.
////
//
//#define myWidth self.frame.size.width
//#define myHeight self.frame.size.height
////#define pageSize (myHeight * 0.2 > 25 ? 25 : myHeight * 0.2)
//#define pageSize 18
//
//#import "DCPicScrollView.h"
//#import "DCWebImageManager.h"
//#import "KKZTextUtility.h"
//#import "VipCard.h"
//#import "CIASAlertCancleView.h"
//#import "VipCardRequest.h"
//#import "DataEngine.h"
//
//@interface DCPicScrollView () <UIScrollViewDelegate>
//{
//     UIView           *cardCenterView,*cardLeftView,*cardRightView;
//     UIImageView    *backImageView;
//     UILabel *cardTitleLabel,*cardValueLabel,*cardTypeLabel,*cardBalanceValueLabel,*cardValidTimeLabel;
//     UIImageView *cardImageView,*cardLogoImageView;
//}
//@property (nonatomic,strong) NSMutableDictionary *imageData;
//
//@property (nonatomic,strong) NSArray *imageUrlStrings;
//
//@end
//
//
//
//@implementation DCPicScrollView{
//    
//    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
//    
//    __weak  UILabel *_titleLabel;
//    
//    __weak  UIScrollView *_scrollView;
//    
//    __weak  UIPageControl *_PageControl;
//    
//    NSTimer *_timer;
//    
//    NSInteger _currentIndex;
//    
//    NSInteger _MaxImageCount;
//    
//    BOOL _isNetwork;
//    
//    BOOL _hasTitle;
//}
//
//
//- (void)setMaxImageCount:(NSInteger)MaxImageCount {
//    _MaxImageCount = MaxImageCount;
//    
//    [self prepareImageView];
//    [self preparePageControl];
//    
//    [self setUpTimer];
//    
//    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
//}
//
//
//- (void)imageViewDidTap {
//    if (self.imageViewDidTapAtIndex != nil) {
//        self.imageViewDidTapAtIndex(_currentIndex);
//    }
//}
//
//+ (instancetype)picScrollViewWithFrame:(CGRect)frame WithImageUrls:(NSArray<NSString *> *)imageUrl {
//    return  [[DCPicScrollView alloc] initWithFrame:frame WithImageNames:imageUrl withIsFill:NO];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame WithImageNames:(NSArray<NSString *> *)ImageName withIsFill:(BOOL)isFill {
//    self.isFill = isFill;
//    if (ImageName.count < 1) {
//        return nil;
//    }
//
//    self = [super initWithFrame:frame];
//    if(ImageName.count == 1) {
//        VipCard *vipcard = (VipCard *)[ImageName objectAtIndex:0];
//        
//        cardCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 251*Constants.screenHeightRate)];
//        cardCenterView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
//        
//        
//        //卡图片
//        UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
//        cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2, 25*Constants.screenHeightRate, cardImage.size.width*Constants.screenWidthRate, cardImage.size.height*Constants.screenHeightRate)];
//        cardImageView.image = cardImage;
//        cardImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [cardCenterView addSubview:cardImageView];
//        
//        //卡背景图
//        UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
//        cardBackImageViewOfTop = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - cardBackImage.size.width*Constants.screenWidthRate)/2, 10*Constants.screenHeightRate, cardBackImage.size.width*Constants.screenWidthRate, cardBackImage.size.height*Constants.screenHeightRate)];
//        cardBackImageViewOfTop.image = cardBackImage;
//        cardBackImageViewOfTop.contentMode = UIViewContentModeScaleAspectFit;
//        [cardCenterView addSubview:cardBackImageViewOfTop];
//        
//        //卡图片上的logo
//        UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
//        cardLogoImageView = [[UIImageView alloc] init];
//        [cardImageView addSubview:cardLogoImageView];
//        [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
//            make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
//        }];
//        cardLogoImageView.image = cardLogoImage;
//        cardLogoImageView.hidden = NO;
//        
//        NSString *cardTypeStr = vipcard.useTypeName;
//        CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
//        cardTypeLabel = [[UILabel alloc] init];
//        [cardImageView addSubview:cardTypeLabel];
//        cardTypeLabel.text = cardTypeStr;
//        cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
//        cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
//        [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
//            make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
//        }];
//        cardTypeLabel.hidden = NO;
//        //
//        //卡图片上的卡号
//        NSString *cardTitleStr = @"卡号";
//        CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
//        cardTitleLabel = [[UILabel alloc] init];
//        [cardImageView addSubview:cardTitleLabel];
//        cardTitleLabel.text = cardTitleStr;
//        cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
//        cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
//        [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
//            make.top.equalTo(cardLogoImageView.mas_bottom).offset(32*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
//        }];
//        cardTitleLabel.hidden = NO;
//        
//        NSString *cardValueStr = vipcard.cardNo;
//        CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
//        cardValueLabel = [[UILabel alloc] init];
//        [cardImageView addSubview:cardValueLabel];
//        cardValueLabel.text = cardValueStr;
//        cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
//        cardValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
//        [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
//            make.top.equalTo(cardTitleLabel.mas_bottom).offset(10*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake((cardImage.size.width - 35)*Constants.screenWidthRate, cardValueStrSize.height));
//        }];
//        cardValueLabel.hidden = NO;
//        
//        NSString *cardBalanceValueStr = @"余额：10050.00元";
//        CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
//        cardBalanceValueLabel = [[UILabel alloc] init];
//        [cardImageView addSubview:cardBalanceValueLabel];
//        //MARK: 如果没有余额则隐藏
//        cardBalanceValueLabel.hidden = YES;
//        cardBalanceValueLabel.attributedText = [self getbalanceStrWithString:cardBalanceValueStr];
//        [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
//            make.top.equalTo(cardValueLabel.mas_bottom).offset(28*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
//        }];
//        cardBalanceValueLabel.hidden = YES;
//        
//        NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
//        CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
//        cardValidTimeLabel = [[UILabel alloc] init];
//        [cardImageView addSubview:cardValidTimeLabel];
//        //MARK: 如果没有有效期则隐藏
//        cardValidTimeLabel.hidden = YES;
//        cardValidTimeLabel.text = cardValidTimeStr;
//        cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
//        cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
//        cardValidTimeLabel.font = [UIFont systemFontOfSize:10];
//        [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(cardImageView.mas_right).offset(-25*Constants.screenWidthRate);
//            make.bottom.equalTo(cardImageView.mas_bottom).offset(-23*Constants.screenHeightRate);
//            make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
//        }];
//        
//        [self addSubview:cardCenterView];
//        
//        _isNetwork = vipcard.cardNo.length > 0 ? YES:NO;
//        
//        if (_isNetwork) {
//            if ([self.delegate respondsToSelector:@selector(getChargeMoneyValuesWith:andCinemaId:)]) {
//                [self.delegate getChargeMoneyValuesWith:vipcard.cardNo andCinemaId:[NSString stringWithFormat:@"%d", vipcard.cinemaId.intValue]];
//            }
//        } else {
//            __weak __typeof(self) weakSelf = self;
//            [[CIASAlertCancleView new] show:@"温馨提示" message:@"会员卡异常" cancleTitle:@"知道了" callback:^(BOOL confirm) {
//                if (!confirm) {
//                    if ([weakSelf.delegate respondsToSelector:@selector(backToRootViewController)]) {
//                        [weakSelf.delegate backToRootViewController];
//                    }
//                }
//            }];
//        }
//        
//        return self;
//    }
//    
//    [self prepareScrollView];
//    [self setImageUrlStrings:ImageName];
//    [self setMaxImageCount:self.imageUrlStrings.count];
//    
//    return self;
//}
//
//
//- (void)prepareScrollView {
//    
//    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.bounds];
//    [self addSubview:sc];
//    
//    _scrollView = sc;
//    _scrollView.backgroundColor = [UIColor clearColor];
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    
//    _scrollView.contentSize = CGSizeMake(myWidth * 3,0);
//    
//    _AutoScrollDelay = 2.0f;
//    _currentIndex = 0;
//}
//
//- (void)prepareImageView {
//    
//    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,myWidth, myHeight)];
//    UIImageView *center = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth, 0,myWidth, myHeight)];
//    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth * 2, 0,myWidth, myHeight)];
//    
//    center.userInteractionEnabled = YES;
//    [center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
//    if (self.isFill == YES) {
//        left.contentMode = UIViewContentModeScaleAspectFill;
//        center.contentMode = UIViewContentModeScaleAspectFill;
//        right.contentMode = UIViewContentModeScaleAspectFill;
//        left.clipsToBounds = YES;
//        center.clipsToBounds = YES;
//        right.clipsToBounds = YES;
//    }
//   
//
//    [_scrollView addSubview:left];
//    [_scrollView addSubview:center];
//    [_scrollView addSubview:right];
//    
//    _leftImageView = left;
//    _centerImageView = center;
//    _rightImageView = right;
//    
//}
//
//- (void)preparePageControl {
//    
//    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,myHeight - pageSize,myWidth, 7)];
//    
//    page.pageIndicatorTintColor = [UIColor lightGrayColor];
//    page.currentPageIndicatorTintColor =  [UIColor whiteColor];
//    page.numberOfPages = _MaxImageCount;
//    page.currentPage = 0;
//    
//    [self addSubview:page];
//    
//    
//    _PageControl = page;
//}
//
//- (void)setStyle:(PageControlStyle)style {
//    CGFloat w = _MaxImageCount * 17.5;
//    _PageControl.frame = CGRectMake(0, 0, w, 7);
//    
//    if (style == PageControlAtRight || _hasTitle) {
//        _PageControl.center = CGPointMake(myWidth-w*0.5, myHeight-pageSize * 0.5);
//    }else if(style == PageControlAtCenter) {
//        _PageControl.center = CGPointMake(myWidth * 0.5,myHeight-pageSize * 0.5);
//    }
//}
//
//- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
//    _PageControl.pageIndicatorTintColor = pageIndicatorTintColor;
//}
//
//- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
//    _PageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
//}
//
//
//- (void)setTitleData:(NSArray<NSString *> *)titleData {
//    if (titleData.count < 1)  return;
//    
//    if (titleData.count == 1) {
//        _titleLabel.text = titleData.firstObject;
//        return;
//    }
//    
//    if (titleData.count < _imageData.count) {
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:titleData];
//        for (int i = 0; i < _imageData.count - titleData.count; i++) {
//            [temp addObject:@""];
//        }
//        _titleData = temp;
//    }else {
//        
//        _titleData = titleData;
//    }
//    
//    [self prepareTitleLabel];
//    _hasTitle = YES;
//    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
//}
//
//
//- (void)prepareTitleLabel {
//    
//    [self setStyle:PageControlAtRight];
//    
//    UIView *titleView = [self creatLabelBgView];
//    
//    _titleLabel = (UILabel *)titleView.subviews.firstObject;
//    
//    [self addSubview:titleView];
//    
//    [self bringSubviewToFront:_PageControl];
//}
//
//
//
//- (UIView *)creatLabelBgView {
//    
//    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, myHeight-pageSize, myWidth, pageSize)];
////    v.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,0, myWidth-_PageControl.frame.size.width-16,pageSize)];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:pageSize*0.5];
//    
//    [v addSubview:label];
//    
//    return v;
//}
//
//- (void)setTextColor:(UIColor *)textColor {
//    _titleLabel.textColor = textColor;
//}
//
//- (void)setFont:(UIFont *)font {
//    _titleLabel.font = font;
//}
//
//#pragma mark scrollViewDelegate
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self setUpTimer];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self removeTimer];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self changeImageWithOffset:scrollView.contentOffset.x];
//}
//
//
//- (void)changeImageWithOffset:(CGFloat)offsetX {
//    
//    if (offsetX >= myWidth * 2) {
//        _currentIndex++;
//        
//        if (_currentIndex == _MaxImageCount-1) {
//            
//            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
//            
//        }else if (_currentIndex == _MaxImageCount) {
//            
//            _currentIndex = 0;
//            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
//            
//        }else {
//            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
//        }
//        _PageControl.currentPage = _currentIndex;
//        
//    }
//    
//    if (offsetX <= 0) {
//        _currentIndex--;
//        
//        if (_currentIndex == 0) {
//            
//            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
//            
//        }else if (_currentIndex == -1) {
//            
//            _currentIndex = _MaxImageCount-1;
//            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
//            
//        }else {
//            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
//        }
//        
//        _PageControl.currentPage = _currentIndex;
//    }
//    
//}
//
//- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
//    
//    
//    _leftImageView.image = [self setImageWithIndex:LeftIndex];
//    _centerImageView.image = [self setImageWithIndex:centerIndex];
//    _rightImageView.image = [self setImageWithIndex:rightIndex];
//    
//    
//    if (_hasTitle) {
//        _titleLabel.text = [self.titleData objectAtIndex:centerIndex];
//    }
//    
//    [_scrollView setContentOffset:CGPointMake(myWidth, 0)];
//}
//
//-(void)setPlaceImage:(UIImage *)placeImage {
//    if (!_isNetwork) return;
//    
//    _placeImage = placeImage;
//    if (_MaxImageCount < 2 && _centerImageView) {
//        _centerImageView.image = _placeImage;
//    }else {
//        [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
//    }
//}
//
//
//
//- (UIImage *)setImageWithIndex:(NSInteger)index {
//    if (index < 0||index >= self.imageUrlStrings.count) {
//        return _placeImage;
//    }
//    //从内存缓存中取,如果没有使用占位图片
//    UIImage *image = [self.imageData objectForKey:self.imageUrlStrings[index]];
//    
//    return image ? image : _placeImage;
//}
//
//
//- (void)scorll {
//    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + myWidth, 0) animated:YES];
//}
//
//- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay {
//    _AutoScrollDelay = AutoScrollDelay;
//    [self removeTimer];
//    [self setUpTimer];
//}
//
//- (void)setUpTimer {
//    if (_AutoScrollDelay < 0.5||_timer != nil) return;
//    
//    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//}
//
//- (void)removeTimer {
//    if (_timer == nil) return;
//    [_timer invalidate];
//    _timer = nil;
//}
//
//- (void)setImageUrlStrings:(NSArray *)imageUrlStrings {
//    
//    _imageUrlStrings = imageUrlStrings;
//    _imageData = [NSMutableDictionary dictionaryWithCapacity:_imageUrlStrings.count];
//    
//    _isNetwork = [imageUrlStrings.firstObject hasPrefix:@"http://"];
//    
//    if (_isNetwork) {
//        
//        DCWebImageManager *manager = [DCWebImageManager shareManager];
//        
//        [manager setDownLoadImageComplish:^(UIImage *image, NSString *url) {
//            [self.imageData setObject:image forKey:url];
//            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
//        }];
//        
//        for (NSString *urlSting in imageUrlStrings) {
//            [manager downloadImageWithUrlString:urlSting];
//        }
//        
//    }else {
//        
//        for (NSString *name in imageUrlStrings) {
//            [self.imageData setObject:[UIImage imageNamed:name] forKey:name];
//        }
//        
//        
//    }
//    
//}
//
//- (NSMutableAttributedString *) getbalanceStrWithString:(NSString *)balanceStr {
//    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:balanceStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#cccccc"],NSFontAttributeName:[UIFont systemFontOfSize:10*Constants.screenWidthRate]}];
//    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#ffffff"] range:NSMakeRange(3,balanceStr.length-3)];
//    [vAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*Constants.screenWidthRate] range:NSMakeRange(3,balanceStr.length-4)];
//    return vAttrString;
//}
//
//-(void)dealloc {
//    [self removeTimer];
//}
//
////
////- (void)getImage {
////
////    SDWebImageManager *manager = [SDWebImageManager sharedManager];
////
////    for (NSString *urlString in _imageData) {
////
////        [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageHighPriority progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
////            if (error) {
////                NSLog(@"%@",error);
////            }
////        }];
////    }
////
////}
////- (UIImage *)setImageWithIndex:(NSInteger)index {
////
////  UIImage *image =
////    [[[SDWebImageManager sharedManager] imageCache] imageFromMemoryCacheForKey:_imageData[index]];
////    if (image) {
////        return image;
////    }else {
////        return _placeImage;
////    }
////    
////}
//
//
//
//
//
//
//
//@end
//
//
//
//
//
//
//
//
//
//
//
//
