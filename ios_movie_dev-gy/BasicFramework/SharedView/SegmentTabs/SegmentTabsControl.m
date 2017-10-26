//
//  SegmentTabsControl.m
//  KoMovie
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SegmentTabsControl.h"
#import "SegmentTab.h"


@interface SegmentTabsControl()
@property (nonatomic,retain) NSMutableArray *segments;
@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,copy) selectionBlockYN selBlock;
@end

@implementation SegmentTabsControl

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items color:(UIColor*)color andSelectionBlock:(selectionBlockYN)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, screentWith, 1)];
        [topLine setBackgroundColor:[UIColor r:235 g:235 b:235]];
        [self addSubview:topLine];
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(-15, self.frame.size.height - 1, screentWith, 1)];
         [bottomLine setBackgroundColor:[UIColor r:235 g:235 b:235]];
        [self addSubview:bottomLine];
        
        //Selection block
        self.selBlock = block;
        
        //Background Color
        self.backgroundColor= [UIColor clearColor];
        
        self.selectTextColor = color;
        self.textColor = [UIColor r:102 g:102 b:102];
        self.textFont = [UIFont systemFontOfSize:14];
        
        //Generating segments
        float buttonWith=frame.size.width/items.count;
        int i=0;
        for(NSDictionary *item in items){
            NSString *text=item[@"text"];
            
            SegmentTab *segTab =[[SegmentTab alloc] initWithFrame:CGRectMake(buttonWith*i, 0, buttonWith, frame.size.height) text:text];

            [segTab addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            //Adding to self view
            [self.segments addObject:segTab];
            [self addSubview:segTab];
            i++;
        }
        
        //Default selected 0
        _currentSelected=0;
    }
    return self;
}

#pragma mark - Lazy instantiations
-(NSMutableArray*)segments{
    if(!_segments)_segments=[[NSMutableArray alloc] init];
    return _segments;
}

#pragma mark - Actions

-(void)setSegmentSelected:(NSInteger)index{
    
    [self setEnabled:YES forSegmentAtIndex:index];
    
    //Calling block
    if(self.selBlock){
        self.selBlock(index);
    }
}

-(void)segmentSelected:(id)sender{
    if(sender){
        
        [self performSelector:@selector(delayMethod:) withObject:sender afterDelay:0.2f];
    }
}

-(void)delayMethod:(id)sender
{
    NSUInteger selectedIndex=[self.segments indexOfObject:sender];
    
    [self setEnabled:YES forSegmentAtIndex:selectedIndex];
    
    //Calling block
    if(self.selBlock){
        self.selBlock(selectedIndex);
    }
    
}

#pragma mark - Getters
/**
 *	Returns if a specified segment is selected
 *
 *	@param	index	Index of segment to check
 *
 *	@return	BOOL selected
 */
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index{
    return (index==self.currentSelected);
}


-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment{
    if(enabled){
        self.currentSelected=segment;
        [self updateSegmentsFormat];
    }
}

#pragma mark - Setters
-(void)updateSegmentsFormat{
    
    self.textFont = [UIFont systemFontOfSize:14];
    self.selectTextFont = [UIFont systemFontOfSize:14];
    
    
    //Modifying buttons with current State
    for (SegmentTab *segment in self.segments){
        //Setting format depending on if it's selected or not
        if([self.segments indexOfObject:segment]==self.currentSelected){
            //Selected-one
            
            if(self.selectTextColor)
                [segment setTextColor:self.selectTextColor forUIControlState:UIControlStateNormal andBottomLineHidden:NO];
            if(self.selectTextFont)
                [segment setTextFont:self.selectTextFont forUIControlState:UIControlStateNormal];
        }else{
            //Non selected
            if(self.textColor)
                [segment setTextColor:self.textColor forUIControlState:UIControlStateNormal andBottomLineHidden:YES];
            if(self.textFont)
                [segment setTextFont:self.textFont forUIControlState:UIControlStateNormal];
            
        }
    }
}


@end
