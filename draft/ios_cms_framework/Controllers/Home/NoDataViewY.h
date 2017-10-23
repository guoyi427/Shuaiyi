//
//  nodataViewY.h
//  KoMovie
//
//  Created by avatar on 14-12-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataViewY : UIView
@property (nonatomic, strong) UILabel * alertLabel;
@property (nonatomic, strong) NSString * alertLabelText;
@property (nonatomic, strong) UIImageView * alertView;

-(void)setAlertLabelText:(NSString *)alertLabelText;
@end
