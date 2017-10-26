//
//  MovieCommentData.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieCommentData.h"
#import "KKZUtility.h"
#import "DataEngine.h"

static MovieCommentData *manager=nil;

@implementation MovieCommentData

+(MovieCommentData *)sharedInstance{
    @synchronized(manager) {
        if (manager == nil) {
            manager=[[MovieCommentData alloc]init];
            manager.isClearImgArr = TRUE;
        }
        return manager;
    }
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

- (void)setIsClearImgArr:(BOOL)isClearImgArr {
    _isClearImgArr = isClearImgArr;
    if (_isClearImgArr) {
        [_imagesArray removeAllObjects];
        _inputString = @"";
    }
}

- (BOOL)isSetCinemaId {
    //影院ID
    NSString *cinema_id = self.cinemaId;
    if (![KKZUtility stringIsEmpty:cinema_id] && ![cinema_id isEqualToString:@"0"]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)isSetMovieId {
    NSString *movie_id = self.movieId;
    if (![KKZUtility stringIsEmpty:movie_id] && ![movie_id isEqualToString:@"0"]) {
        return TRUE;
    }
    return FALSE;
}

- (NSString *)getCommentContentWithType:(chooseType)type {
    NSString *nickName = [DataEngine sharedDataEngine].userName;
    NSString *movieName = [MovieCommentData sharedInstance].movieName;
    NSString *cinemaName = [MovieCommentData sharedInstance].cinemaName;
    NSString *showString = nil;
    if ([self isSetCinemaId]) {
        if (type == chooseTypeAudio) {
            showString = [NSString stringWithFormat:@"语音吐槽来袭~关于 %@ 在%@的神吐槽来啦!",nickName,cinemaName];
        }else if (type == chooseTypeImageAndWord) {
            showString = [NSString stringWithFormat:@"晒观影心情~关于 %@ 在%@的照片秀来啦!",nickName,cinemaName];
        }
    }else if ([self isSetMovieId]) {
         if (type == chooseTypeAudio) {
            showString = [NSString stringWithFormat:@"语音吐槽来袭~关于 %@ 在看过《%@》的神吐槽来啦!",nickName,movieName];
        }else if (type == chooseTypeImageAndWord) {
            showString = [NSString stringWithFormat:@"晒观影心情~关于 %@ 在看过《%@》的照片秀来啦!",nickName,movieName];
        }
    }
    return showString;
}

- (void)freeMovieCommentData {
    manager = nil;
}

@end
