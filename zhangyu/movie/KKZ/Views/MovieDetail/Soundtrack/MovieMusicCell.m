//
//  电影原声歌曲的Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieMusicCell.h"

#import "ImageEngine.h"
#import "ShareView.h"

@implementation MovieMusicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];

        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 55, 55)];
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.userInteractionEnabled = YES;
        avatarView.clipsToBounds = YES;
        [self addSubview:avatarView];

        CGFloat marginY = (screentWith - 320) * 0.5;

        nameLable = [[UILabel alloc] initWithFrame:CGRectMake(85, 17, marginY + 175, 18)];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont boldSystemFontOfSize:15];
        nameLable.textColor = [UIColor r:50 g:50 b:50];
        [self addSubview:nameLable];

        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 45 + 11, marginY + 182, 18)];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.font = [UIFont systemFontOfSize:13];
        typeLabel.textColor = [UIColor r:100 g:100 b:100];
        [self addSubview:typeLabel];

        playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 28 + 9, marginY + 182, 18)];
        playerLabel.backgroundColor = [UIColor clearColor];
        playerLabel.font = [UIFont systemFontOfSize:13];
        playerLabel.textColor = [UIColor r:100 g:100 b:100];
        [self addSubview:playerLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 89, screentWith, 1)];
        line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:line];
    }
    return self;
}

- (void)dealloc {
    if (_audioButton) {
        [_audioButton removeFromSuperview];
    }
}

- (void)updateLayout {
    nameLable.hidden = YES;
    typeLabel.hidden = YES;
    playerLabel.hidden = YES;

    [avatarView loadImageWithURL:self.avatarUrl andSize:ImageSizeSmall];
    if (self.name.length > 0 && ![self.name isEqualToString:@"(null)"]) {
        nameLable.text = self.name;
        nameLable.hidden = NO;

    } else {
        nameLable.text = @"";
    }
    if (self.musicType.length > 0 && ![self.musicType isEqualToString:@"(null)"]) {
        typeLabel.text = self.musicType;
        typeLabel.hidden = NO;

    } else {
        typeLabel.text = @"";
    }
    if (self.musicPlayer.length != 0 && ![self.musicPlayer isEqualToString:@"(null)"]) {
        playerLabel.text = [NSString stringWithFormat:@"歌手：%@", self.musicPlayer];
        playerLabel.hidden = NO;

    } else {
        playerLabel.text = @"";
    }
}

- (void)configurePlayerButton {
    _audioButton = [[AudioButton alloc] initWithFrame:CGRectMake(screentWith - 57, 27, 35, 35)];
    [self addSubview:_audioButton];
}

- (void)shareSong {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchOnShareAtRow:withSong:withImage:)]) {
        [self.delegate handleTouchOnShareAtRow:self.row withSong:self.song withImage:avatarView.image];
    }
}

@end
