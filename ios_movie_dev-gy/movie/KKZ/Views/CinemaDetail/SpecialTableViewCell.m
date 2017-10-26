//
//  影院详情页面特色信息的Cell
//
//  Created by 艾广华 on 15/12/9.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SpecialTableViewCell.h"

#import "CinemaFeature.h"
#import "CinemaSpecialInfoView.h"
#import "KKZUtility.h"
#import "PSListCollectionViewCell.h"
#import "UIConstants.h"
#import "UIImageView+WebCache.h"

#define REUSE_IDENTIFIER @"reuseIdentifier"

/****************分割线********************/
const static CGFloat lineViewTop = 39.0f;
const static CGFloat lineViewHeight = 1.0f;

@interface SpecialTableViewCell () <UICollectionViewDelegateFlowLayout,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate> {

  //显示显示的表视图
  UICollectionView *listCollectionView;

  //表视图尺寸
  CGRect listCollectionFrame;

  //白色背景视图
  UIView *whiteView;
}

/**
 *  分割线视图
 */
@property(nonatomic, strong) UIView *lineView;

@end

@implementation SpecialTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {

    //添加白色背景视图
    whiteView = [[UIView alloc] initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];

    //添加分割线
    [whiteView addSubview:self.lineView];

    //添加横向滚动列表布局
    listCollectionFrame = CGRectMake(15.0f, 14.0f, screentWith - 15.0f, 62.0f);
    UICollectionViewFlowLayout *flowLauout =
        [[UICollectionViewFlowLayout alloc] init];
    flowLauout.minimumLineSpacing = 20;
    flowLauout.sectionInset = UIEdgeInsetsZero;
    flowLauout.itemSize = CGSizeMake(50.0f, 62.0f);
    [flowLauout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    //添加横向滚动列表
    listCollectionView =
        [[UICollectionView alloc] initWithFrame:listCollectionFrame
                           collectionViewLayout:flowLauout];
    listCollectionView.backgroundColor = [UIColor clearColor];
    listCollectionView.showsHorizontalScrollIndicator = FALSE;
    listCollectionView.delegate = self;
    listCollectionView.dataSource = self;
    [self addSubview:listCollectionView];

    [listCollectionView registerClass:[PSListCollectionViewCell class]
           forCellWithReuseIdentifier:REUSE_IDENTIFIER];
  }
  return self;
}

- (void)layoutSubviews {
  whiteView.frame =
      CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  listCollectionView.frame = listCollectionFrame;
  CGRect lineFrame = self.lineView.frame;
  lineFrame.origin.y = self.frame.size.height - lineViewHeight;
  self.lineView.frame = lineFrame;
}

#pragma mark - setter Method

- (void)setDataSource:(NSArray *)dataSource {
  _dataSource = dataSource;
  [listCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  CinemaFeature *feature = self.dataSource[indexPath.row];

  CinemaSpecialInfoView *infoview = [[CinemaSpecialInfoView alloc]
      initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)
           withInfo:feature.title];
  [infoview show];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PSListCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER
                                                forIndexPath:indexPath];
  cell.backgroundColor = [UIColor clearColor];
  CinemaFeature *feature = self.dataSource[indexPath.row];
  [cell.icomImgV sd_setImageWithURL:[NSURL URLWithString:feature.icon]];
  cell.iconLbel.text = feature.title;
  return cell;
}

- (UIView *)lineView {
  if (!_lineView) {
    _lineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, lineViewTop, kCommonScreenWidth,
                                 lineViewHeight)];
    _lineView.backgroundColor = kDividerColor;
  }
  return _lineView;
}

@end
