//
//  AlertViewY.h
//  KoMovie
//
//  Created by avatar on 14-12-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewY : UIView

@property (nonatomic, strong) UILabel * alertLabel;
@property (nonatomic, strong) NSString * alertLabelText;
@property (nonatomic, strong) UIImageView * alertView;
@property(nonatomic,strong)UIImageView *vBg;

-(void)setAlertLabelText:(NSString *)alertLabelText;
- (void)startAnimation;
-(void)setAlertViewImage:(NSString *)name;
@end

