//
//  CircularProgressView.h
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import <UIKit/UIKit.h>

extern NSString *playImage, *stopImage;

typedef enum {
	CommentPlayNormalButton = 0,
    CommentPlayQouteButton,

} CommentPlayButtonType;

@interface CommentPlayButton : UIButton {

	    
    UIImage *image;
    
    UIImageView *soundBarImage, *voiceImage;
    UILabel *describeLabel;
    UIActivityIndicatorView *indicator;
    
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) int length;
@property (nonatomic, assign) int attitude;
@property (nonatomic, retain) NSString* qouteName;

@property (nonatomic, assign) CommentPlayButtonType commentButtonType;


- (id)initWithFrame:(CGRect)frame;
- (void)startSpin;
- (void)stopSpin;
//- (CGFloat)progress;
//- (void)setProgress:(CGFloat)newProgress;
- (void)updateLayout;
- (void)soundStopAinimation;
- (void)soundPlayAinimation;

@end
