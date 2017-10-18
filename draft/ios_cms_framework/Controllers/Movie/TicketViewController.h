//
//  TicketViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaHomeCell.h"
#import "MovieChildViewController.h"
#import "MovieCinemaChildViewController.h"

@interface TicketViewController : UIViewController<UINavigationControllerDelegate>{
    UISegmentedControl *segmentedControl;
    UILabel *cityNameLabel;
    UIImageView *arrowImageView;
    UIButton *selectCityBtn;
    
    
    //    UIView *incomingDateCollectionViewBg;
    //    UICollectionView *incomingDateCollectionView;
    //
    //    UICollectionView *movieCollectionView;
    //    NSInteger pageNum, incomingPageNum;
    
    //    UITableView *cinemaTableView;
    BOOL tableLock, initFirst;
    //    UITextField *cinemaSearchFiled;
    
}

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) MovieChildViewController *movieChildViewController;
@property (nonatomic, strong) MovieCinemaChildViewController *movieCinemaChildViewController;



- (void)setSelectedTabAtTicketIndex:(NSInteger)index;

@end
