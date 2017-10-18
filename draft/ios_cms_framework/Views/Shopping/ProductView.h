//
//  ProductView.h
//  CIASMovie
//
//  Created by cias on 2017/1/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
@protocol ProductViewDelegate <NSObject>

- (void)delegateShowProductListView;
- (void)ProductViewDicts:(NSArray *)firstDict;

@end

@interface ProductView : UIView<UITableViewDelegate, UITableViewDataSource, ProductCellDelegate>{
    UITableView *productTableView;

    UILabel *titleLabel, *contentLabel;
    UILabel *totalNumLabel;
    UILabel *priceLabel, *productPriceLabel;
    UIImageView *productPosterImage, *arrowImageView;
    PSNumberView *selectNumView;
    UIButton *showProductListBtn;
}

@property (nonatomic, weak) id<ProductViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *selectProductList;
@property (nonatomic, assign) BOOL isFromConfirm;

- (void)updateLayout;

@end
