//
//  DditMutipleChooseView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DditMutipleChooseView.h"
#import "EditMutipleChooseCell.h"

typedef enum : NSUInteger {
    cancelButtonTag = 2000,
    completeButtonTag,
} allButtonTag;

@interface DditMutipleChooseView () <UITableViewDataSource, UITableViewDelegate>

/**
 *  透明的视图
 */
@property (nonatomic, strong) UIView *clearView;
/**
 *  工具条
 */
@property (nonatomic, strong) UIView *toolBar;
/**
 *  工具条上分割线
 */
@property (nonatomic, strong) UIView *topDivider;
/**
 *  工具条下分割线
 */
@property (nonatomic, strong) UIView *bottomDivider;
/**
 *  工具条左边按钮
 */
@property (nonatomic, strong) UIButton *leftItem;
/**
 *  工具条右边按钮
 */
@property (nonatomic, strong) UIButton *rightItem;
/**
 *  工具条的标题
 */
@property (nonatomic, strong) UILabel *titleItem;

/**
 *  表视图
 */
@property (nonatomic, strong) UITableView *listTable;

/**
 *  cell选中的标识字典
 */
@property (nonatomic, strong) NSMutableDictionary *checksDic;

/**
 *  选择按钮之后的回调
 */
@property (nonatomic, strong) CAll_BACK chooseCallBack;

@end

@implementation DditMutipleChooseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //添加透明视图
        [self addSubview:self.clearView];

        //日期选择器
        [self addSubview:self.listTable];

        //添加工具条
        [self addSubview:self.toolBar];

        //添加工具条按钮
        [self.toolBar addSubview:self.leftItem];
        [self.toolBar addSubview:self.rightItem];
        [self.toolBar addSubview:self.titleItem];

        //添加工具条分割线
        [self.toolBar addSubview:self.topDivider];
        [self.toolBar addSubview:self.bottomDivider];

        UIWindow *widow = [[UIApplication sharedApplication].delegate window];
        [widow addSubview:self];
    }
    return self;
}

- (void)show {

    //显示动画
    [UIView animateWithDuration:0.5f
            animations:^{
                if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    self.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                }
            }
            completion:^(BOOL finished) {
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            }];
}
- (void)close {
    [UIView animateWithDuration:0.5f
            animations:^{
                if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    self.frame = CGRectMake(0, kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
                }
            }
            completion:^(BOOL finished) {
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            }];
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case cancelButtonTag: {
            [self close];
            break;
        }
        case completeButtonTag: {
            if (self.chooseCallBack) {
                NSArray *array = [self.checksDic allKeys];
                _chooseDataString = @"";
                for (int i = 0; i < array.count; i++) {
                    NSInteger index = [array[i] intValue];
                    if (i == 0) {
                        _chooseDataString = [NSString stringWithFormat:@"%@", self.mutipleDataArr[index]];
                    } else {
                        _chooseDataString = [NSString stringWithFormat:@"%@,%@", _chooseDataString, self.mutipleDataArr[index]];
                    }
                }
                self.chooseCallBack(_chooseDataString);
            }
            [self close];
            break;
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ProfileIdentifier = @"ProfileCellIdentifier";
    //头像
    EditMutipleChooseCell *cell = (EditMutipleChooseCell *) [tableView dequeueReusableCellWithIdentifier:ProfileIdentifier];
    if (cell == nil) {
        cell = [[EditMutipleChooseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ProfileIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.titleStr = self.mutipleDataArr[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld", (long) indexPath.row];
    if ([[self.checksDic valueForKey:key] boolValue]) {
        cell.checked = TRUE;
    } else {
        cell.checked = FALSE;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mutipleDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EditMutipleChooseCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld", (long) indexPath.row];
    BOOL selected = [[self.checksDic valueForKey:key] boolValue];
    selected = !selected;
    if (selected) {
        [self.checksDic setValue:@(selected)
                          forKey:[NSString stringWithFormat:@"%ld", (long) indexPath.row]];
    } else {
        [self.checksDic removeObjectForKey:key];
    }
    [self.listTable reloadData];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _clearView.backgroundColor = [UIColor clearColor];
    }
    return _clearView;
}
- (UIView *)toolBar {
    if (!_toolBar) {
        //工具条
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight - commonPickerHeight - toolBarHeight, kCommonScreenWidth, toolBarHeight)];
        _toolBar.backgroundColor = [UIColor colorWithHex:@"#f6f6f6"];
    }
    return _toolBar;
}

- (UIButton *)leftItem {
    if (!_leftItem) {
        _leftItem = [UIButton buttonWithType:0];
        _leftItem.frame = CGRectMake(0, 0, leftItemLeft * 2 + leftItemWidth, toolBarHeight);
        [_leftItem setTitleColor:[UIColor colorWithHex:@"#999999"]
                        forState:UIControlStateNormal];
        [_leftItem setTitle:@"取消"
                   forState:UIControlStateNormal];
        _leftItem.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_leftItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _leftItem.tag = cancelButtonTag;
        [_leftItem addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItem;
}

- (UIButton *)rightItem {
    if (!_rightItem) {
        _rightItem = [UIButton buttonWithType:0];
        CGFloat width = rightItemRight * 2 + leftItemWidth;
        _rightItem.frame = CGRectMake(kCommonScreenWidth - width, 0, width, toolBarHeight);
        [_rightItem setTitleColor:[UIColor colorWithHex:@"#ff5e00"]
                         forState:UIControlStateNormal];
        [_rightItem setTitle:@"完成"
                    forState:UIControlStateNormal];
        _rightItem.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _rightItem.tag = completeButtonTag;
        [_rightItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_rightItem addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

- (UILabel *)titleItem {
    if (!_titleItem) {
        _titleItem = [[UILabel alloc] initWithFrame:CGRectMake((kCommonScreenWidth - titleItemWidth) / 2.0f, 0, titleItemWidth, toolBarHeight)];
        _titleItem.font = [UIFont systemFontOfSize:17.0f];
        _titleItem.textColor = [UIColor blackColor];
        _titleItem.textAlignment = NSTextAlignmentCenter;
    }
    return _titleItem;
}

- (UIView *)topDivider {
    if (!_topDivider) {
        _topDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, dividerHeight)];
        _topDivider.backgroundColor = [UIColor colorWithHex:@"#d9d9d9"];
    }
    return _topDivider;
}

- (UIView *)bottomDivider {
    if (!_bottomDivider) {
        _bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(0, toolBarHeight - dividerHeight, kCommonScreenWidth, dividerHeight)];
        _bottomDivider.backgroundColor = [UIColor colorWithHex:@"#d9d9d9"];
    }
    return _bottomDivider;
}

- (UITableView *)listTable {
    if (!_listTable) {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight - commonPickerHeight, kCommonScreenWidth, commonPickerHeight) style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.backgroundColor = [UIColor whiteColor];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.showsHorizontalScrollIndicator = NO;
    }
    return _listTable;
}

- (NSMutableDictionary *)checksDic {
    if (!_checksDic) {
        _checksDic = [[NSMutableDictionary alloc] init];
    }
    return _checksDic;
}

- (void)setMutipleDataArr:(NSMutableArray *)mutipleDataArr {
    _mutipleDataArr = mutipleDataArr;
    [self.listTable reloadData];
}

- (void)setMethodBlock:(CAll_BACK)block {
    self.chooseCallBack = block;
}

- (void)setChooseDataString:(NSString *)chooseDataString {
    _chooseDataString = chooseDataString;
    [self.checksDic removeAllObjects];
    NSArray *dataArray = [_chooseDataString componentsSeparatedByString:@"、"];
    for (int i = 0; i < dataArray.count; i++) {
        NSString *dataStr = dataArray[i];
        if ([self.mutipleDataArr containsObject:dataStr]) {
            NSInteger index = [self.mutipleDataArr indexOfObject:dataStr];
            [self.checksDic setValue:@(TRUE)
                              forKey:[NSString stringWithFormat:@"%ld", (long) index]];
        }
    }
    [self.listTable reloadData];
}

@end
