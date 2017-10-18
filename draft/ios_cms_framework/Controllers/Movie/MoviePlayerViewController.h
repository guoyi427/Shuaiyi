//
//  MoviePlayerViewController.h
//  MoviePlayerViewController
//
//  Created by pljhonglu on 13-12-18.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

/*
 依赖框架：AVfoundation.framework
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol MoviePlayerViewControllerDelegate <NSObject>
- (void)movieFinished:(CGFloat)progress;
@end

@protocol MoviePlayerViewControllerDataSource <NSObject>

//key of dictionary
#define KTitleOfMovieDictionary @"title"
#define KURLOfMovieDicTionary @"url"

@required
//- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie;
//- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie;
//- (BOOL)isHaveNextMovie;
//- (BOOL)isHavePreviousMovie;
@end


@interface MoviePlayerViewController : UIViewController
typedef enum {
    MoviePlayerViewControllerModeNetwork = 0,
    MoviePlayerViewControllerModeLocal
} MoviePlayerViewControllerMode;

@property (nonatomic,strong,readonly)NSURL *movieURL;
@property (nonatomic,strong,readonly)NSArray *movieURLList;
@property (readonly,nonatomic,copy)NSString *movieTitle;
@property (nonatomic, weak) id<MoviePlayerViewControllerDelegate> delegate;
@property (nonatomic, weak) id<MoviePlayerViewControllerDataSource> datasource;
@property (nonatomic, assign) MoviePlayerViewControllerMode mode;

@property (nonatomic,assign) BOOL isAddObserve;

- (id)initNetworkMoviePlayerViewControllerWithURL:(NSURL *)url movieTitle:(NSString *)movieTitle;
-(void)playerViewDelegateSetStatusBarHiden:(BOOL)is_hiden;
@end
