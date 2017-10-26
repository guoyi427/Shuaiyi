//
//  收藏影院列表的Cell
//
//  Created by KKZ on 15/12/15.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CollectCinemaCellDelegate <NSObject>

@optional
- (void)handleTouchOnCancelCollectAtRow:(NSInteger)row;
- (void)handleTouchOnDetailAtRow:(NSInteger)row;

@end

@interface CollectCinemaCell : UITableViewCell

@property (nonatomic, weak) id<CollectCinemaCellDelegate> delegate;

@property (nonatomic, assign) NSInteger rowNum;

@property (nonatomic, strong) NSString *cinemaName;
@property (nonatomic, strong) NSString *cinemaAddr;
@property (nonatomic, assign) CGFloat cinemaDistance;

- (void)updateLayout;

@end
