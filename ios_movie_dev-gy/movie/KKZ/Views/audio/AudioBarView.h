//
//  AudioBarView.h
//  KoMovie
//
//  Created by zhoukai on 1/21/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {

    AudioBarTypeYourBlue,
    AudioBarTypeMyWhite,
    AudioBarTypeMyFriendOrange
    
}AudioBarType;

@interface AudioBarView : UIView{
    
}

@property (nonatomic,assign) float minWidth; //默认50
@property (nonatomic,assign) float maxWidth; //默认170
@property (nonatomic,assign) float height; //默认30
@property (nonatomic,assign) AudioBarType audioBarType; //默认AudioBarYourBlue

@property (nonatomic,strong) NSString *audioURL;
/**
 *  更新大小（height=30，width自动调整）
 *
 *  @param minx   x
 *  @param minY   y
 *  @param url    语音url
 *  @param length 语音时长
 */
-(void)updateWithAudioURL:(NSString *)url withAudioLength:(NSNumber *)length;

- (void)stopIndicatorAinimation;
- (void)startIndicatorAinimation;
- (void)stopAudioAinimation;
- (void)playAudioAinimation;
- (void)stopAudioPlay;
-(BOOL)isPlaying;

@end
