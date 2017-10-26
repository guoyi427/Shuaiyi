//
//  KotaMovieCell.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KotaMovieCell : UITableViewCell
{
    UILabel *lblMan,*lblNum,*lblWoman,*lblName;
    UIImageView *posterImgV;
}
@property(nonatomic,copy)NSString *manNum;
@property(nonatomic,copy)NSString *womanNum;
@property(nonatomic,copy)NSString *succeedNum;
@property(nonatomic,copy)NSString *movieName;
@property(nonatomic,copy)NSString *posterPath;


-(void)reloadData;
@end
