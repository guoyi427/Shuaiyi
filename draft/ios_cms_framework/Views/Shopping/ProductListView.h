//
//  ProductListView.h
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
@protocol ProductListViewDelegate <NSObject>

- (void)ProductListViewDicts:(NSArray *)dictArray;

@end

@interface ProductListView : UIView<UITableViewDelegate, UITableViewDataSource, ProductCellDelegate>{
    UITableView *productTableView;
    UIControl   *_overlayView;

}

@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *selectProductList;

@property (nonatomic, weak) id<ProductListViewDelegate> delegate;

- (void)updateLayout;
- (void)show;
- (void)dismiss;

@end
