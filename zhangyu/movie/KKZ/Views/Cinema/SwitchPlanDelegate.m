//
//  SwitchPlanDelegate.m
//  Cinephile
//
//  Created by Albert on 7/29/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "SwitchPlanDelegate.h"
#import "CinemaPlanCell.h"
#import "Ticket.h"
#import <Category_KKZ/UIColor+Hex.h>

@interface SwitchPlanDelegate()
@property (nonatomic, copy) void (^switchBlock)(Ticket *plan);
@property (nonatomic, strong) NSMutableArray *cellLayouts;
@end

@implementation SwitchPlanDelegate
#pragma table delegate & source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.planList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StarCellIdentifier";
    //影院排期
    CinemaPlanCell *cell = (CinemaPlanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CinemaPlanCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    Ticket *model = self.planList[indexPath.row];
    cell.model = model;
    cell.layout = self.cellLayouts[indexPath.row];
    
    if (self.currentPlan && [model.planId isEqualToNumber:self.currentPlan.planId]) {
        [cell setIsCurrentPlan:YES];
    }else{
        [cell setIsCurrentPlan:NO];
    }
    __weak __typeof(self)weakSelf = self;
    [cell buyTicketCallback:^(Ticket *plan) {
        if (weakSelf.switchBlock) {
            
            weakSelf.switchBlock(plan);
        }
    }];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return K_CINEMA_PLAN_CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Ticket *plan = self.planList[indexPath.row];
    //非当前排期、可用、未停售
    if (self.switchBlock) {
        
        self.switchBlock(plan);
    }
}


- (void) switchToPlan:(void (^)(Ticket *))a_block
{
    self.switchBlock = a_block;
}

- (void)setPlanList:(NSArray *)planList
{
    //数据源布局数组
    if (self.cellLayouts == nil) {
        self.cellLayouts = [NSMutableArray arrayWithCapacity:planList.count];
    }
    
    //遍历数据源进行尺寸计算
    [CinemaPlanCellLayout resetMaxWidthVariable];
    for (int i = 0; i < planList.count; i++) {
        Ticket *ticket = planList[i];
        CinemaPlanCellLayout *layout = [[CinemaPlanCellLayout alloc] init];
        [layout updateCinemaPlanCellLayout:ticket];
        [self.cellLayouts addObject:layout];
    }
    
    _planList = planList;

}

@end
