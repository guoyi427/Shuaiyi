//
//  KotaListForMovieCell.h
//  KoMovie
//
//  Created by avatar on 14-11-24.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioButton.h"
#import "RoundCornersButton.h"
#import "AudioBarView.h"
#import "KotaShare.h"


@interface KotaListForMovieCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UIImageView *posterImgV,*nearImgV,*loveImgV;
    UILabel *lbldistance,*lblcinemaName,*lblshareNickname,*lblcreateTime,*lblkotaContent,*lblApplying,*lblapplyTime,*lbllove,*commentTextLbl;
    UIButton *applyBtn,*applyMeBtn,*refuseBtn;
    UIView *loveImgVR,*commentView;
    CGFloat left;
    
}

@property(nonatomic,copy)NSString *screenDegreeType;
@property(nonatomic,copy)NSString *screenSizeType;
@property(nonatomic,copy)NSString *createTimeType;
@property(nonatomic,copy)NSString *movieTimeType;
@property (nonatomic,copy)NSString *langType;
@property (nonatomic,assign)int likeType;
@property (nonatomic,assign)int targetId;
@property (nonatomic,assign)BOOL myAppointment;
@property (nonatomic,strong) KotaShare *kota;
@property (nonatomic,strong) KotaShare *kotaRmb;
@property (nonatomic,assign)int index;
@property (nonatomic, strong) AudioBarView *audioBarView;

-(void)reloadData;

@end
