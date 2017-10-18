//
//  CinemaDetailView.h
//  CHUNDAN
//
//  Created by 唐永廷 on 2017/4/22.
//  Copyright © 2017年 唐永廷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cinema.h"

@interface CinemaDetailView : UIView 
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeight;
@property (nonatomic, assign) CGFloat viewHeight;
@property (weak, nonatomic) IBOutlet UILabel *cinemaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaOpenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaIntroduceLabel;




- (IBAction)closeAction:(UIButton *)sender;
- (void)setViewLabelWithCinema:(Cinema *)cinema;
- (void)reloadData;
@end
