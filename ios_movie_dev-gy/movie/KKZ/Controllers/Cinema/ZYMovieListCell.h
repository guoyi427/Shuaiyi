//
//  ZYMovieListCell.h
//  KoMovie
//
//  Created by kokozu on 25/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZYMovieListCellType_Current,
    ZYMovieListCellType_Future,
} ZYMovieListCellType;

@class Movie;
@interface ZYMovieListCell : UITableViewCell

- (void)update:(Movie *)model type:(ZYMovieListCellType)type;

@end
