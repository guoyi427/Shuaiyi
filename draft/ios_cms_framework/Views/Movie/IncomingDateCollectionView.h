//
//  IncomingDateCollectionView.h
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomingDateCollectionView : UICollectionView
{
    UIView *selectBg;
    UILabel *dateLabel;
    
}
@property (nonatomic, copy) NSString *dateString;

- (void)updateLayout;


@end
