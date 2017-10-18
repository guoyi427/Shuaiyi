//
//  ProductCell.h
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSNumberView.h"
#import "Product.h"

@protocol ProductCellDelegate <NSObject>

- (void)ProductCellNumber:(NSString *)numberDict indexPath:(NSInteger)index;

@end


@interface ProductCell : UITableViewCell<PSNumberViewDelegate>
{
    UILabel *titleLabel, *contentLabel, *describeLabel;
    UILabel *totalNumLabel;
    UILabel *priceLabel;
    UIImageView *productPosterImage, *arrowImageView;
    PSNumberView *selectNumView;

}

@property(nonatomic, strong) Product *aProduct;
@property(nonatomic, assign) NSInteger indexPathRow;
@property(nonatomic, assign) NSInteger maxNumber;

@property(nonatomic, copy) NSString * indexOfNumberString;
@property(nonatomic, assign) BOOL isCancelTap;

@property (nonatomic, weak) id<ProductCellDelegate> delegate;

- (void)updateLayout;

@end
