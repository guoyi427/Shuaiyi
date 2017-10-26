//
//  演员详情页面电影列表Cell
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActorMovieCell.h"
#import "DateEngine.h"
#import "ImageEngine.h"
#import "UIColorExtra.h"
#import "UIView+FlipTransition.h"

@interface ActorMovieUnit : UIControl {

    UIImageView *imageView;
    UILabel *nameLabel;
}

@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *movieName;

@end

@implementation ActorMovieUnit

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];

        CGFloat marginY = (screentWith - 320) / 3;

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90 + marginY, 126 * screentWith / 320)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 126 * screentWith / 320 + 6, 90 + marginY, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = appDelegate.kkzTextColor;
        nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)updateLayout {
    [imageView loadImageWithURL:self.imgUrl andSize:ImageSizeSmall];
    nameLabel.text = self.movieName;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    [self setNeedsDisplay];
}

@end

/////////////////////////////////////////////

@implementation ActorMovieCell

@synthesize delegate;

- (void)dealloc {
    if (lUnit) {
        [lUnit removeFromSuperview];
    }
    if (mUnit) {
        [mUnit removeFromSuperview];
    }
    if (rUnit) {
        [rUnit removeFromSuperview];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        CGFloat marginX = (screentWith - 320) / 3;

        [self addSubview:lUnit];

        lUnit = [[ActorMovieUnit alloc] initWithFrame:CGRectMake(15, 0, 90 + marginX, 156 * screentWith / 320)];
        [self addSubview:lUnit];

        mUnit = [[ActorMovieUnit alloc] initWithFrame:CGRectMake(115 + marginX, 0, 90 + marginX, 156 * screentWith / 320)];
        [self addSubview:mUnit];

        rUnit = [[ActorMovieUnit alloc] initWithFrame:CGRectMake(215 + marginX * 2, 0, 90 + marginX, 156 * screentWith / 320)];
        [self addSubview:rUnit];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];

    if (CGRectContainsPoint(lUnit.frame, point)) {
        if (self.lMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
            [delegate matchCell:self touchedAtIndex:3 * self.row];
        }
        return;
    }
    if (CGRectContainsPoint(mUnit.frame, point)) {
        if (self.mMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
            [delegate matchCell:self touchedAtIndex:3 * self.row + 1];
        }
        return;
    }
    if (CGRectContainsPoint(rUnit.frame, point)) {
        if (self.rMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
            [delegate matchCell:self touchedAtIndex:3 * self.row + 2];
        }
        return;
    }
}

- (void)updateLayout {
    if (self.lMovieId) {
        lUnit.hidden = NO;
        lUnit.movieId = self.lMovieId;
        lUnit.movieName = self.lMovieName;
        lUnit.imgUrl = self.lImgUrl;
    } else {
        lUnit.hidden = YES;
    }

    if (self.mMovieId) {
        mUnit.hidden = NO;
        mUnit.movieId = self.mMovieId;
        mUnit.movieName = self.mMovieName;
        mUnit.imgUrl = self.mImgUrl;
    } else {
        mUnit.hidden = YES;
    }

    if (self.rMovieId) {
        rUnit.hidden = NO;
        rUnit.movieId = self.rMovieId;
        rUnit.movieName = self.rMovieName;
        rUnit.imgUrl = self.rImgUrl;
    } else {
        rUnit.hidden = YES;
    }

    [lUnit updateLayout];
    [mUnit updateLayout];
    [rUnit updateLayout];
}

@end
