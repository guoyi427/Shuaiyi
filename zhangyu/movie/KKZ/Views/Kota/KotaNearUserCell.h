//
//  KotaNearUserCell.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KotaNearUserCell : UITableViewCell
{
    UILabel *lblShareNickname, *lblCinemaName, *lblFilmName, *lblDistance, *lblStatus;
    UIImageView *avatarView;
    UIImageView *headImgV;
    
    CGRect avatarRect;
    UIImageView *distanceImgV;
}

@property(nonatomic,copy)NSString *distance;
@property(nonatomic,copy)NSNumber *status;
@property(nonatomic,copy)NSString *shareId;
@property(nonatomic,copy)NSString *cinemaName;
@property(nonatomic,copy)NSString *filmName;
@property(nonatomic,copy)NSString *shareHeadimg;
@property(nonatomic,copy)NSString *shareNickname;
@property (nonatomic,strong)NSNumber *screenDegree;
@property (nonatomic,strong)NSNumber *screenSize;
@property (nonatomic,strong)NSString *lang;
@property (nonatomic,strong)NSNumber *kotaId;
@property (nonatomic,strong)NSString *createTime;

-(void)reloadData;
@end
