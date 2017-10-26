//
//  NYOPCell.m
//  kokozu
//
//  Created by da zhang on 11-5-12.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "MicView.h"


@implementation MicView

- (void)dealloc
{
    DLog(@"MicView dealloc");
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor greenColor];
        // Configure the particle emitter
        heartsEmitter = [CAEmitterLayer layer];
        heartsEmitter.emitterPosition = CGPointMake(frame.size.height/2.0,frame.size.width/2.0);
        heartsEmitter.emitterSize = CGSizeMake(100,100);
        
        // Spawn points for the hearts are within the area defined by the button frame
        heartsEmitter.emitterMode = kCAEmitterLayerVolume;
        heartsEmitter.emitterShape = kCAEmitterLayerPoint;
        heartsEmitter.renderMode = kCAEmitterLayerAdditive;
        heartsEmitter.seed = 3;
        
        // Configure the emitter cell
        CAEmitterCell *heart = [CAEmitterCell emitterCell];
        heart.name = @"heart";
        
        //    heart.emissionLongitude = M_PI/2.0; // up
        //    heart.emissionRange = 0.65 * M_PI;  // in a wide spread
        heart.birthRate		= 0.5;			// emitter is deactivated for now
        heart.lifetime		= 3.0;			// hearts vanish after 3 seconds
        
        //    heart.velocity		= -30;			// particles get fired up fast
        //    heart.velocityRange = 3;			// with some variation
        //    heart.yAcceleration = 5;			// but fall eventually
        
        heart.contents		= (id) [[UIImage imageNamed:@"mic_wave"] CGImage];
        heart.color			= [[UIColor whiteColor] CGColor];
        //    heart.redRange		= 0.2;			// some variation in the color
        //    heart.blueRange		= 0.2;
        heart.alphaSpeed	= -0.5;  // fade over the lifetime
        
        heart.scale			= 0.1;			// let them start small
        //    heart.scaleRange    = 0.65;
        heart.scaleSpeed	= 0.5;			// but then 'explode' in size
        //    heart.spinRange		= 0.45 * M_PI;	// and send them spinning from -180 to +180 deg/s
        
        // Add everything to our backing layer
        heartsEmitter.emitterCells = [NSArray arrayWithObject:heart];
        [self.layer addSublayer:heartsEmitter];
        
        CGFloat marginY = 0;
        
        if (screentHeight == 480) {
            
            marginY = - 20;
            
        }else if(screentHeight == 667)//
        {
            marginY = - 8;
            
        }else if(screentHeight == 568)
        {
            marginY = - 20;
            
        }else if(screentHeight == 736)
        {
            marginY = 10;
        }

        UIImageView *micImgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 27)/2.0
                                                                                , (frame.size.height - 37)/2.0 - marginY, 30, 30)];
        micImgView.image = [UIImage imageNamed:@"shuo_mic_icon"];
        [self addSubview:micImgView];
        
        [self playAnimation];

    }
    return self;
}


- (void)playAnimation {
	// Fires up some hearts to rain on the view
	CABasicAnimation *heartsBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.heart.birthRate"];
	heartsBurst.fromValue		= [NSNumber numberWithFloat:1.4];
	heartsBurst.toValue			= [NSNumber numberWithFloat:1.0];
	heartsBurst.duration		= FLT_MAX;
    //    heartsBurst.repeatCount=FLT_MAX;
    
	heartsBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	[heartsEmitter addAnimation:heartsBurst forKey:@"heartsBurst"];
}

- (void)stopAnimation {
    
}


- (void)updateLayout {
   }




@end
