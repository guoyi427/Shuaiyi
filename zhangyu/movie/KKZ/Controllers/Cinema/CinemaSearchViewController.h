//
//  影院搜索页面
//
//  Created by KKZ on 15/12/9.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@class NoDataViewY;
@class AlertViewY;

@interface CinemaSearchViewController : CommonViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate> {

    UIView *searchFieldView;
    NSMutableArray *searchList;
    UITableView *cinemaTable;
    NoDataViewY *nodataView;
    AlertViewY *noAlertView;
    UIScrollView *searchRecord;
    UIButton *searchBtn;
    UISearchBar *m_searchBar;
    NSMutableArray *searchRecordArray;
}

@property (nonatomic, strong) NSArray *cinemas;

//根据条件筛选需要展示的影院Layout数组
@property (nonatomic, strong) NSArray *allCinemasListLayout;

@property (nonatomic, assign) BOOL isCinema;

@property (nonatomic, assign) unsigned int movieId;

@property (nonatomic, assign) BOOL isTextChange;

@property (nonatomic, assign) BOOL isFromCinema;

@end
