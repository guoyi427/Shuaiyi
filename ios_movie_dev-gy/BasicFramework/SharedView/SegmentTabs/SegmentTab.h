//
//  SegmentTab.h
//  KoMovie
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentTab : UIButton
-(id)initWithFrame:(CGRect)frame text:(NSString*)text;
-(void)setTextFont:(UIFont*)font forUIControlState:(UIControlState)state;
-(void)setTextColor:(UIColor*)color forUIControlState:(UIControlState)state andBottomLineHidden:(BOOL)isHidden;
@end
