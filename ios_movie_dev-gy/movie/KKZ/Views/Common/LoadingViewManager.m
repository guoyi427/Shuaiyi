//
//  LoadingViewManager.m
//  KoMovie
//
//  Created by kokozu on 21/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "LoadingViewManager.h"

@interface LoadingViewManager ()
{
    //  View
    UIView *_bgView;
    UIImageView *_loadingView;
    UILabel *_loadingLabel;
}
@end

@implementation LoadingViewManager

+ (instancetype)sharedInstance {
    static LoadingViewManager *m_loadingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_loadingView = [[LoadingViewManager alloc] init];
    });
    return m_loadingView;
}

- (void)startWithText:(NSString *)text {
    if (_bgView) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
    
    if (_loadingLabel) {
        [_loadingLabel removeFromSuperview];
        _loadingLabel = nil;
    }
    
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    [appDelegate.window addSubview:_bgView];
    
    _loadingView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"LoadingView"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 18, 15, 83)]];
    [_bgView addSubview:_loadingView];
    
    _loadingLabel = [[UILabel alloc] init];
    _loadingLabel.text = text;
    _loadingLabel.font = [UIFont systemFontOfSize:14];
    _loadingLabel.textColor = appDelegate.kkzPink;
    _loadingLabel.numberOfLines = 0;
    [_loadingView addSubview:_loadingLabel];
                    
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
        make.width.equalTo(_loadingLabel).offset(40);
        make.height.equalTo(_loadingLabel).offset(83-14);
    }];
                    
                    
    [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loadingView);
        make.bottom.mas_equalTo(-20);
        make.width.lessThanOrEqualTo(_bgView).offset(-100);
    }];
}

- (void)stop {
    [_loadingLabel removeFromSuperview];
    [_loadingView removeFromSuperview];
    [_bgView removeFromSuperview];
    _loadingLabel = nil;
    _loadingView = nil;
    _bgView = nil;
}

@end
