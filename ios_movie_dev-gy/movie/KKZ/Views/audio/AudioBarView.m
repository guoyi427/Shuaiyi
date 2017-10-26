//
//  AudioBarView.m
//  KoMovie
//
//  Created by zhoukai on 1/21/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "AudioBarView.h"
#import "AudioPlayerManager.h"
#import "UIConstants.h"

@implementation AudioBarView{
    
    UIActivityIndicatorView *indicator;
    
    UIImageView *audioBarImageView;
    UIImageView *audioPlayImageView;
    UILabel *audioLengthLabel;
    UILabel *shitingLbl;
    CGRect fixedFrame;
    
}

- (void)dealloc
{
    DLog(@"AudioBarView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        fixedFrame = frame;
        self.backgroundColor = [UIColor clearColor];
        [[AudioPlayerManager sharedAudioPlayerManager] addAudioBar:self];
        
        self.audioBarType = AudioBarTypeYourBlue;
        self.minWidth = 50;
        self.maxWidth = 170;
        self.height = 30;
        [self addAutioViews];

    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
//        [[AudioPlayerManager sharedAudioPlayerManager] addAudioBar:self];
        self.backgroundColor = [UIColor clearColor];
        self.audioBarType = AudioBarTypeYourBlue;
        self.minWidth = 50;
        self.maxWidth = 170;
        self.height = 30;
        
        [self addAutioViews];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)addAutioViews{
    audioBarImageView = [[UIImageView alloc] init];
    audioBarImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:audioBarImageView];
    
    audioPlayImageView = [[UIImageView alloc] init];
    audioPlayImageView.animationDuration = 0.85; //浏览整个图片一次所用的时间
    audioPlayImageView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [self addSubview:audioPlayImageView];
    
    shitingLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 80, 14)];
    shitingLbl.textAlignment = NSTextAlignmentCenter;
    shitingLbl.text = @"语音消息";
    shitingLbl.textColor = [UIColor whiteColor];
    shitingLbl.backgroundColor = [UIColor clearColor];
    shitingLbl.font = [UIFont systemFontOfSize:kTextSizeContent];
    [self addSubview:shitingLbl];
    
    audioLengthLabel = [[UILabel alloc] init];
    audioLengthLabel.textColor = [UIColor whiteColor];
    audioLengthLabel.backgroundColor = [UIColor clearColor];
    audioLengthLabel.font = [UIFont systemFontOfSize:kTextSizeContent];
    audioLengthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:audioLengthLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

-(void)updateWithAudioURL:(NSString *)url withAudioLength:(NSNumber *)length{
    [[AudioPlayerManager sharedAudioPlayerManager] addAudioBar:self];// 只会加入一次。
    
    self.audioURL = url;
    
    float shuoBarLength = self.minWidth;
    
    shuoBarLength = self.minWidth + [length intValue]*4;
    shuoBarLength = shuoBarLength > self.maxWidth ? self.maxWidth : shuoBarLength;
    
    if (self.audioBarType == AudioBarTypeYourBlue) {
        audioPlayImageView.frame = CGRectMake(14, 8, 14, 14);
        audioBarImageView.image = [UIImage imageNamed:@"shuo_support_bar_blue"];//  //shuocell_support_bar
        audioPlayImageView.image = [UIImage imageNamed:@"voice_play_right_1"];
        audioPlayImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"voice_play_right_4"],
                                              [UIImage imageNamed:@"voice_play_right_3"],
                                              [UIImage imageNamed:@"voice_play_right_2"],
                                              [UIImage imageNamed:@"voice_play_right_1"], nil];
    }else if (self.audioBarType == AudioBarTypeMyFriendOrange){
        audioPlayImageView.frame = CGRectMake(14, 8, 14, 14);
        audioBarImageView.image = [UIImage imageNamed:@"shuo_support_bar_orange"];//  //shuocell_support_bar
        audioPlayImageView.image = [UIImage imageNamed:@"voice_play_right_1"];
        audioPlayImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"voice_play_right_4"],
                                              [UIImage imageNamed:@"voice_play_right_3"],
                                              [UIImage imageNamed:@"voice_play_right_2"],
                                              [UIImage imageNamed:@"voice_play_right_1"], nil];
    } else{
        
        audioPlayImageView.frame = CGRectMake(120 - 14 - 14, 8, 14, 14);
        audioPlayImageView.image = [UIImage imageNamed:@"mic_wifi_4"];
        audioPlayImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"mic_wifi_1"],
                                              [UIImage imageNamed:@"mic_wifi_2"],
                                              [UIImage imageNamed:@"mic_wifi_3"],
                                              [UIImage imageNamed:@"mic_wifi_4"], nil];
        audioBarImageView.image = [[UIImage imageNamed: @"mic_audio_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,5, 0, 15)];
    }
    shuoBarLength = 15;
    audioBarImageView.frame = CGRectMake(0,  0, 120, self.height);//拉伸的最终大小
    

    if (self.audioBarType == AudioBarTypeYourBlue) {
        audioLengthLabel.frame = CGRectMake(55, 8, 60, 14);
        audioLengthLabel.textAlignment = NSTextAlignmentRight;
        audioLengthLabel.textColor = [UIColor whiteColor];
        shitingLbl.textColor = [UIColor whiteColor];
        
    }else if (self.audioBarType == AudioBarTypeMyFriendOrange) {
        audioLengthLabel.frame = CGRectMake(55, 8, 60, 14);
        audioLengthLabel.textAlignment = NSTextAlignmentRight;
        audioLengthLabel.textColor = [UIColor whiteColor];
        shitingLbl.textColor = [UIColor whiteColor];
        
    }else{
        audioLengthLabel.frame = CGRectMake(8,8,60, 14);
         audioLengthLabel.textAlignment = NSTextAlignmentLeft;
        audioLengthLabel.textColor = [UIColor grayColor];
        shitingLbl.textColor = [UIColor grayColor];
    }
    audioLengthLabel.text = [NSString stringWithFormat:@"%@\"",length];

    self.frame = CGRectMake(CGRectGetMinX(self.frame),
                            CGRectGetMinY(self.frame),
                            CGRectGetWidth(audioBarImageView.frame),
                            CGRectGetHeight(audioBarImageView.frame));
//    self.frame = audioBarImageView.frame;
}


- (void)stopIndicatorAinimation {
    if (indicator && [indicator isDescendantOfView:self]) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
}

- (void)startIndicatorAinimation {
    if (indicator == nil) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    indicator.frame = CGRectMake((CGRectGetWidth(audioBarImageView.frame) - 20)/2.0,
                                 (CGRectGetHeight(audioBarImageView.frame) - 20)/2.0,
                                 20,
                                 20);
    indicator.hidesWhenStopped = YES;
    [self addSubview:indicator];
    
    [indicator startAnimating];
    
}

- (void)stopAudioAinimation {
    [audioPlayImageView stopAnimating];
//    audioPlayImageView.image = [UIImage imageNamed:@"voice_play_green_1.png"];
}

- (void)playAudioAinimation {
    [audioPlayImageView startAnimating];
}

-(BOOL)isPlaying{
    return (audioPlayImageView.isAnimating || indicator.isAnimating );

}

- (void)stopAudioPlay{
    [[AudioPlayerManager sharedAudioPlayerManager] stopAll];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    [[AudioPlayerManager sharedAudioPlayerManager] removeAudioBar:self];
}


- (void)singleTap:(UITapGestureRecognizer *)gesture {
    DLog(@"点击语音播放");
    if ([self isPlaying]) {
        [[AudioPlayerManager sharedAudioPlayerManager] stopAll];
    }else{
        [[AudioPlayerManager sharedAudioPlayerManager] playAudioBar:self];
    }

    
}

@end
