//
//  MovieActorCollectionViewCell.m
//  CIASMovie
//
//  Created by avatar on 2016/12/30.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MovieActorCollectionViewCell.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import <Category_KKZ/NSDictionaryExtra.h>

@implementation MovieActorCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 3.5;
        self.clipsToBounds = YES;
        
        actorPosterImage = [UIImageView new];
        actorPosterImage.backgroundColor = [UIColor whiteColor];
        actorPosterImage.layer.cornerRadius = 30*Constants.screenWidthRate;
        actorPosterImage.clipsToBounds = YES;
        actorPosterImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:actorPosterImage];
        [actorPosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(15*Constants.screenHeightRate, 15*Constants.screenWidthRate, 50*Constants.screenHeightRate, 15*Constants.screenWidthRate));
        }];
        
        self.actorName = @"大卫.代词";
        actorNameLabel = [UILabel new];
        actorNameLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        actorNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        actorNameLabel.backgroundColor = [UIColor clearColor];
        actorNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:actorNameLabel];
        [actorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(actorPosterImage.mas_bottom).offset(10*Constants.screenHeightRate);
            make.height.equalTo(@(15*Constants.screenHeightRate));
        }];
        self.actorRoleName = @"导演";
        actorRoleLabel = [UILabel new];
        actorRoleLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        actorRoleLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        actorRoleLabel.backgroundColor = [UIColor clearColor];
        actorRoleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:actorRoleLabel];
        [actorRoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(actorNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@(15*Constants.screenHeightRate));
        }];
        
    }
    return self;
}

- (void)updateLayout{
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"goods_nopic"] newSize:actorPosterImage.frame.size bgColor:[UIColor whiteColor]];
    
    [actorPosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:[self.movieActorInfo kkz_stringForKey:@"cover"]] placeholderImage:placeHolderImage];
    actorNameLabel.text = [self.movieActorInfo kkz_stringForKey:@"name"];
    actorRoleLabel.text = [[self.movieActorInfo kkz_stringForKey:@"role"] intValue] == 1? @"演员":@"导演";
}


@end
