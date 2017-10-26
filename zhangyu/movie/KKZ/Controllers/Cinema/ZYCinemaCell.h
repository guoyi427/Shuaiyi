//
//  ZYCinemaCell.h
//  KoMovie
//
//  Created by kokozu on 25/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CinemaDetail;
@interface ZYCinemaCell : UITableViewCell

- (void)update:(CinemaDetail *)model;

@end
