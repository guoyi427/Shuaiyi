//
//  MovieCinemaChildViewController.h
//  CIASMovie
//
//  Created by cias on 2017/2/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaHomeCell.h"

@interface MovieCinemaChildViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CinemaHomeCellDelegate,UISearchBarDelegate>{
    UITableView *cinemaTableView;
    UIView *sectionView;
    UISearchBar *cinemaSearchBar;

}

@property (nonatomic, strong) NSMutableArray *cinemaList;
@property (nonatomic, strong) NSMutableArray *cinemaMovieList;
@property (nonatomic, strong) NSMutableArray *searchCinemaList;
@property (nonatomic, assign) NSInteger selectCinemaRow;

- (void)scrollTop;

- (void)textFieldResignFirstResponder;

- (void)requestCinemaList;

@end
