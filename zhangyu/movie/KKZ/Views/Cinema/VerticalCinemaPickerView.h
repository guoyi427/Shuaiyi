//
//  影院列表按照城区筛选的View
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol VerticalCinemaPickerViewDelegate <NSObject>

- (void)selectDistrictName:(NSInteger)districtIndex;

@end

@interface VerticalCinemaPickerView
    : UIView <UITableViewDelegate, UITableViewDataSource> {

  UILabel *noCinemaAlertLabel;

  BOOL tableLocked, querySchedule;
  int selectedSection;
}

@property(nonatomic, weak) id<VerticalCinemaPickerViewDelegate> delegate;
@property(nonatomic, strong) NSString *selectedDistrictName;
@property(nonatomic, strong) NSArray *districtList;
@property(nonatomic, strong) NSMutableDictionary *districtDict;
@property(nonatomic, assign) NSInteger allCinemasNum;
@property(nonatomic, assign) BOOL refreshed;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) UITableView *cinemaTable;

- (void)updateLayout;

@end
