//
//  ChargeSuceessViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargeSuceessViewController : UIViewController
{
    UIButton * backButton;
    UILabel *cinemaTitleLabel, *movieTitleLabel;
}

@property (nonatomic, strong) UINavigationBar *navBar;





@property (weak, nonatomic) IBOutlet UIImageView *chargeSuccessImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *chargeSuccessLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBuyTicketBtn;
- (IBAction)gotoBuyTicketBtnClick:(UIButton *)sender;

@end
