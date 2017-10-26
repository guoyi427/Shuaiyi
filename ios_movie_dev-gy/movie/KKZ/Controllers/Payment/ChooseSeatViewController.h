//
//  ChooseSeatViewController.h
//  Cinephile
//
//  Created by Albert on 7/13/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ticket;
/**
 *  选座页面 plan或planId必须设置一个
 */
@interface ChooseSeatViewController : CommonViewController
@property (nonatomic, strong)Ticket *plan;
/**
 *  用于切换排期
 */
@property (nonatomic, strong) NSArray *planArray;

/**
 *  排期的Id
 */
@property(nonatomic, copy) NSNumber* planId;


@property (nonatomic, copy)  NSNumber *activityId;

@property (nonatomic, copy) NSNumber *promotionId;
@end
