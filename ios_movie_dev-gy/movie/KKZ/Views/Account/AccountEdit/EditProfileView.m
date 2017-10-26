//
//  EditProfileView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileView.h"
#import "EditAvatarCell.h"
#import "EditTitleCell.h"
#import "EditTextCell.h"
#import "EditHeadingTitleCell.h"
#import "EditProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "NicknameViewController.h"
#import "KKZUtility.h"
#import "EditProfileDataModel.h"
#import "EditProfileBirthChooseView.h"
#import "EditProfileChooseView.h"
#import "DditMutipleChooseView.h"
#import "CityListNewViewController.h"
#import "AccountRequest.h"
#import "PasswordChangeViewController.h"
#import "DataEngine.h"

/*****************cell的布局****************/
static const CGFloat tableHeaderHeight = 15.0f;
static const CGFloat tableFooterHeight = 15.0f;

typedef enum : NSInteger {
    cellTypeProfile,
    cellTypeSubtitle,
    cellTypeText,
    cellTypeHeadingTitle,
    cellTypeSubtitleNoArrow,
} cellType;

typedef enum : NSInteger {
    commonPickerChooseGender,
    commonPickerChooseHeight,
    commonPickerChooseWeight,
    commonPickerChooseRegion,
    commonPickerChooseJob,
    commonPickerChooseHobby,
    commonPickerChooseMovieType,
} commonPickerChooseType;

typedef enum : NSInteger {
    postDataMovieType,
    postDataHobbyType,
    postDataJobType,
    postDataWeightType,
    postDataHeightType,
    postDataRegionType,
    postDataBirthType,
    postDataGenderType,
} postDataType;

typedef enum : NSUInteger {
    photoCellIndex = 0,
    loginPassCellIndex,
    nickNameCellIndex,
    genderCellIndex,
    birthCellIndex,
    heightCellIndex,
    weightCellIndex,
    regionCellIndex,
    occupationCellIndex,
    hobbyCellIndex,
    oftenCinemaCellIndex,
    movieTypeCellIndex,
    signatureCellIndex,
    userIdCellIndex,
} titleCellIndex;

@interface EditProfileView () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CityListViewControllerDelegate>
{
    UserInfo *_userInfo;
}

/**
 *  表视图
 */
@property (nonatomic, strong) UITableView *listTable;

/**
 *  表视图表头
 */
@property (nonatomic, strong) UIView *tableHeaderView;

/**
 *  表视图表尾
 */
@property (nonatomic, strong) UIView *tableFooterView;

/**
 *  主标题
 */
@property (nonatomic, strong) NSMutableArray *titleArray;

/**
 *  cell类型
 */
@property (nonatomic, strong) NSMutableArray *typeArray;

/**
 *  副标题
 */
@property (nonatomic, strong) NSMutableArray *detailTitleArray;

/**
 *  cell的布局类
 */
@property (nonatomic, strong) EditProfileLayout *editProfileLayout;

/**
 *  当前视图的控制器
 */
@property (nonatomic, weak) EditProfileViewController *controller;

/**
 *  生日选择视图
 */
@property (nonatomic, strong) EditProfileBirthChooseView *editProfileBirthChooseView;

/**
 *  公共的选择视图
 */
@property (nonatomic, strong) EditProfileChooseView *editProfileChooseView;

/**
 *  多选选择视图
 */
@property (nonatomic, strong) DditMutipleChooseView *mutipleChooseView;

/**
 *  多选选择视图
 */
@property (nonatomic, assign) commonPickerChooseType commonChooseType;

/**
 *  当前选择Cell行的索引
 */
@property (nonatomic, assign) NSInteger selectRowIndex;

/**
 *  数据的字符串
 */
@property (nonatomic, strong) NSString *dataString;

/**
 *  城市ID
 */
@property (nonatomic, strong) NSString *city_Id;

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *userAvatar;

/**
 *  修改密码对应的Cell索引
 */
@property (nonatomic, assign) NSInteger editPassIndex;

@end

@implementation EditProfileView

- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        //当前视图的控制器
        self.controller = (EditProfileViewController *) controller;
        //登录密码索引
        self.editPassIndex = 2;
        //添加表视图
        [self addSubview:self.listTable];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    cellType type = [self.typeArray[indexPath.row] integerValue];
    if (type == cellTypeProfile) {
        static NSString *ProfileIdentifier = @"ProfileCellIdentifier";
        //头像
        EditAvatarCell *cell = (EditAvatarCell *) [tableView dequeueReusableCellWithIdentifier:ProfileIdentifier];
        if (cell == nil) {
            cell = [[EditAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:ProfileIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        if ([self.detailTitleArray[indexPath.row] isKindOfClass:[NSString class]]) {
            NSURL *headimg = [NSURL URLWithString:[DataEngine sharedDataEngine].headImg];
            [cell.avatarImgV sd_setImageWithURL:headimg
                               placeholderImage:cell.defaultImg];
        } else {
            cell.avatarImg = self.detailTitleArray[indexPath.row];
        }
        cell.titleStr = self.titleArray[indexPath.row];
        return cell;
    } else if (type == cellTypeSubtitle || type == cellTypeSubtitleNoArrow) {
        static NSString *SubtitleIdentifier = @"SubtitleCellIdentifier";
        EditTitleCell *cell = (EditTitleCell *) [tableView dequeueReusableCellWithIdentifier:SubtitleIdentifier];
        if (cell == nil) {
            cell = [[EditTitleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:SubtitleIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (type == cellTypeSubtitleNoArrow) {
            cell.arrowHidden = YES;
        } else {
            cell.arrowHidden = NO;
        }
        cell.titleStr = self.titleArray[indexPath.row];
        cell.detailTitleStr = self.detailTitleArray[indexPath.row];
        return cell;
    } else if (type == cellTypeText) {
        static NSString *TextIdentifier = @"TextCellIdentifier";
        EditTextCell *cell = (EditTextCell *) [tableView dequeueReusableCellWithIdentifier:TextIdentifier];
        if (cell == nil) {
            cell = [[EditTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:TextIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.titleStr = self.titleArray[indexPath.row];
        cell.detailTitleStr = self.detailTitleArray[indexPath.row];
        cell.layout = self.editProfileLayout;
        return cell;
    } else if (type == cellTypeHeadingTitle) {
        static NSString *HeadingIdentifier = @"HeadingCellIdentifier";
        EditHeadingTitleCell *cell = (EditHeadingTitleCell *) [tableView dequeueReusableCellWithIdentifier:HeadingIdentifier];
        if (cell == nil) {
            cell = [[EditHeadingTitleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:HeadingIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.titleStr = self.titleArray[indexPath.row];
        cell.headingStr = @"补充一下资料可以提高人气哦~";
        cell.detailTitleStr = self.detailTitleArray[indexPath.row];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellType type = [self.typeArray[indexPath.row] integerValue];
    if (type == cellTypeProfile) {
        return [EditAvatarCell cellHeight];
    } else if (type == cellTypeSubtitle || type == cellTypeSubtitleNoArrow) {
        return 50.0f;
    } else if (type == cellTypeHeadingTitle) {
        return 93.0f;
    }
    return self.editProfileLayout.textCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self indexOfTitleCellWithCellIndex:photoCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:photoCellIndex];
        [self.profileViewModel didSelectRowAtRowNum:indexPath.row];
        [self.profileViewModel setBlockMethod:^(NSObject *o) {
            [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:photoCellIndex]
                                             withObject:(UIImage *) o];
            [self.listTable reloadData];
        }];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:nickNameCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:nickNameCellIndex];
        [self chooseNickNameWithType:NickNameViewType];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:genderCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:genderCellIndex];
        [self chooseDataWithType:commonPickerChooseGender];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:birthCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:birthCellIndex];
        if ([KKZUtility stringIsEmpty:self.detailTitleArray[[self indexOfTitleCellWithCellIndex:birthCellIndex]]]) {
            [self chooseBirth];
        }
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:heightCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:heightCellIndex];
        [self chooseDataWithType:commonPickerChooseHeight];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:weightCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:weightCellIndex];
        [self chooseDataWithType:commonPickerChooseWeight];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:regionCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:regionCellIndex];
        [self chooseRegion];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:occupationCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:occupationCellIndex];
        [self chooseDataWithType:commonPickerChooseJob];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:hobbyCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:hobbyCellIndex];
        [self chooseMutipleWithType:commonPickerChooseHobby];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:oftenCinemaCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:oftenCinemaCellIndex];
        [self chooseNickNameWithType:TheaterViewType];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:movieTypeCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:movieTypeCellIndex];
        [self chooseMutipleWithType:commonPickerChooseMovieType];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:signatureCellIndex]) {
        self.selectRowIndex = [self indexOfTitleCellWithCellIndex:signatureCellIndex];
        [self chooseNickNameWithType:SignatureViewType];
    } else if (indexPath.row == [self indexOfTitleCellWithCellIndex:loginPassCellIndex]) {
        PasswordChangeViewController *pass = [[PasswordChangeViewController alloc] init];
        CommonViewController *controller = [KKZUtility getRootNavagationLastTopController];
        [controller pushViewController:pass
                             animation:CommonSwitchAnimationBounce];
    }
}

- (void)chooseCityWithName:(NSString *)cityName
                withCityId:(NSString *)cityId {
    self.city_Id = cityId;
    [self loadPostRequest:cityName
                   withType:postDataRegionType];
}

- (void)chooseNickNameWithType:(ViewType)viewType {
    NickNameViewController *ctr = [[NickNameViewController alloc] init];
    NSInteger index = 0;
    if (viewType == NickNameViewType) {
        index = [self indexOfTitleCellWithCellIndex:nickNameCellIndex];
    } else if (viewType == TheaterViewType) {
        index = [self indexOfTitleCellWithCellIndex:oftenCinemaCellIndex];
    } else if (viewType == SignatureViewType) {
        index = [self indexOfTitleCellWithCellIndex:signatureCellIndex];
    }
    ctr.userName = self.detailTitleArray[index];
    ctr.changeFinished = ^(NSString *content) {
        [self.detailTitleArray replaceObjectAtIndex:index
                                         withObject:content];
        if (viewType == SignatureViewType) {
            self.userInfo.signature = content;
            [self.editProfileLayout caculationLayoutFrame:self.userInfo];
        }
        [self.listTable reloadData];
    };
    ctr.viewType = viewType;
    [self.controller pushViewController:ctr
                              animation:CommonSwitchAnimationBounce];
}

- (void)chooseBirth {
    __weak EditProfileView *weak_self = self;
    [self.editProfileBirthChooseView setMethodBlock:^(NSObject *o) {
        [weak_self chooseBirthWithString:(NSString *) o];
        [weak_self loadPostRequest:weak_self.detailTitleArray[[weak_self indexOfTitleCellWithCellIndex:birthCellIndex]]
                          withType:postDataBirthType];
    }];
    if (self.userInfo.month > 0 && self.userInfo.day > 0) {
        NSString *date = [NSString stringWithFormat:@"%@-%@", self.userInfo.month, self.userInfo.day];
        self.editProfileBirthChooseView.dateString = date;
    }
    [self.editProfileBirthChooseView show];
}


/**
 设置生日

 @param string 日期 yyyy-MM-dd
 */
- (void)chooseBirthWithString:(NSString *)string {

    //拼接合成字符串数据
    NSArray *dataArr = [string componentsSeparatedByString:@"-"];
    if (dataArr.count < 2) {
        return;
    }
    int month = [dataArr[1] intValue];
    int day = [dataArr[2] intValue];
    self.userInfo.month = [NSNumber numberWithInt:month];
    self.userInfo.day = [NSNumber numberWithInt:day];
    NSString *astro = [KKZUtility getAstroWithMonth:month
                                                day:day];
    NSString *finalString = [NSString stringWithFormat:@"%02d月%02d日 %@座", month, day, astro];
    [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:birthCellIndex]
                                     withObject:finalString];
    [self.listTable reloadData];
}

- (void)chooseDataWithType:(commonPickerChooseType)type {
    self.commonChooseType = type;
    __weak EditProfileView *weak_self = self;
    [self.editProfileChooseView setMethodBlock:^(NSObject *o) {
        if (weak_self.commonChooseType == commonPickerChooseJob) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataJobType];
        } else if (weak_self.commonChooseType == commonPickerChooseWeight) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataWeightType];
        } else if (weak_self.commonChooseType == commonPickerChooseHeight) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataHeightType];
        } else if (weak_self.commonChooseType == commonPickerChooseGender) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataGenderType];
        }
    }];
    self.editProfileChooseView.dataString = self.detailTitleArray[self.selectRowIndex];
    if (type == commonPickerChooseHeight) {
        self.editProfileChooseView.commonTitleItemString = @"身高";
        self.editProfileChooseView.dataArr = [EditProfileDataModel heightArray];
    } else if (type == commonPickerChooseWeight) {
        self.editProfileChooseView.commonTitleItemString = @"体重";
        self.editProfileChooseView.dataArr = [EditProfileDataModel weightArray];
    } else if (type == commonPickerChooseJob) {
        self.editProfileChooseView.commonTitleItemString = @"职业";
        self.editProfileChooseView.dataArr = [EditProfileDataModel jobArray];
    } else if (type == commonPickerChooseGender) {
        self.editProfileChooseView.commonTitleItemString = @"性别";
        self.editProfileChooseView.dataArr = [EditProfileDataModel genderArray];
    }
    [self.editProfileChooseView show];
}

- (void)chooseRegion {
    CityListNewViewController *ctr = [[CityListNewViewController alloc] init];
    ctr.delegate = self;
    [self.controller pushViewController:ctr
                              animation:CommonSwitchAnimationBounce];
}

- (void)chooseMutipleWithType:(commonPickerChooseType)type {
    __weak EditProfileView *weak_self = self;
    if (type == commonPickerChooseMovieType) {
        self.mutipleChooseView.mutipleDataArr = [EditProfileDataModel movieTypeArray];
    } else if (type == commonPickerChooseHobby) {
        self.mutipleChooseView.mutipleDataArr = [EditProfileDataModel hobbyArray];
    }
    self.commonChooseType = type;
    [self.mutipleChooseView setMethodBlock:^(NSObject *o) {
        if (weak_self.commonChooseType == commonPickerChooseMovieType) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataMovieType];
        } else if (weak_self.commonChooseType == commonPickerChooseHobby) {
            [weak_self loadPostRequest:(NSString *) o
                              withType:postDataHobbyType];
        }
    }];
    self.mutipleChooseView.chooseDataString = self.detailTitleArray[self.selectRowIndex];
    [self.mutipleChooseView show];
}

- (void)loadPostRequest:(NSString *)string
               withType:(postDataType)type {

    //如果传过来的字符串为空直接返回
    if ([KKZUtility stringIsEmpty:string]) {
        [self chooseCommonDataWithString:string];
        return;
    }

    //设置传过来的数据源
    self.dataString = string;

    //加载框
    [self showIndicator];

    //网络请求
    AccountRequest *request = [[AccountRequest alloc] init];
    if (type == postDataMovieType) {
        [request startPostHobbyMovieType:string
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataHobbyType) {
        [request startPostHobby:string
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataJobType) {
        [request startPostJob:string
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataWeightType) {
        NSString *subStr = [string substringToIndex:string.length - 2];
        [request startPostWeight:subStr
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataHeightType) {
        NSString *subStr = [string substringToIndex:string.length - 2];
        [request startPostHeight:subStr
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataRegionType) {
        [request startPostCity_Id:self.city_Id
                City_Name:string
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataBirthType) {
        NSString *month = [self.userInfo.month stringValue];
        NSString *day = [self.userInfo.day stringValue];
        [request startPostBirthYear:nil
                month:month
                day:day
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    } else if (type == postDataGenderType) {
        NSString *index = [EditProfileDataModel getGenderIndex:string];
        [request startgender:index
                Sucuess:^() {
                    [self updateProfileRequestSuccess];
                }
                Fail:^(NSError *o) {
                    [self updateProfileRequestFail];
                }];
    }
}

- (void)updateProfileRequestSuccess {
    [self chooseCommonDataWithString:self.dataString];
    [self hidenIndicator];
}

- (void)updateProfileRequestFail {
    [KKZUtility showAlert:@"提交失败,请重试"];
    [self hidenIndicator];
}

- (void)hidenIndicator {
    [KKZUtility hidenIndicator];
}

- (void)showIndicator {
    [KKZUtility showIndicatorWithTitle:@"正在加载"
                                atView:self.controller.view];
}

- (void)chooseCommonDataWithString:(NSString *)string {
    NSInteger hobby = [self indexOfTitleCellWithCellIndex:hobbyCellIndex];
    NSInteger movieType = [self indexOfTitleCellWithCellIndex:movieTypeCellIndex];
    if (self.selectRowIndex == hobby || self.selectRowIndex == movieType) {
        string = [string stringByReplacingOccurrencesOfString:@","
                                                   withString:@"、"];
    }
    [self.detailTitleArray replaceObjectAtIndex:self.selectRowIndex
                                     withObject:string];
    [self.listTable reloadData];
}

- (UITableView *)listTable {
    if (!_listTable) {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.backgroundColor = [UIColor clearColor];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTable.tableHeaderView = self.tableHeaderView;
        _listTable.tableFooterView = self.tableFooterView;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.showsHorizontalScrollIndicator = NO;
    }
    return _listTable;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"用户ID", @"头像", @"昵称", @"性别", @"生日", @"身高", @"体重", @"所在地", @"职业", @"爱好", @"常去影院", @"喜欢的影片类型", @"签名", nil];
        if (USER_LOGIN_PHONE) {
            [_titleArray insertObject:@"登录密码"
                              atIndex:self.editPassIndex];
        }
    }
    return _titleArray;
}

- (NSInteger)indexOfTitleCellWithCellIndex:(NSInteger)cellIndex {
    if (cellIndex == userIdCellIndex) {
        return [self.titleArray indexOfObject:self.titleArray[0]];
    } else if (cellIndex == photoCellIndex) {
        return [self.titleArray indexOfObject:self.titleArray[1]];
    } else if (cellIndex == nickNameCellIndex) {
        return [self.titleArray indexOfObject:@"昵称"];
    } else if (cellIndex == genderCellIndex) {
        return [self.titleArray indexOfObject:@"性别"];
    } else if (cellIndex == loginPassCellIndex) {
        return [self.titleArray indexOfObject:@"登录密码"];
    } else if (cellIndex == birthCellIndex) {
        return [self.titleArray indexOfObject:@"生日"];
    } else if (cellIndex == heightCellIndex) {
        return [self.titleArray indexOfObject:@"身高"];
    } else if (cellIndex == weightCellIndex) {
        return [self.titleArray indexOfObject:@"体重"];
    } else if (cellIndex == regionCellIndex) {
        return [self.titleArray indexOfObject:@"所在地"];
    } else if (cellIndex == occupationCellIndex) {
        return [self.titleArray indexOfObject:@"职业"];
    } else if (cellIndex == hobbyCellIndex) {
        return [self.titleArray indexOfObject:@"爱好"];
    } else if (cellIndex == oftenCinemaCellIndex) {
        return [self.titleArray indexOfObject:@"常去影院"];
    } else if (cellIndex == movieTypeCellIndex) {
        return [self.titleArray indexOfObject:@"喜欢的影片类型"];
    } else if (cellIndex == photoCellIndex) {
        return [self.titleArray indexOfObject:@"头像"];
    }
    return [self.titleArray indexOfObject:@"签名"];
}

- (NSMutableArray *)typeArray {
    if (!_typeArray) {
        _typeArray = [[NSMutableArray alloc] initWithObjects:@(cellTypeSubtitleNoArrow), @(cellTypeProfile), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeHeadingTitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeSubtitle), @(cellTypeText), nil];
        if (USER_LOGIN_PHONE) {
            [_typeArray insertObject:@(cellTypeSubtitle)
                             atIndex:self.editPassIndex];
        }
    }
    return _typeArray;
}

- (NSMutableArray *)detailTitleArray {
    if (!_detailTitleArray) {
        _detailTitleArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < _titleArray.count; i++) {
            if (i == 0) {
                [_detailTitleArray addObject:[DataEngine sharedDataEngine].userId];
            } else {
                [_detailTitleArray addObject:@""];
            }
        }
        if (USER_LOGIN_PHONE) {
            [_detailTitleArray insertObject:@"修改"
                                    atIndex:self.editPassIndex];
        }
    }
    return _detailTitleArray;
}

- (EditProfileLayout *)editProfileLayout {
    if (!_editProfileLayout) {
        _editProfileLayout = [[EditProfileLayout alloc] init];
    }
    return _editProfileLayout;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, tableHeaderHeight)];
        _tableHeaderView.backgroundColor = CELL_BACKGROUND_COLOR;
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, tableFooterHeight)];
        _tableFooterView.backgroundColor = CELL_BACKGROUND_COLOR;
    }
    return _tableFooterView;
}

- (EditProfileBirthChooseView *)editProfileBirthChooseView {
    if (!_editProfileBirthChooseView) {
        _editProfileBirthChooseView = [[EditProfileBirthChooseView alloc] initWithFrame:kCommonScreenBounds];
        _editProfileBirthChooseView.titleItemString = @"生日";
    }
    return _editProfileBirthChooseView;
}

- (EditProfileChooseView *)editProfileChooseView {
    if (!_editProfileChooseView) {
        _editProfileChooseView = [[EditProfileChooseView alloc] initWithFrame:kCommonScreenBounds];
    }
    return _editProfileChooseView;
}

- (DditMutipleChooseView *)mutipleChooseView {
    if (!_mutipleChooseView) {
        _mutipleChooseView = [[DditMutipleChooseView alloc] initWithFrame:kCommonScreenBounds];
    }
    return _mutipleChooseView;
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;

    //计算布局
    [self.editProfileLayout caculationLayoutFrame:self.userInfo];

    //签名
    if (self.userInfo.signature) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:signatureCellIndex]
                                         withObject:self.userInfo.signature];
    }

    //个人头像
    if (self.userInfo.headImg) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:photoCellIndex]
                                         withObject:self.userInfo.headImg];
    }

    //昵称
    if (self.userInfo.nickName) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:nickNameCellIndex]
                                         withObject:self.userInfo.nickName];
    }

    //性别
    if (self.userInfo.sex.integerValue >= 0) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:genderCellIndex]
                                         withObject:[EditProfileDataModel getGenderStringByIndex:self.userInfo.sex.intValue]];
    }

    //生日
    if (userInfo.month  && userInfo.day) {
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@", self.userInfo.year,self.userInfo.month, self.userInfo.day];
        [self chooseBirthWithString:date];
    }

    //身高
    if (self.userInfo.height.integerValue > 0) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:heightCellIndex]
                                         withObject:[NSString stringWithFormat:@"%@cm", self.userInfo.height.stringValue]];
    }

    //体重
    if (self.userInfo.weight.integerValue > 0) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:weightCellIndex]
                                         withObject:[NSString stringWithFormat:@"%@kg", self.userInfo.weight.stringValue]];
    }

    //所在地
    if (self.userInfo.cityName) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:regionCellIndex]
                                         withObject:self.userInfo.cityName];
    }

    //职业
    if (self.userInfo.job) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:occupationCellIndex]
                                         withObject:self.userInfo.job];
    }

    //爱好
    if (self.userInfo.hobby) {
        NSString *hobby = self.userInfo.hobby;
        hobby = [hobby stringByReplacingOccurrencesOfString:@","
                                                 withString:@"、"];
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:hobbyCellIndex]
                                         withObject:hobby];
    }

    //常去影院
    if (self.userInfo.oftenCinema) {
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:oftenCinemaCellIndex]
                                         withObject:self.userInfo.oftenCinema];
    }

    //喜欢的影片类型
    if (self.userInfo.hobbyMovieType) {
        NSString *hobby = self.userInfo.hobbyMovieType;
        hobby = [hobby stringByReplacingOccurrencesOfString:@","
                                                 withString:@"、"];
        [self.detailTitleArray replaceObjectAtIndex:[self indexOfTitleCellWithCellIndex:movieTypeCellIndex]
                                         withObject:hobby];
    }

    [_listTable reloadData];
}

- (UserInfo *) userInfo
{
    if (_userInfo == nil) {
        _userInfo = [UserInfo new];
    }
    
    return _userInfo;
}
@end
