//
//  CityListViewController.h
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *cityTableView, *searchTableView;
    UISearchBar *citySearchBar;
    UIButton *leftBarBtn, *rightBarBtn;
    
}
@property (nonatomic, copy) NSString *cityNameGPS;

@property (nonatomic, strong) NSDictionary *cities;
@property (nonatomic, strong) NSArray *cityIndexes;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) NSMutableArray *searchCityList;

@property (nonatomic, assign) BOOL isBindingCardInCity;
@property (nonatomic, assign) BOOL isOpenCardInCity;

@property(nonatomic,copy)void(^selectCityBlock)(NSString *cityId);
@property(nonatomic,copy)void(^selectCityForCardBlock)(NSString *cityId,NSString *cityName);



@end
