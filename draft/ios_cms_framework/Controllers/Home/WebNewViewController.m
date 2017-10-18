//
//  WebNewViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/5/17.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "WebNewViewController.h"

#import "UserDefault.h"
#import "XingYiPlanListViewController.h"
#import "MovieDetailViewController.h"
#import "MovieRequest.h"

static WebNewViewController *_sharedWebView;

@interface WebNewViewController ()

@end

@implementation WebNewViewController

- (void)dealloc {
  
     //WebView停止请求
     [self.webView stopLoading];
}

/**
 * 重新加载页面。
 */

- (void)reloadPage {
    
       [self.webView reload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = self.webViewTitle;
    self.hideNavigationBar = false;
}

- (void) viewDidAppear:(BOOL)animated {
   
    [super viewDidAppear:animated];
    
   
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
   
     [super viewDidLoad];
   
     self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
   
     //延伸的布局
   
     self.edgesForExtendedLayout = UIRectEdgeNone;
   
     //加载网页视图
   
     [self loadWebView];
   
     //加载滚动轮
   
     [self loadIndicatorView];
   
   
   
}


- (void)loadIndicatorView {
    
     [self.view addSubview:self.indicatorView];
}

- (void)loadWebView {
    
     //初始化webView对象
    
     if (self.requestURL) {
   
          [self loadRequestWithURL:self.requestURL];
   
      }
    
     [self.view addSubview:self.webView];
    
    
    
}

- (void)loadRequestWithURL:(NSString *)url {
    
    
    
       //加载UIWebView的请求
    
       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:url]];
    
       //        NSString *host = requestURL.host;
    
       //        if ([host rangeOfString:[self needToAppendDomain]].location != NSNotFound) {
    
       //            [self appendRequest:request];
    
       //        }
    
       [self.webView loadRequest:request];
    
    
    
       //加载滚动轮
    
       [self.indicatorView startAnimating];
    
}

- (UIWebView *)webView {
        if (!_webView) {
      
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-64)];
      
            _webView.scrollView.showsVerticalScrollIndicator = NO;
      
            //设置WebView的参数
            [_webView setScalesPageToFit:YES];
      
            _webView.delegate = self;
      
        }
       return _webView;
    
}

- (UIActivityIndicatorView *)indicatorView {
      if (!_indicatorView) {
             _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
             _indicatorView.backgroundColor = [UIColor clearColor];
       
             [_indicatorView setCenter:CGPointMake(kCommonScreenWidth * 0.5f, kCommonScreenHeight * 0.5f)];
         }
      return _indicatorView;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
     NSURL *requestURL = request.URL;
   
     //先判断需不需要打开页面
     NSString *urlString = [requestURL absoluteString];
     DLog(@"callback url : %@", urlString);
   
     NSString *linkUrlStr = [NSString stringWithFormat:@"%@", urlString];
     DLog(@"linkUrl:%@", linkUrlStr);
   
     if([linkUrlStr hasPrefix:@"http://"]||[linkUrlStr hasPrefix:@"https://"]){
       
        return YES;
     } else if([linkUrlStr containsString:@"/app/page?name="]){
          
                //MARK: --区分是影片详情，还是排期列表
          
                NSArray *paramsTmp = [linkUrlStr componentsSeparatedByString:@"?"];
          
                NSArray *params = [paramsTmp[1] componentsSeparatedByString:@"&"];
          
                DLog(@"linkUrl中的参数:%@", params);
          
                NSString *linkUrlName = @"";
          
                NSString *linkUrl_isHot = @"";
          
                NSString *linkUrl_movieId = @"";
          
                NSString *linkUrl_cinemaId = @"";
          
                NSArray *nameArr = [[NSArray alloc] init];
          
             //根据name区分是影片详情还是排期列表
           
             if (params.count > 0) {
           
                     nameArr = [params[0] componentsSeparatedByString:@"="];
           
                     linkUrlName = nameArr[1];
           
                 }
           
             if ([linkUrlName isEqualToString:@"movieDetail"]) {
                            //影片详情
                            for (NSString *contentStr in params) {
                                   NSArray *contentArr = [contentStr componentsSeparatedByString:@"="];
                                   if ([contentArr[0] isEqualToString:@"movie_id"]) {
                                           linkUrl_movieId = contentArr[1];
                                       } else if ([contentArr[0] isEqualToString:@"is_hot"]) {
                                               linkUrl_isHot = contentArr[1];
                                          } else if ([contentArr[0] isEqualToString:@"cinema_id"]) {
                                                   linkUrl_cinemaId = contentArr[1];
                                               }
                               }
                         if (linkUrl_movieId.intValue>0) {
                                  //请求影片详情
                                   if ([linkUrl_isHot isEqualToString:@"0"]) {
                                           //热映，需考虑影院id是否有，且是否一致
                                           if (linkUrl_cinemaId.intValue > 0) {
                                                   if ([linkUrl_cinemaId isEqualToString:USER_CINEMAID]) {
                                                            //一致，则跳转
                                                           [[UIConstants sharedDataEngine] loadingAnimation];
                                                         NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:linkUrl_cinemaId, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                                           MovieRequest *request = [[MovieRequest alloc] init];
                                                          [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                                                   if (movie.movieId.intValue > 0) {
                                                                         MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                                                        ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                                                         ctr.isHiddenAnimation = YES;
                                                                           Constants.isHidAnimation = YES;
                                                                           ctr.myMovie = movie;
                                                                           [self.navigationController pushViewController:ctr animated:YES];
                                                                       }
                                                                 [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                              } failure:^(NSError * _Nullable err) {
                                                                       [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                                      [CIASPublicUtility showAlertViewForTaskInfo:err];
                                                                    }];
                                                        } else {
                                                               //影院不一致，不给跳转
                                                          }
                                              } else {
                                                       //url没有影院id，则传入用户选择的影院，有排期，则跳转
                                                       [[UIConstants sharedDataEngine] loadingAnimation];
                                                       NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                                     MovieRequest *request = [[MovieRequest alloc] init];
                                                       [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                                              if (movie.movieId.intValue > 0) {
                                                                       MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                                                       ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                                                      ctr.isHiddenAnimation = YES;
                                                                       Constants.isHidAnimation = YES;
                                                                  ctr.myMovie = movie;
                                                                       [self.navigationController pushViewController:ctr animated:YES];
                                                                   }
                                                               [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                            } failure:^(NSError * _Nullable err) {
                                                                   [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                                   [CIASPublicUtility showAlertViewForTaskInfo:err];
                                                             }];
                                                   }
                                       } else {
                                                //即将上映，不可购票，随便跳转
                                                [[UIConstants sharedDataEngine] loadingAnimation];
                                               NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:linkUrl_movieId, @"filmId", nil];
                                               MovieRequest *request = [[MovieRequest alloc] init];
                                               [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                                      MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                                       ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                                       ctr.myMovie = movie;
                                                       ctr.isHiddenAnimation = YES;
                                                        Constants.isHidAnimation = YES;
                                                      [self.navigationController pushViewController:ctr animated:YES];
                                                       [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                   } failure:^(NSError * _Nullable err) {
                                                           [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                           [CIASPublicUtility showAlertViewForTaskInfo:err];
                                                       }];
                                            }
                               }else{
                                       //movieid为空，不跳转
                                   }
                       } else if ([linkUrlName isEqualToString:@"moviePlan"]) {
                               //排期列表
                               for (NSString *contentStr in params) {
                                        NSArray *contentArr = [contentStr componentsSeparatedByString:@"="];
                                       if ([contentArr[0] isEqualToString:@"movie_id"]) {
                                               linkUrl_movieId = contentArr[1];
                                           } else if ([contentArr[0] isEqualToString:@"cinema_id"]) {
                                                   linkUrl_cinemaId = contentArr[1];
                                               }
                                   }
                               if (linkUrl_movieId.intValue>0) {
                                       //请求影片详情,是否有影院id
                                       if (linkUrl_cinemaId.intValue > 0) {
                                               //有影院id，相等跳转
                                              if ([linkUrl_cinemaId isEqualToString:USER_CINEMAID]) {
                                                       [[UIConstants sharedDataEngine] loadingAnimation];
                                                       NSString *cinema_id = linkUrl_cinemaId;
                                                     NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:cinema_id, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                                       DLog(@"movieid:%@", linkUrl_movieId);
                                                       MovieRequest *request = [[MovieRequest alloc] init];
                                                     [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                                               if (movie.movieId.intValue > 0) {
                                                                       XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
                                                                       ctr.movieId = linkUrl_movieId;
                                                                        ctr.cinemaId = cinema_id;
                                                                       ctr.isFromBanner = YES;
                                                                   Constants.isShowBackBtn = YES;
                                                                      [self.navigationController pushViewController:ctr animated:YES];
                                                                   }
                                                              [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                           } failure:^(NSError * _Nullable err) {
                                                                  [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                                  [CIASPublicUtility showAlertViewForTaskInfo:err];
                                                            }];
                                                   } else {
                                                          //有影院id，不相等，不跳转
                                                       }
                            
                                           } else {
                                                    //没有影院，根据用户选择的来跳转
                                                   [[UIConstants sharedDataEngine] loadingAnimation];
                                                   NSString *cinema_id = USER_CINEMAID;
                                                   NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:cinema_id, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                                   DLog(@"movieid:%@", linkUrl_movieId);
                                                  MovieRequest *request = [[MovieRequest alloc] init];
                                                  [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                                          if (movie.movieId.intValue > 0) {
                                                                   XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
                                                                 ctr.movieId = linkUrl_movieId;
                                                                ctr.cinemaId = cinema_id;
                                                                  ctr.isFromBanner = YES;
                                                              Constants.isShowBackBtn = YES;
                                                                  [self.navigationController pushViewController:ctr animated:YES];
                                                               }
                                                          [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                     } failure:^(NSError * _Nullable err) {
                                                             [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                                         [CIASPublicUtility showAlertViewForTaskInfo:err];
                                                                     
                                                 }];
                                     }
             	                 
                          }
              }
	 
        return NO;
    }
    return NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.indicatorView stopAnimating];
    
}


@end
