//
//  PSNumberView.h
//  CIASMovie
//
//  Created by cias on 2017/1/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PSNumberViewDelegate <NSObject>

- (void)PSTextFieldNumber:(NSString *)number indexPath:(NSInteger)index;

@end

@interface PSNumberView : UIView{
    UIButton *decreaseBtn, *increaseBtn;
    UITextField *numberTextField;
    
}

@property (nonatomic, weak) id<PSNumberViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *goodsNumString;
@property(nonatomic, assign) BOOL isCancelTap;
@property (nonatomic, assign) NSInteger minNumber;

- (void)updateLayout;
- (void)setGoodsNumString:(NSString *)goodsNumString;

@end
