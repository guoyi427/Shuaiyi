//
//  PayMethodCell.h
//  CIASMovie
//
//  Created by hqlgree2 on 09/01/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodCell : UITableViewCell{
    UIImageView *logoImageView, *selectedImageView;
    UILabel *payMethodLabel;
}
@property (nonatomic, assign) NSInteger payTypeNum;

- (void)updateLayout;

@end
