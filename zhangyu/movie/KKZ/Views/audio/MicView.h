//
//  MicView.h
//  kokozu
//
//  Created by da zhang on 11-5-12.
//  Copyright 2011年 kokozu. All rights reserved.
//录音时候的中间话筒动画

#import <UIKit/UIKit.h>


//@protocol MicViewDelegate <NSObject>
//
//- (void)arrowDidTouched;
//
//@end


@interface MicView : UIView {
   
    CAEmitterLayer *heartsEmitter;

}

//@property (nonatomic, assign) id <MicViewDelegate> delegate;


- (void)updateLayout;
- (void)stopAnimation;
@end
