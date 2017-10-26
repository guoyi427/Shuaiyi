//
//  KotaNearUserCell.m
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "KotaNearUserCell.h"

@implementation KotaNearUserCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 头像
        avatarRect = CGRectMake(13, 12, 60, 60);
        avatarView = [[UIImageView alloc] initWithFrame:avatarRect];
        avatarView.contentMode = UIViewContentModeScaleAspectFit;
        avatarView.clipsToBounds = YES;
        avatarView.layer.masksToBounds = YES;
        avatarView.layer.cornerRadius = 30;
        avatarView.image = [UIImage imageNamed:@"avatarRImg"];
        [self addSubview:avatarView];
        
        lblShareNickname = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 90, 20)];
        lblShareNickname.textColor = [UIColor colorWithRed:37/255.0 green:88/255.0 blue:144/255.0 alpha:1.0];
        lblShareNickname.font = [UIFont systemFontOfSize:14];
        lblShareNickname.backgroundColor = [UIColor clearColor];
        [self addSubview:lblShareNickname];
        
        lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 120, 20)];
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.textColor = [UIColor grayColor];
        lblStatus.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblStatus];
        
        distanceImgV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 70, 23, 10, 11)];
        distanceImgV.image = [UIImage imageNamed:@"nearByIcon"];
        [self addSubview:distanceImgV];
        
        lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 55, 18, 50, 20)];
        lblDistance.backgroundColor = [UIColor clearColor];
        lblDistance.textColor = [UIColor grayColor];
        lblDistance.textAlignment = NSTextAlignmentLeft;
        lblDistance.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblDistance];
        
        lblCinemaName = [[UILabel alloc] initWithFrame:CGRectMake(80, 42, screentWith - 90, 20)];
        lblCinemaName.backgroundColor = [UIColor clearColor];
        lblCinemaName.textColor = [UIColor grayColor];
        lblCinemaName.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblCinemaName];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 83, screentWith, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]];
        [self addSubview:line];
        
    }
    return self;
}

-(void)reloadData {
    
    if ([self.distance intValue] == 9999999 || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { // 距离太远的话，距离图标隐藏
        
        lblDistance.hidden = YES;
        distanceImgV.hidden = YES;
    }
    else {
        distanceImgV.hidden = NO;
        lblDistance.hidden = NO;
        
        if ([self.distance intValue] > 1000) {
            int dis = [self.distance intValue] * 0.001;
            lblDistance.text = [NSString stringWithFormat:@"%dkm",dis];
        }
        else {
            lblDistance.text = [NSString stringWithFormat:@"%@m",self.distance];
        }
    }
    
    [avatarView loadImageWithURL:self.shareHeadimg andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];
    
//    self.shareNickname = @"和呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵";
    
    CGSize lblShareNicknameSize = [self.shareNickname sizeWithFont:[UIFont systemFontOfSize:14]];
    
    if (lblShareNicknameSize.width > screentWith - 215) {
        lblShareNickname.frame = CGRectMake(80, 20, screentWith - 215, lblShareNicknameSize.height);
    }
    else {
        lblShareNickname.frame = CGRectMake(80, 20, lblShareNicknameSize.width, lblShareNicknameSize.height);
    }
    
    lblShareNickname.text = self.shareNickname;
    
    
    CGRect lblStatusFrame = lblStatus.frame;
    lblStatusFrame = CGRectMake(CGRectGetMaxX(lblShareNickname.frame) + 3, 20, 130, lblShareNicknameSize.height);
    lblStatus.frame = lblStatusFrame;
    lblStatus.text = @"待约中...";
    
    if ([self.cinemaName isEqual:[NSNull null]]) {
        lblCinemaName.text = [NSString stringWithFormat:@"《%@》",self.filmName];
    }
    else {
        if (self.filmName.length && self.cinemaName.length) {
            lblCinemaName.text = [NSString stringWithFormat:@"%@《%@》",self.cinemaName,self.filmName];
        }
        else if (self.filmName.length) {
            lblCinemaName.text = [NSString stringWithFormat:@"《%@》",self.filmName];
        }
        else if (self.cinemaName.length) {
            lblCinemaName.text = [NSString stringWithFormat:@"%@",self.cinemaName];
        }
        else {
            lblCinemaName.text = @"";
        }
    }
}

@end
