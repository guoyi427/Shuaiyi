//
//  friendRecommendModel.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "friendRecommendModel.h"

@implementation friendRecommendModel

- (void)setDistance:(CGFloat)distance {
    _distance = distance;
    if (_distance < 1000) {
        self.estimateDistance = [NSString stringWithFormat:@"%dm",(int)_distance];
    }else {
        CGFloat new = _distance / 1000;
        self.estimateDistance = [NSString stringWithFormat:@"%.2fkm",new];
    }
}

@end
