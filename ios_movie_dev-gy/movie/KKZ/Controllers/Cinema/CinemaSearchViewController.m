//
//  影院搜索页面
//
//  Created by KKZ on 15/12/9.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaSearchViewController.h"

#import "AlertViewY.h"
#import "CinemaDetail.h"
#import "CinemaCellLayout.h"
#import "CinemaTicketViewController.h"
#import "KKZKeyboardTopView.h"
#import "NewCinemaCell.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import "NoDataViewY.h"
#import "CinemaRequest.h"

@implementation CinemaSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.isFromCinema) {
        [self refreshCinemaList];
    }
    self.view.backgroundColor = [UIColor r:245 g:245 b:245];
    searchFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, self.contentPositionY + 44)];
    searchFieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchFieldView];

    searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 48, self.contentPositionY, 44, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor r:153 g:153 b:153] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(refreshSearchList) forControlEvents:UIControlEventTouchUpInside];
    [searchFieldView addSubview:searchBtn];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, self.contentPositionY + 3, 44, 38);
    [backBtn setImage:[UIImage imageNamed:@"blue_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 13)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [searchFieldView addSubview:backBtn];

    searchList = [[NSMutableArray alloc] initWithCapacity:0];
    cinemaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - 44 - self.contentPositionY)];
    cinemaTable.delegate = self;
    cinemaTable.dataSource = self;
    cinemaTable.backgroundColor = [UIColor clearColor];
    cinemaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cinemaTable];
    cinemaTable.hidden = YES;

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];
    nodataView.alertLabelText = @"未搜索到查询的影院";

    searchRecord = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - 44 - self.contentPositionY)];
    [searchRecord setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:searchRecord];

    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(32, self.contentPositionY, screentWith - 46 - 32, 44)];
    m_searchBar.delegate = self;
    [m_searchBar setBackgroundImage:[UIImage imageNamed:@"searchBarViewBg"]];
    m_searchBar.backgroundColor = [UIColor clearColor];
    [m_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarBg"] forState:UIControlStateNormal];
    [searchFieldView addSubview:m_searchBar];

    KKZKeyboardTopView *topView = [[KKZKeyboardTopView alloc] initWithFrame:CGRectMake(0, 0, m_searchBar.frame.size.width, 38)];
    [m_searchBar setInputAccessoryView:topView];

    searchRecordArray = [[NSMutableArray alloc] initWithCapacity:0];
    searchRecordArray = [self readLevelData];

    [searchRecord setContentSize:CGSizeMake(screentWith, (searchRecordArray.count * 40 + 10) > (screentHeight - 44 - self.contentPositionY - 10) ? (searchRecordArray.count * 40 + 10) : (screentHeight - 44 - self.contentPositionY - 10))];

    for (int i = 0; i < searchRecordArray.count; i++) {
        [self addRecordBtnBySearchRecordTitle:searchRecordArray[i] withIndex:i];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setStatusBarDefaultStyle];
}

#pragma mark utilities
- (void)refreshCinemaSearchListWithSearchtext:(NSString *)searchText {
    [cinemaTable setContentOffset:CGPointZero];
    if (self.isTextChange) {
        self.isTextChange = NO;
    } else {
        [self dismissKeyBoard];
    }

    searchRecord.hidden = YES;
    cinemaTable.hidden = NO;

    if (USER_CITY) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        int i = (int) [self.allCinemasListLayout count];
        CinemaDetail *c = [[CinemaDetail alloc] init];
        CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
        for (int j = 0; j < i; j++) {
            cinemaLayout = self.allCinemasListLayout[j];
            c = cinemaLayout.cinema;
            if ([c.cinemaName containsString:searchText]) {
                [dataArray addObject:cinemaLayout];
            }
        }
        searchList = [dataArray mutableCopy];
        [cinemaTable reloadData];

        if (searchList.count == 0) {
            [cinemaTable addSubview:nodataView];
        } else {
            [nodataView removeFromSuperview];
        }
    } else {
        [UIAlertView showAlertView:@"请您先选择城市" buttonText:@"确定"];
    }
}

#pragma mark - Table View Data Source
- (void)configureCell:(NewCinemaCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (searchList.count <= 0) {
        return;
    }
    if (indexPath.row >= searchList.count) {
        return;
    }

    CinemaCellLayout *managedObject = nil;
    managedObject = [searchList objectAtIndex:indexPath.row];
    @try {
        cell.cinemaCellLayout = managedObject;
        [cell updateCinemaCell];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";

    NewCinemaCell *cell = (NewCinemaCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NewCinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CinemaCellLayout *managedObject = nil;
    managedObject = [searchList objectAtIndex:indexPath.row];
    return managedObject.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissKeyBoard];

    //统计事件：【购票】影院入口-进入影院页
    StatisEvent(EVENT_BUY_CHOOSE_CINEMA_SOURCE_CINEMA);

    if (!appDelegate.isAuthorized) {
        self.isCinema = YES;
    }

    CinemaCellLayout *cinemaLayout = [searchList objectAtIndex:indexPath.row];
    CinemaDetail *cinema = cinemaLayout.cinema;

    CinemaTicketViewController *ticket = [[CinemaTicketViewController alloc] init];
    ticket.cinemaName = cinema.cinemaName;
    ticket.cinemaAddress = cinema.cinemaAddress;
    ticket.cinemaId = cinema.cinemaId;
    ticket.cinemaCloseTicketTime = cinema.closeTicketTime.stringValue;
    ticket.cinemaDetail = cinema;
    [self pushViewController:ticket
                     animation:CommonSwitchAnimationBounce];
}

- (void)dismissKeyBoard {
    [m_searchBar resignFirstResponder];
}

- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

//搜索历史的展示
- (void)addRecordBtnBySearchRecordTitle:(NSString *)recordTitle withIndex:(int)indexRecord {

    UIView *recordBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + indexRecord * 40, screentWith, 40)];
    [recordBtnBgView setBackgroundColor:[UIColor whiteColor]];
    [searchRecord addSubview:recordBtnBgView];

    UIButton *imgV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imgV setImage:[UIImage imageNamed:@"searchRecordIcon"] forState:UIControlStateNormal];
    [imgV setImageEdgeInsets:UIEdgeInsetsMake(13.5, 8.5, 13.5, 8.5)];
    [recordBtnBgView addSubview:imgV];

    UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, screentWith - 30 - 40, 40)];
    [recordBtn setTitle:recordTitle forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [recordBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [recordBtn addTarget:self action:@selector(recordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 1, screentWith - 40, 1)];
    [bottomLine setBackgroundColor:[UIColor r:216 g:216 b:216]];
    [recordBtn addSubview:bottomLine];
    [recordBtnBgView addSubview:recordBtn];

    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 40, 0, 40, 40)];
    [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
    deleteBtn.tag = indexRecord + 10;
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(13.5, 13.5, 13.5, 13.5)];
    [deleteBtn addTarget:self action:@selector(deleteSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtnBgView addSubview:deleteBtn];
}

- (void)deleteSearchHistory:(UIButton *)btn {
    [searchRecordArray removeObjectAtIndex:btn.tag - 10];
    [self refreshLevelData];
    for (int i = 0; i < searchRecordArray.count; i++) {
        [self addRecordBtnBySearchRecordTitle:searchRecordArray[i] withIndex:i];
    }
}

- (void)recordBtnClicked:(UIButton *)btn {
    m_searchBar.text = btn.titleLabel.text;
    [self refreshCinemaSearchListWithSearchtext:m_searchBar.text];
}

#pragma UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarShouldBeginEditing");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarTextDidBeginEditing");
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarShouldEndEditing");
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *temp = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length) {
        [self saveLevelData:temp];

        NSMutableArray *arr = [NSMutableArray arrayWithArray:searchRecordArray];

        BOOL isSame = NO;

        for (NSString *record in arr) {
            if ([temp isEqualToString:record]) {
                isSame = YES;
                return;
            }
        }

        if (!isSame) {
            if (searchRecordArray.count) {
                [searchRecordArray addObject:temp];
            } else {
                searchRecordArray = [NSMutableArray arrayWithObject:temp];
            }
        }
    }

    //统计事件：搜索影院
    StatisEvent(EVENT_CINEMA_SEARCH);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        searchRecord.hidden = YES;
        cinemaTable.hidden = NO;
        [searchBtn setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];
        searchBtn.userInteractionEnabled = YES;
        self.isTextChange = YES;
        [self refreshCinemaSearchListWithSearchtext:searchText];
    } else {

        [searchRecord setContentSize:CGSizeMake(screentWith, (searchRecordArray.count * 40 + 10) > (screentHeight - 44 - self.contentPositionY - 10) ? (searchRecordArray.count * 40 + 10) : (screentHeight - 44 - self.contentPositionY - 10))];

        for (int i = 0; i < searchRecordArray.count; i++) {
            [self addRecordBtnBySearchRecordTitle:searchRecordArray[i] withIndex:i];
        }

        searchRecord.hidden = NO;
        cinemaTable.hidden = YES;
        [searchBtn setTitleColor:[UIColor r:153 g:153 b:153] forState:UIControlStateNormal];
        searchBtn.userInteractionEnabled = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchRecord.hidden = NO;
    cinemaTable.hidden = YES;
    [self refreshCinemaSearchListWithSearchtext:searchBar.text];
}

- (void)refreshSearchList {
    [self refreshCinemaSearchListWithSearchtext:m_searchBar.text];
}

- (NSString *)getRecordFilePath {
    for (UIView *v in [searchRecord subviews]) {
        if ([v isKindOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"usersearchrecord.plist"];
    return path;
}

- (NSMutableArray *)readLevelData {

    NSString *filePath = [self getRecordFilePath];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return arr;
}

- (void)saveLevelData:(NSString *)searchStr {
    NSMutableArray *newsearchedRecords = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *searchedRecords = [self readLevelData];

    [newsearchedRecords addObjectsFromArray:searchedRecords];

    BOOL isSame = NO;

    for (NSString *recordStr in searchedRecords) {
        if ([searchStr isEqualToString:recordStr]) {
            isSame = YES;
            return;
        }
    }

    if (!isSame) {
        [newsearchedRecords addObjectsFromArray:[NSArray arrayWithObject:searchStr]];
        NSString *path = [self getRecordFilePath];
        BOOL boo = [NSKeyedArchiver archiveRootObject:newsearchedRecords toFile:path];
        DLog(@"储存 bool : %d", boo);
    }
}

- (void)refreshLevelData {

    NSString *path = [self getRecordFilePath];
    BOOL boo = [NSKeyedArchiver archiveRootObject:searchRecordArray toFile:path];
    DLog(@"储存 bool : %d", boo);
}

- (BOOL)showNavBar {
    return NO;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)isNavMainColor {
    return NO;
}

#pragma mark utilities

/**
 请求影院列表
 */
- (void)refreshCinemaList {

    CinemaRequest *request = [[CinemaRequest alloc] init];
    [request requestCinemaList:[NSNumber numberWithInteger:USER_CITY]
            movieID:[NSNumber numberWithInteger:self.movieId]
            beginDate:nil
            endDate:nil
            success:^(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas, NSArray *_Nullable favorCinemas) {

                if (noAlertView.superview) {
                    [noAlertView removeFromSuperview];
                }
                //先数据
                self.cinemas = cinemas;
                NSMutableArray *muArr = [[NSMutableArray alloc] initWithCapacity:self.cinemas.count];
                for (int i = 0; i < self.cinemas.count; i++) {
                    CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
                    cinemaLayout.cinema = self.cinemas[i];
                    [muArr addObject:cinemaLayout];
                }
                self.allCinemasListLayout = [muArr copy];

            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
