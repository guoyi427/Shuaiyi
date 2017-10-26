//
//  电影原声歌曲的Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AudioButton.h"
#import "MovieSong.h"

@protocol MovieMusicCellDelegate <NSObject>

@optional
- (void)handleTouchOnShareAtRow:(NSInteger)row withSong:(MovieSong *)song withImage:(UIImage *)image;

@end

@interface MovieMusicCell : UITableViewCell {

    UIImageView *avatarView;
    UILabel *nameLable, *typeLabel, *playerLabel;
}

@property (nonatomic, weak) id<MovieMusicCellDelegate> delegate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *musicType;
@property (nonatomic, strong) NSString *musicPlayer;
@property (nonatomic, strong) AudioButton *audioButton;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) MovieSong *song;

- (void)updateLayout;
- (void)configurePlayerButton;

@end
