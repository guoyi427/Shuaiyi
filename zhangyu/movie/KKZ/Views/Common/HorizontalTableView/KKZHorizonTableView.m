//
//  KKZHorizonTableView.m
//
//  Created by 艾广华 on 16/3/11.
//  Copyright © 2016年 艾广华. All rights reserved.
//

#import "KKZHorizonCollectionViewCell.h"
#import "KKZHorizonTableView.h"
#import "KKZUtility.h"

#define REUSE_IDENTIFIER @"reuseIdentifier"

@interface KKZHorizonTableView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  每个Item的宽度数组
 */
@property (nonatomic, strong) NSMutableArray *itemWidthArray;

/**
 *  是否需要方法标签
 */
@property (nonatomic, assign) BOOL needLargeLabel;

/**
 *  是否需要底部的标签
 */
@property (nonatomic, assign) BOOL needShowBottom;

/**
 *  当前选择的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation KKZHorizonTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)updateLayout {
    //计算表格的数据的尺寸
    [self.itemWidthArray removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i++) {
        UIFont *font = self.labelFont;
        if (self.needLargeLabel) {
            font = self.bigLabelFont;
        }
        NSString *inputString = self.dataSource[i];
        CGSize size = [KKZUtility customTextSize:font
                                            text:inputString
                                            size:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
        [self.itemWidthArray addObject:[NSString stringWithFormat:@"%f", size.width + 3]];
    }
    [self.listCollectionView reloadData];
    if (self.itemWidthArray.count > self.currentIndex) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:self.currentIndex
                                                     inSection:0];
        [self collectionView:self.listCollectionView
                didSelectItemAtIndexPath:indexpath];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKZHorizonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.iconLbel.text = self.dataSource[indexPath.row];
    cell.iconLbel.font = self.labelFont;
    cell.iconLbel.textColor = self.labelColor;
    cell.showBottomView = FALSE;
    if (self.currentIndex == indexPath.row) {
        cell.iconLbel.textColor = self.clickLabelColor;
        if (self.needLargeLabel) {
            cell.iconLbel.font = self.bigLabelFont;
        } else if (self.needShowBottom) {
            cell.showBottomView = TRUE;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(shouldShowOfferIconAtIndex:)]) {
        cell.showOfferIcon = [self.delegate shouldShowOfferIconAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    [self.listCollectionView reloadData];
    [self.delegate horizonTableView:collectionView
                didSelectRowAtIndex:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemWidthArray.count <= indexPath.row) {
        return CGSizeZero;
    }
    CGFloat width = [self.itemWidthArray[indexPath.row] floatValue];
    
    if ([self.delegate respondsToSelector:@selector(shouldShowOfferIconAtIndex:)]) {
        // 如果有优惠标签，加上标签的宽度
        BOOL shouldShow = [self.delegate shouldShowOfferIconAtIndex:indexPath.row];
        width = shouldShow ? width + 15 : width;
    }
    return CGSizeMake(width, self.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self updateLayout];
}

- (void)setDefaultChooseIndex:(NSInteger)defaultChooseIndex {
    self.currentIndex = defaultChooseIndex;
}

- (NSMutableArray *)itemWidthArray {
    if (!_itemWidthArray) {
        _itemWidthArray = [[NSMutableArray alloc] init];
    }
    return _itemWidthArray;
}

- (UICollectionView *)listCollectionView {
    if (!_listCollectionView) {

        UICollectionViewFlowLayout *flowLauout = [[UICollectionViewFlowLayout alloc] init];
        flowLauout.minimumLineSpacing = self.itemSpacing;
        flowLauout.minimumInteritemSpacing = self.itemSpacing;
        flowLauout.estimatedItemSize = CGSizeMake(10, 10);
        [flowLauout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        CGRect listFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _listCollectionView = [[UICollectionView alloc] initWithFrame:listFrame
                                                 collectionViewLayout:flowLauout];
        _listCollectionView.backgroundColor = [UIColor clearColor];
        _listCollectionView.showsHorizontalScrollIndicator = FALSE;
        _listCollectionView.showsVerticalScrollIndicator = NO;
        _listCollectionView.delegate = self;
        _listCollectionView.dataSource = self;
        [_listCollectionView registerClass:[KKZHorizonCollectionViewCell class]
                forCellWithReuseIdentifier:REUSE_IDENTIFIER];
    }
    return _listCollectionView;
}

- (BOOL)needLargeLabel {
    return [self.delegate horizonTableViewNeedToEnlargeTheTitleLabelOnClickLabel];
}

- (BOOL)needShowBottom {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizonTableViewNeedToShowBottomViewOnClickLabel)]) {
        return [self.delegate horizonTableViewNeedToShowBottomViewOnClickLabel];
    }
    return FALSE;
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    [self addSubview:self.listCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect listFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _listCollectionView.frame = listFrame;
}

- (CGFloat)tableViewWidth {
    CGFloat totalWidth = 0.0f;
    for (int i = 0; i < self.itemWidthArray.count; i++) {
        CGFloat itemWidth = [self.itemWidthArray[i] floatValue];
        totalWidth += itemWidth;
        if (i != self.itemWidthArray.count - 1) {
            totalWidth += self.itemSpacing;
        }
    }
    return totalWidth;
}

@end
