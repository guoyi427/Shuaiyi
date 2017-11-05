//
//  UserCenterMovieCell.h
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterMovieCell : UITableViewCell

- (void)updateModel:(NSDictionary *)model isScore:(BOOL)isScore;

@end
