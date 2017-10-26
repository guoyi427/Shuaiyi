//
//  SegmentTabsControl.h
//  KoMovie
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectionBlockYN)(NSUInteger segmentIndex);

@interface SegmentTabsControl : UIView
@property (nonatomic,retain) UIFont *textFont;
@property (nonatomic,retain) UIFont *selectTextFont;
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,retain) UIColor *selectTextColor;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items color:(UIColor*)color andSelectionBlock:(selectionBlockYN)block;
-(void)updateSegmentsFormat;
-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;
@end
