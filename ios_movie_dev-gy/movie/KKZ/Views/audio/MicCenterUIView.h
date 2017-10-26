//
//  MicCenterView.h
//  KoMovie
//
//  Created by zhoukai on 12/18/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MicCenterView : UIView

-(void)stopAnimation;
-(void)setDurationLabelText:(NSString *)text;
-(void)setdurationLabelTextColor:(UIColor *)color;
-(UILabel *)getDurationLabel;
@end
