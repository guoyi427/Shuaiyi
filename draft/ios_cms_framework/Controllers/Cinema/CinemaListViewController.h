//
//  CinemaListViewController.h
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemaListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *cinemaTableView;
    UIView *sectionView;
    UISearchBar *cinemaSearchBar;
    UIView *selectCityView;
    UILabel *cityNameLabel;
    UIImageView *arrowImageView;
    UIButton *selectCityBtn;

}

@property (nonatomic, strong) NSMutableArray *cinemaList;
@property (nonatomic, strong) NSMutableArray *searchCinemaList;

@property (nonatomic, assign) BOOL isBindingCard;
@property (nonatomic, assign) BOOL isOpenCard;

@property (nonatomic, assign) NSInteger selectedRow;
@property(nonatomic,copy) void(^selectCinemaBlock)(NSString *cinemaId);
@property(nonatomic,copy) void(^selectCinemaForCardBlock)(NSString *cinemaId,NSString *cinemaName);


@end
