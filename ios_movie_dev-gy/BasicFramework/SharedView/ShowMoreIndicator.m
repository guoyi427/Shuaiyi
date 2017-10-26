 //
//  ShowMoreIndicator.m
//  Aimeili
//
//  Created by zhang da on 12-8-29.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "ShowMoreIndicator.h"


@implementation ShowMoreIndicator



- (void)dealloc {
    [super dealloc];
}


- (void)setPullingStatus {
    if (!self.isPulling && !_hasNoMore && !self.isLoading) {
        self.isPulling = YES;
        self.isReleasing = NO;
        self.statusLabel.text = @"上拉加载更多";
    }
}


- (void)setReleaseStatus {
    if (!self.isReleasing && !_hasNoMore && !self.isLoading) {
        self.isReleasing = YES;
        self.isPulling = NO;
        self.statusLabel.text = @"松开加载更多";
    }
}


- (void)setIsLoading:(BOOL)isLoading {
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
    }
    self.isReleasing = NO;
    self.isPulling = NO;
    
    if (_isLoading) {
        [indicator startAnimating];
        self.statusLabel.text = @"加载中...";
    }
//    else {
//        [indicator stopAnimating];
//        self.statusLabel.text = @"上拉加载更多";
//    }
}


- (void)setHasNoMore:(BOOL)hasNoMore {
    if (_hasNoMore != hasNoMore) {
        _hasNoMore = hasNoMore;
    }
    
    self.isLoading = NO;
    self.isReleasing = NO;
    self.isPulling = NO;
    
    if (_hasNoMore) {
        self.statusLabel.text = @"已经到最后了";
    }
    else {
        self.statusLabel.text = @"上拉加载更多";
    }
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.hasNoMore = NO;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.frame = CGRectMake((frame.size.width - 20) / 2, (frame.size.height - 20) / 2, 20, 20);
        indicator.hidesWhenStopped = YES;
        [self addSubview:indicator];
        [indicator release];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.statusLabel.textColor = [UIColor grayColor];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
    }
    return self;
}


- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    
    indicator.activityIndicatorViewStyle = activityIndicatorViewStyle;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
