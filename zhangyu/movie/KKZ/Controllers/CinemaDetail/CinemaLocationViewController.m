//
//  影院的地图页面
//
//  Created by alfaromeo on 12-3-23.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CinemaLocationViewController.h"

#import "Cinema.h"
#import "CinemaAnnotation.h"
#import "LocationEngine.h"
#import "MKMapViewExtra.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "WebViewController.h"
#import "CinemaRequest.h"
#import "CinemaDetail.h"

@interface CinemaLocationViewController () {

  UIView *topViews;
  UILabel *cinemaAddress;
  UIButton *showPathBtn;

  MKMapView *mapView;
  double latitude, longitude;
  CinemaAnnotation *cinemaFlag;
  MKUserLocation *userFlag;

  UITextField *cinemaIntroSection;
  UILabel *cinemaIntro;
}

@property(nonatomic, strong) NSString *cinemaId;

//@property (nonatomic, strong) Cinema *myCinema;

@end

@implementation CinemaLocationViewController

#pragma mark - View lifecycle
- (id)initWithCinema:(NSString *)cinemaId {
  self = [super init];
  if (self) {
    self.cinemaId = cinemaId;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  topViews = [[UIView alloc]
      initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, 50)];
  topViews.backgroundColor = [UIColor whiteColor];
  topViews.alpha = 0.8;
  [self.view addSubview:topViews];

  if (THIRD_LOGIN) {
    showPathBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(screentWith - 80, 8, 70, 30)];
    showPathBtn.backgroundColor = appDelegate.kkzBlue;
    showPathBtn.titleLabel.textColor = [UIColor whiteColor];
    [showPathBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    showPathBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    showPathBtn.layer.cornerRadius = 3;
    [showPathBtn addTarget:self
                    action:@selector(showPath)
          forControlEvents:UIControlEventTouchUpInside];
    [topViews addSubview:showPathBtn];
  }

  cinemaAddress = [[UILabel alloc]
      initWithFrame:CGRectMake(10, 8, screentWith - 80 - 20, 35)];
  cinemaAddress.backgroundColor = [UIColor clearColor];
  cinemaAddress.numberOfLines = 0;
  cinemaAddress.textColor = appDelegate.kkzTextColor;
  cinemaAddress.font = [UIFont systemFontOfSize:13];
  [topViews addSubview:cinemaAddress];

  [appDelegate resetMapView];
  mapView = appDelegate.sharedMapView;
  mapView.frame =
      CGRectMake(0, self.contentPositionY, screentWith, screentContentHeight);
  mapView.delegate = self;
  [self.view insertSubview:mapView atIndex:0];

  if (self.cinemaDetail) {
    latitude = [self.cinemaDetail.latitude doubleValue];
    longitude = [self.cinemaDetail.longitude doubleValue];
    [self updateLayout];
  } else {
    [self refreshCinemaDetail];
  }
}

- (void)dealloc {
  [appDelegate resetMapView];
}

#pragma mark - Network task
/**
 *  MARK: 请求影院详情
 */
- (void)refreshCinemaDetail {

  CinemaRequest *request = [[CinemaRequest alloc] init];

  [request
      requestCinemaDetail:[NSDictionary
                              dictionaryWithObjectsAndKeys:self.cinemaId,
                                                           @"cinema_id", nil]
      success:^(CinemaDetail *cinemaDetail, ShareContent *share) {
        self.cinemaDetail = cinemaDetail;
        [self updateLayout];
      }
      failure:^(NSError *_Nullable err) {
        DLog(@"request cinema detail err:%@", err);
      }];
}

/**
 *  更新布局
 */
- (void)updateLayout {

  self.kkzTitleLabel.text = self.cinemaDetail.cinemaName;

  cinemaAddress.text = ([self.cinemaDetail.cinemaAddress length]
                            ? self.cinemaDetail.cinemaAddress
                            : @"暂无影院的地址信息");

  // setting map view
  latitude = [self.cinemaDetail.latitude doubleValue];
  longitude = [self.cinemaDetail.longitude doubleValue];

  MKCoordinateRegion newRegion;
  newRegion.center.latitude = latitude;
  newRegion.center.longitude = longitude;
  newRegion.span.latitudeDelta = 0.01;
  newRegion.span.longitudeDelta = 0.01;
  [mapView setArea:newRegion animated:YES];

  // set pin annotaiton
  CLLocationCoordinate2D theCoordinate;
  theCoordinate.latitude = latitude;
  theCoordinate.longitude = longitude;

  if (cinemaFlag) {
    [mapView removeAnnotation:cinemaFlag];
    cinemaFlag = nil;
  }

  cinemaFlag = [[CinemaAnnotation alloc] initWithCoordinate:theCoordinate];
  cinemaFlag.cinemaName = self.cinemaDetail.cinemaName;
  cinemaFlag.cinemaId = self.cinemaDetail.cinemaId.stringValue;

  [mapView addAnnotation:cinemaFlag];

  [self showUserLocation];
}

- (void)showPath {
  if (latitude < -90 || latitude > 90) {
    latitude = 0;
  }
  if (longitude < -180 || longitude > 180) {
    longitude = 0;
  }
  if (latitude == 0 || longitude == 0) {
    return;
  }

  // 直接调用ios自己带的apple map

  CLLocationCoordinate2D cc2d;
  cc2d.latitude = latitude;
  cc2d.longitude = longitude;
  MKMapItem *toLocation = [[MKMapItem alloc]
      initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:cc2d
                                              addressDictionary:nil]];
  toLocation.name = self.cinemaDetail.cinemaName;
  [toLocation openInMapsWithLaunchOptions:@{}];
}

#pragma mark - DirectionsModeViewDelegate
- (void)showUserLocation {
  CLLocationCoordinate2D userCoordinate;
  userCoordinate.latitude = [LocationEngine sharedLocationEngine].latitude;
  userCoordinate.longitude = [LocationEngine sharedLocationEngine].longitude;

  if (userFlag) {
    [mapView removeAnnotation:userFlag];
    userFlag = nil;
  }

  userFlag = [[MKUserLocation alloc] init];
  [userFlag setCoordinate:userCoordinate];
  [mapView addAnnotation:userFlag];
}

#pragma mark map view delegate
- (UIImage *)imageForCinemaAnnotation:(CinemaAnnotation *)customAnno {
  CGSize annotationSize = CGSizeMake(40, 40);
  NSString *text = nil;
  CGSize textSize = CGSizeZero;
  text = customAnno.cinemaName;
  textSize =
      [customAnno.cinemaName sizeWithFont:[UIFont boldSystemFontOfSize:15]
                        constrainedToSize:CGSizeMake(100, 300)];
  annotationSize.width = textSize.width + 6;
  annotationSize.height = MAX(textSize.height + 12, 48);
  if (retinaDisplaySupported) {
    UIScreen *screen = [UIScreen mainScreen];
    UIGraphicsBeginImageContextWithOptions(annotationSize, NO, [screen scale]);
  } else {
    UIGraphicsBeginImageContext(annotationSize);
  }

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextMoveToPoint(context, 0, 0);
  CGContextAddLineToPoint(context, annotationSize.width, 0);
  CGContextAddLineToPoint(context, annotationSize.width,
                          annotationSize.height - 10);
  CGContextAddLineToPoint(context, annotationSize.width / 2 + 20 / 2,
                          annotationSize.height - 10);
  CGContextAddLineToPoint(context, annotationSize.width / 2,
                          annotationSize.height);
  CGContextAddLineToPoint(context, annotationSize.width / 2 - 20 / 2,
                          annotationSize.height - 10);
  CGContextAddLineToPoint(context, 0, annotationSize.height - 10);
  CGContextAddLineToPoint(context, 0, 0);
  CGContextSetFillColorWithColor(context, appDelegate.kkzRed.CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextDrawPath(context, kCGPathFillStroke);

  [[UIColor whiteColor] set];
  [text drawInRect:CGRectMake(3, 0, textSize.width, textSize.height)
           withFont:[UIFont boldSystemFontOfSize:15]
      lineBreakMode:NSLineBreakByTruncatingTail
          alignment:NSTextAlignmentLeft];

  UIImage *annotationImg = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return annotationImg;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
  return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  MKAnnotationView *aV;
  for (aV in views) {
    CGRect endFrame = aV.frame;
    aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 130.0,
                          aV.frame.size.width, aV.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [aV setFrame:endFrame];
    [UIView commitAnimations];
  }
}

@end
