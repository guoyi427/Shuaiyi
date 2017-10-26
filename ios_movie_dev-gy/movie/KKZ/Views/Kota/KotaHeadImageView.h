//
//  KotaHeadImageView.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizonTableView.h"


@protocol KotaHeadImageViewDelegate <NSObject>
@optional
- (void)viewAllStillsForHead;
@end


@interface KotaHeadImageView : UIView< HorizonTableViewDatasource, HorizonTableViewDelegate > {
    HorizonTableView *headImageListView;
}


@property (nonatomic, weak) id <KotaHeadImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)updateLayout;

@end
