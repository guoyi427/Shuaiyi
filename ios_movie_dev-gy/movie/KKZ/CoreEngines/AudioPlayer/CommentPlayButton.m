//
//  FavPlayButton.m
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import "CommentPlayButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation CommentPlayButton

@synthesize image;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.opaque = NO;
		self.hidden = NO;
		self.alpha = 1;
		self.backgroundColor = [UIColor clearColor];
        
        
        soundBarImage = [[UIImageView alloc] init];
        soundBarImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:soundBarImage];
        [soundBarImage release];
    
        
        voiceImage = [[UIImageView alloc] init];
        [self addSubview:voiceImage];
        [voiceImage release];
        
        describeLabel = [[UILabel alloc] init];
        [self addSubview:describeLabel];
        [describeLabel release];

    }
    
    return self;
}

#pragma mark -
- (void)updateLayout {
    if (self.commentButtonType == CommentPlayQouteButton) {
        
        soundBarImage.image = [UIImage imageNamed:@"qoute_bar.png"];
        soundBarImage.frame = CGRectMake(0, 0, 85, 20);
        
        describeLabel.frame = CGRectMake(0, 0, 70, 20);
        describeLabel.backgroundColor = [UIColor clearColor];
        describeLabel.font = [UIFont systemFontOfSize:10];
        describeLabel.textColor = [UIColor blackColor];
        describeLabel.text = [NSString stringWithFormat:@"@%@",self.qouteName];
        describeLabel.textAlignment = UITextAlignmentCenter;
        describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        voiceImage.image = [UIImage imageNamed:@"qoute_play_icon.png"];
        voiceImage.frame = CGRectMake(67, 3, 13.5, 14);
    }else if (self.commentButtonType == CommentPlayNormalButton) {
     
        if (self.attitude == 1) {
            
            soundBarImage.image = [[UIImage imageNamed:@"shuocell_support_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 20)];
//            soundBarImage.frame = CGRectMake(0, 0, shuoBarLength, self.frame.size.height);
            soundBarImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            
            describeLabel.frame = CGRectMake(self.frame.size.width - 24, 7, 20, 11);
            describeLabel.backgroundColor = [UIColor clearColor];
            describeLabel.font = [UIFont systemFontOfSize:10];
            describeLabel.textColor = [UIColor blackColor];
            describeLabel.text = [NSString stringWithFormat:@"%d\"",self.length];
            describeLabel.textAlignment = UITextAlignmentRight;
            describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;

            
            voiceImage.image = [UIImage imageNamed:@"voice_play_right_1.png"];
            voiceImage.frame = CGRectMake(10, 6, 13, 13);
        }else if (self.attitude == 2) {
            
            soundBarImage.image = [[UIImage imageNamed:@"shuocell_opposition_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 30)];
            soundBarImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            
            describeLabel.frame = CGRectMake(4, 7, 20, 11);
            describeLabel.backgroundColor = [UIColor clearColor];
            describeLabel.font = [UIFont systemFontOfSize:10];
            describeLabel.textColor = [UIColor blackColor];
            describeLabel.text = [NSString stringWithFormat:@"%d\"",self.length];
            describeLabel.textAlignment = UITextAlignmentLeft;
            describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;

            voiceImage.image = [UIImage imageNamed:@"voice_play_left_1.png"];
            voiceImage.frame = CGRectMake(self.frame.size.width - 22, 6, 13, 13);

        }

    }
    
}



#pragma
#pragma mark Spin Button
- (void)startSpin
{
    [self indicatorStartAinimation];

}

- (void)stopSpin
{
    [self indicatorStopAinimation];

}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self startSpin];
	}
}




- (void)indicatorStopAinimation {
    DLog(@"tag--%d  indicatorStopAinimation-1",self.tag);

    if (indicator && [indicator isDescendantOfView:self]) {
        DLog(@"tag--%d  indicatorStopAinimation-2",self.tag);

        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
}

- (void)indicatorStartAinimation {
    DLog(@"tag--%d  indicatorStartAinimation - 1",self.tag);

    if (indicator && [indicator isDescendantOfView:self]) {
        DLog(@"tag--%d  indicatorStartAinimation - 2",self.tag);

        [indicator startAnimating];
    }else{
        DLog(@"tag--%d  indicatorStartAinimation - 3",self.tag);
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (self.attitude == 1) {
            indicator.center = CGPointMake(self.frame.size.width /2+3, 13);
        }else if (self.attitude == 2) {
            indicator.center = CGPointMake(self.frame.size.width /2-3, 13);
        }
        indicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
        indicator.hidesWhenStopped = YES;
        [self addSubview:indicator];
        
    }
    
    
    
    
}


- (void)soundStopAinimation {
    if (self.commentButtonType == CommentPlayQouteButton) {
        
        voiceImage.image = [UIImage imageNamed:@"qoute_play_icon.png"];
        voiceImage.frame = CGRectMake(67, 4, 13.5, 14);
    }else if (self.commentButtonType == CommentPlayNormalButton) {
        if (self.attitude == 1) {
            [voiceImage stopAnimating];
            voiceImage.image = [UIImage imageNamed:@"voice_play_right_1.png"];
        }else if (self.attitude == 2) {
            [voiceImage stopAnimating];
            voiceImage.image = [UIImage imageNamed:@"voice_play_left_1.png"];
            
        }
    }
}

- (void)soundPlayAinimation {
    if (self.commentButtonType == CommentPlayQouteButton) {
        
        voiceImage.image = [UIImage imageNamed:@"qoute_stop_icon.png"];
        voiceImage.frame = CGRectMake(67, 4, 13.5, 14);
    }else if (self.commentButtonType == CommentPlayNormalButton) {
        NSArray *myImages;
        
        if (self.attitude == 1) {
            myImages = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"voice_play_right_4.png"],
                        [UIImage imageNamed:@"voice_play_right_3.png"],
                        [UIImage imageNamed:@"voice_play_right_2.png"],
                        [UIImage imageNamed:@"voice_play_right_1.png"], nil];
            voiceImage.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
            voiceImage.animationDuration = 0.85; //浏览整个图片一次所用的时间
            voiceImage.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
            [voiceImage startAnimating];
        }else if (self.attitude == 2) {
            myImages = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"voice_play_left_4.png"],
                        [UIImage imageNamed:@"voice_play_left_3.png"],
                        [UIImage imageNamed:@"voice_play_left_2.png"],
                        [UIImage imageNamed:@"voice_play_left_1.png"], nil];
            voiceImage.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
            voiceImage.animationDuration = 0.85; //浏览整个图片一次所用的时间
            voiceImage.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
            [voiceImage startAnimating];
        }
    
    }
        
}


- (void)dealloc
{
    [super dealloc];
    [image release];
    [indicator release];

}


@end