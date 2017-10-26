//
//  KotaListCell.h
//  KKZ
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KotaShare.h"

@protocol KotaListCellDelegate <NSObject>

- (void)handleTouchOnUser:(NSString *)userId;
- (void)handleTouchOnApplyKotaSuccess; // 申请与TA一起观影，处理逻辑之后调用。table可以处理，可以不处理。
- (void)handleTouchOnShowMovie:(int)kotaId;
- (void)handleTouchOnMessage:(unsigned int)userId userName:(NSString *)userName;
- (void)handleTouchAtRow:(int)row;

@end

@interface KotaListCell : UITableViewCell <UIGestureRecognizerDelegate>
{
    UILabel * nameLabel;
    UILabel * timeDistanceLabel;
    UILabel * movieLabel;
    UILabel * dateLabel;
    UILabel * cinemaLabel;
    UILabel * fansNumLabel, *forwardNumLabel;
    UIImageView * applyButtonBg;
    UIImageView * noApplyButtonBg;
    UIImageView * emailButtonBg;
    UIImageView * avatarImageView;
    UIButton * posterImageView, *msgShareBtn;
    CGRect loveBtnRect, userAvatarRect, movieBtnRect, applyBtnRect, emailBtnRect;
    UIImageView* timeDistanceBg;
}

@property (nonatomic, weak) id <KotaListCellDelegate> delegate;
@property (nonatomic,strong)KotaShare *kotaShare;
@property (nonatomic, assign) int kotaId;
@property (nonatomic, assign) int kotaType;
@property (nonatomic, assign) int kotaStatus;
@property (nonatomic, strong) NSString * cinemaName;
@property (nonatomic, strong) NSString * movieName;
@property (nonatomic, strong) NSString * ticketTime;
@property (nonatomic, strong) NSString * cinemaId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSNumber * distance;
@property (nonatomic, strong) NSString * posterUrl;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * fansNum;
@property (nonatomic, assign) int rowNumInTable;
@property (nonatomic, strong) NSString * userSex;
@property (nonatomic, assign) CellState currentCellState;
@property (nonatomic, assign) BOOL locationON;
@property (nonatomic, assign) BOOL isApply;
@property (nonatomic,strong) KotaShare *kota;

- (void)updateLayout;
+ (float)heightWithCellState:(CellState)state;

@end
