//
//  PPiFlatSegmentedControl.h
//  PPiFlatSegmentedControl
//
//  Created by Pedro Piñera Buendía on 12/08/13.
//  Copyright (c) 2013 PPinera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIButton+PPiAwesome.h"

typedef void(^selectionBlock)(NSUInteger segmentIndex);

@interface PPiFlatSegmentedControl : UIView

/**
 *	PROPERTIES
 * textFont: Font of text inside segments
 * textColor: Color of text inside segments
 * selectedTextColor: Color of text inside segments ( selected state )
 * color: Background color of full segmentControl
 * selectedColor: Background color for segment in selected state
 * borderWidth: Width of the border line around segments and control
 * borderColor: Color "" ""
 */

@property (nonatomic,retain) UIColor *selectedColor;
@property (nonatomic,retain) UIColor *color;
@property (nonatomic,retain) UIFont *textFont;
@property (nonatomic,retain) UIFont *selectTextFont;
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,retain) UIColor *selectTextColor;
@property (nonatomic,retain) UIColor *borderColor;
@property (nonatomic,retain) UIColor *selectionColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic,retain) NSDictionary *textAttributes;
@property (nonatomic,retain) NSDictionary *selectedTextAttributes;
@property (nonatomic) IconPosition iconPosition;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items iconPosition:(IconPosition)position andSelectionBlock:(selectionBlock)block;
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items iconPosition:(IconPosition)position color:(UIColor*)color andSelectionBlock:(selectionBlock)block;
-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index;
-(void)setTitle:(id)title forSegmentAtIndex:(NSUInteger)index;
-(void)setSelectedTextAttributes:(NSDictionary*)attributes;
-(void)updateSegmentsFormat;
-(void)setSegmentSelected:(NSInteger)index;

@end
