//
//  VideoPostInfoView.h
//  KoMovie
//
//  Created by KKZ on 16/3/6.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoPostInfoViewDelegate <NSObject>
-(void)addTableViewHeaderWithVideoPostInfoViewHeight:(CGFloat)height;
@end

@class ClubCellBottom;
@interface VideoPostInfoView : UIView
{
    //用户信息
    ClubCellBottom *clubCellBottom;
    //帖子信息
    UILabel *postInfoLbl;
    UIView *bottomView1;
    UIView *bottomView2;
}
@property (nonatomic, strong) ClubPost *clubPost;
@property(nonatomic,weak)id<VideoPostInfoViewDelegate>delegate;

-(void)upLoadData;
@end
