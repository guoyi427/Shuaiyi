//
//  SimplePlayerVideo.h
//  KoMovie
//
//  Created by KKZ on 15/10/14.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "Model.h"

@interface SimplePlayerVideo : Model

@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSString * videoName;
@property (nonatomic, assign) int live;//直播或者录播 0是录播，1是直播
@property (nonatomic, retain) NSString * recordId;//直播、录播视频的id
@property (nonatomic, assign) int videoFps;//视频的帧数 1是24fps，2是30fps，默认是1
@property (nonatomic, assign) int videoMode;//视频模式 1是全景视频，2是非全景视频
@property (nonatomic, retain) NSString * videoPath;//视频文件地址  视频路径，分为本地的或者URL，本地的为文件名
@property (nonatomic, retain) NSString * videoQuality;//视频文件品质 1标清(320p)，2高清(480p)，3超清(720p)，4是1080p
@property (nonatomic, assign) int videoType;//视频文件类型 1是URL，2是打包的文件，3是本地下载的文件，默认是1
@property (nonatomic, assign) BOOL isDefaultVideo;//判定默认视频
@property (nonatomic, assign) CGFloat videoLength;//判定默认视频

+ (SimplePlayerVideo *)getSimplePlayerVideoWithId:(NSString *)videoId;
@end
