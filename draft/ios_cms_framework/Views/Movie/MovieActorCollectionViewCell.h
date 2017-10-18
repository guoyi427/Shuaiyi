//
//  MovieActorCollectionViewCell.h
//  CIASMovie
//
//  Created by avatar on 2016/12/30.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieActorCollectionViewCell : UICollectionViewCell
{
    UIImageView *actorPosterImage;
    UILabel *actorNameLabel, *actorRoleLabel;
    
}

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *actorName;
@property (nonatomic, copy) NSString *actorRoleName;
@property (nonatomic, strong) NSDictionary *movieActorInfo;


- (void)updateLayout;
@end
