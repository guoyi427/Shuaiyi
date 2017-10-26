//
//  电影详情 - 预告片列表的Cell
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieTrailerCell.h"

#import "ImageEngineNew.h"
#import "Movie.h"
#import "Trailer.h"

#define marginX 15

@implementation MovieTrailerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (screentWith - marginX * 3) * 0.5, (screentWith - marginX * 3) * 0.5 / 16 * 9)];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = NO;

        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (screentWith - marginX * 3) * 0.5, (screentWith - marginX * 3) * 0.5 / 16 * 9)];
        [cover setBackgroundColor:[UIColor r:0 / 255.0 g:0 / 255.0 b:0 / 255.0 alpha:0.6]];
        [imageView addSubview:cover];

        CGFloat videoBtnWidth = (screentWith - marginX * 3) * 0.5;
        CGFloat videoBtnHeight = (screentWith - marginX * 3) * 0.5 / 16 * 9;

        UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (screentWith - marginX * 3) * 0.5, (screentWith - marginX * 3) * 0.5 / 16 * 9)];
        [videoBtn setImage:[UIImage imageNamed:@"videoStopIcon"] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(movieTrailerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [videoBtn setImageEdgeInsets:UIEdgeInsetsMake((videoBtnHeight - 25) * 0.5, (videoBtnWidth - 25) * 0.5, (videoBtnHeight - 25) * 0.5, (videoBtnWidth - 25) * 0.5)];
        [self addSubview:videoBtn];
    }
    return self;
}

- (void)upLoadData {
    [imageView loadImageWithURL:self.imagePath andSize:ImageSizeOrign];
}

- (void)movieTrailerBtnClicked {
    [self startShowMovieTrailer:self.trailer.trailerPath];
}

- (void)startShowMovieTrailer:(NSString *)url {
    Movie *movie = [Movie getMovieWithId:self.trailer.movieId.intValue];
    movieVC = [[MoviePlayerViewController alloc] initNetworkMoviePlayerViewControllerWithURL:[NSURL URLWithString:url] movieTitle:movie.movieName];
    movieVC.delegate = self;
    [movieVC playerViewDelegateSetStatusBarHiden:YES];

    UIScreen *scr = [UIScreen mainScreen];
    movieVC.view.frame = CGRectMake(0, 0, screentHeight, scr.bounds.size.width);
    CGAffineTransform landscapeTransform;
    landscapeTransform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    CGFloat landscapeTransformX = 0;
    if (screentHeight == 480) {
        landscapeTransformX = 80;
    } else if (screentHeight == 667) {
        landscapeTransformX = 146;
    } else if (screentHeight == 568) {
        landscapeTransformX = 124;
    } else if (screentHeight == 736) {
        landscapeTransformX = 161;
    }

    landscapeTransform = CGAffineTransformTranslate(landscapeTransform, landscapeTransformX, landscapeTransformX);
    [movieVC.view setTransform:landscapeTransform];

    [appDelegate.window addSubview:movieVC.view];
}

- (void)movieFinished:(CGFloat)progress {
    [movieVC.view removeFromSuperview];
}

@end
