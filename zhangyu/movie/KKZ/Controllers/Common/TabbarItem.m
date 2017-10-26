//
//  TabbarItem.m
//  Aimeili
//
//  Created by zhang da on 12-8-7.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "TabbarItem.h"

#import "KKZTextUtility.h"

#define kMargin 2
#define kTitleFont 11

@interface TabbarItem ()

@property (nonatomic, retain) NSString *highlightedImg;
@property (nonatomic, retain) NSString *normalImg;
@property (nonatomic, retain) UIColor *highlightedColor;
@property (nonatomic, retain) UIColor *normalColor;

@end

@implementation TabbarItem

@synthesize activated = _activated, index = _index;
@synthesize highlightedImg = _highlightedImg, normalImg = _normalImg;
@synthesize delegate = _delegate;

@synthesize highlightedColor;
@synthesize normalColor;

- (void)dealloc {
    self.normalImg = nil;
    self.highlightedImg = nil;
    self.normalColor = nil;
    self.highlightedColor = nil;
    badgeField = nil;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    titleLabel.textColor = (!highlighted && !self.activated) ? self.normalColor : self.highlightedColor;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(NSString *)norName
  hightlightedImage:(NSString *)hltName
        normalColor:(UIColor *)norColor
  hightlightedColor:(UIColor *)hltColor
              index:(int)idx {

    self = [super initWithFrame:frame];
    if (self) {
        self.highlightedImg = hltName;
        self.normalImg = norName;
        self.highlightedColor = hltColor;
        self.normalColor = norColor;

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, frame.size.width - 2 * kMargin, frame.size.height - 2 * kMargin)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];

        if (title) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 12, frame.size.width, 13)];

            titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = self.normalColor;
            titleLabel.highlightedTextColor = self.normalColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = title;
            [self addSubview:titleLabel];

            imageView.frame = CGRectMake((frame.size.width - 23) / 2.f, 3, 23, 23);
        }

        self.index = idx;
        self.activated = NO;

        UITapGestureRecognizer *tap =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
        tap.cancelsTouchesInView = NO;
    }
    return self;
}

- (void)setBadge:(NSString *)badge {
    if (badge && !badgeField) {
        badgeField = [[UITextField alloc] init];
        badgeField.backgroundColor = [UIColor redColor];
        badgeField.textColor = [UIColor whiteColor];
        badgeField.layer.borderColor = [UIColor whiteColor].CGColor;
        badgeField.layer.borderWidth = 1;
        badgeField.layer.cornerRadius = 8;
        badgeField.layer.masksToBounds = YES;
        badgeField.textAlignment = NSTextAlignmentCenter;
        badgeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        badgeField.userInteractionEnabled = NO;
        badgeField.font = [UIFont systemFontOfSize:12];
    }

    if (badge) {
        [self addSubview:badgeField];

        CGSize textSize = [KKZTextUtility
                measureText:badge
                       size:CGSizeMake(screentWith, MAXFLOAT)
                       font:[UIFont systemFontOfSize:12]];

        if (textSize.width < 10) {
            textSize.width = 10;
        }
        badgeField.frame = CGRectMake(self.frame.size.width - textSize.width - 6, -2, textSize.width + 6, 16);
        badgeField.text = badge;
    } else {
        [badgeField removeFromSuperview];
    }
}

- (void)setActivated:(BOOL)activated {
    if (_activated != activated) {
        _activated = activated;
    }
    imageView.image = [UIImage imageNamed:activated ? self.highlightedImg : self.normalImg];
    titleLabel.textColor = activated ? self.highlightedColor : self.normalColor;
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarItem:touchedAtIndex:)]) {
        [self.delegate tabbarItem:self touchedAtIndex:self.index];
    }
}

@end
