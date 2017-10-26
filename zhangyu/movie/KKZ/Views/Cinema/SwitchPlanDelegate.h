//
//  SwitchPlanDelegate.h
//  Cinephile
//
//  Created by Albert on 7/29/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Ticket;
/**
 *  切换场次delegate
 */
@interface SwitchPlanDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Ticket *currentPlan;
@property (nonatomic, strong) NSArray *planList;
/**
 *  切换场次回调
 *
 *  @param a_block 回调
 */
- (void) switchToPlan:(void (^)(Ticket* plan))a_block;
@end
