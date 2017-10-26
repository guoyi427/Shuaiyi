//
//  RecordManager.h
//  KoMovie
//
//  Created by wuzhen on 15/7/21.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordAudio.h"


@protocol RecordManagerDelegate <NSObject>

@required

- (void)recordStarted;
- (void)recordUpdate:(int)length;
- (void)recordCancelled;
- (void)recordStopped;
- (void)recordSucceed;

@end


@interface RecordManager : NSObject {

    AVAudioRecorder *recorder;
    NSTimer *_timer;
    int recordLength;

}


@property (nonatomic, weak) id<RecordManagerDelegate> delegate;


- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (NSString *)getRecordFilePath;



@end

