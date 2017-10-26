//
//  影院列表按照城区筛选的View
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "VerticalCinemaPickerView.h"


#import "City.h"
#import "Constants.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "LocationEngine.h"
#import "TaskQueue.h"
#import "UIViewControllerExtra.h"
#import "UserDefault.h"

@interface VerticalCinemaPickerView ()

@end

@implementation VerticalCinemaPickerView

@synthesize cinemaTable;
@synthesize delegate;
@synthesize selectedDistrictName;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor r:242 g:242 b:242];

        selectedSection = -1;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor r:51 g:51 b:51];
        titleLabel.text = @"城区";
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];

        cinemaTable = [[UITableView alloc] initWithFrame:CGRectMake(110, 0, screentWith - 110, 337) style:UITableViewStylePlain];
        cinemaTable.delegate = self;
        cinemaTable.dataSource = self;
        cinemaTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cinemaTable.showsVerticalScrollIndicator = NO;
        cinemaTable.backgroundColor = [UIColor whiteColor];

        [self addSubview:cinemaTable];

        tableLocked = NO;

        _districtList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)updateLayout {

    [cinemaTable reloadData];
}

#pragma mark - Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, cell.frame.size.width, cell.frame.size.height - 2)];
        UIView *selTopLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, screentWith - 10 * 2, 1)];
        [selTopLine setBackgroundColor:[UIColor r:224 g:224 b:224]];
        [selectedView addSubview:selTopLine];

        UIView *selBottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, 40 - 1, screentWith - 10 * 2, 1)];
        [selBottomLine setBackgroundColor:[UIColor r:224 g:224 b:224]];
        [selectedView addSubview:selBottomLine];

        cell.selectedBackgroundView = selectedView;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"全部(%ld家)", (long) self.allCinemasNum];
        } else {
            NSString *name = [self.districtList objectAtIndex:indexPath.row - 1];
            NSInteger num = [[self.districtDict objectForKey:[self.districtList objectAtIndex:indexPath.row - 1]] integerValue];

            cell.textLabel.text = [NSString stringWithFormat:@"%@(%lu家)", name, (long) num];
        }

        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor r:51 g:51 b:51];
        cell.textLabel.highlightedTextColor = [UIColor r:255 g:105 b:0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.districtList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectDistrictName:indexPath.row];
}

@end
