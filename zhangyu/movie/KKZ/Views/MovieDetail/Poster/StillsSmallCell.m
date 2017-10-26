//
//  剧照海报列表的Cell
//
//  Created by gree2 on 14/11/20.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "StillsSmallCell.h"

#import "ImageEngine.h"
#import "KKZUtility.h"
#import "MovieStillScrollViewController.h"

@interface MyStillUnit : UIView {

    UIImageView *imageView;
}

@property (nonatomic, assign) int stillIndex;
@property (nonatomic, strong) NSString *imagePath;

- (void)updateLayout;

@end

@implementation MyStillUnit

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        CGFloat marginY = (screentWith - 320) * 0.25;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 73.5 + marginY, 73.5 + marginY)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];

        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(handleImageReadyNotification:)
                       name:ImageReadyNotification
                     object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImageReadyNotification object:nil];
}

- (void)preparePic {
    [[ImageEngine sharedImageEngine] getImageForURL:self.imagePath andSize:ImageSizeTiny];
}

- (void)handleImageReadyNotification:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSString *path = [dict objectForKey:@"path"];

    if ([path isEqualToString:self.imagePath]) {
        UIImage *image = [dict kkz_objForKey:@"image"];
        if (image) {
            imageView.image = image;
        }
    }
}

- (void)updateLayout {
    imageView.image = [[ImageEngine sharedImageEngine] getImageFromMemForURL:self.imagePath andSize:ImageSizeTiny];
}

@end

@implementation StillsSmallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        CGFloat marginY = (screentWith - 320) * 0.25;

        unit1 = [[MyStillUnit alloc] initWithFrame:CGRectMake(5, 0, 73.5 + marginY, 73.5 + marginY)];
        unit1.hidden = YES;
        [self addSubview:unit1];

        unit2 = [[MyStillUnit alloc] initWithFrame:CGRectMake(5 + 73.5 + 5 + marginY, 0, 73.5 + marginY, 73.5 + marginY)];
        unit2.hidden = YES;
        [self addSubview:unit2];

        unit3 = [[MyStillUnit alloc] initWithFrame:CGRectMake(5 + 73.5 * 2 + 10 + marginY * 2, 0, 73.5 + marginY, 73.5 + marginY)];
        unit3.hidden = YES;

        [self addSubview:unit3];

        unit4 = [[MyStillUnit alloc] initWithFrame:CGRectMake(5 + 73.5 * 3 + 15 + marginY * 3, 0, 73.5 + marginY, 73.5 + marginY)];
        unit4.hidden = YES;

        [self addSubview:unit4];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateImagePath {
    unit1.imagePath = self.imagePath1;
    unit2.imagePath = self.imagePath2;
    unit3.imagePath = self.imagePath3;
    unit4.imagePath = self.imagePath4;
}

- (void)preparePicImg {
    [unit1 preparePic];
    [unit2 preparePic];
    [unit3 preparePic];
    [unit4 preparePic];
}

- (void)updateLayout {
    unit1.hidden = YES;
    unit2.hidden = YES;
    unit3.hidden = YES;
    unit4.hidden = YES;

    [unit1 updateLayout];
    [unit2 updateLayout];
    [unit3 updateLayout];
    [unit4 updateLayout];

    if (self.imagePath1.length != 0 && ![self.imagePath1 isEqualToString:@"(null)"]) {
        unit1.hidden = NO;
    }
    if (self.imagePath2.length != 0 && ![self.imagePath2 isEqualToString:@"(null)"]) {
        unit2.hidden = NO;
    }
    if (self.imagePath3.length != 0 && ![self.imagePath3 isEqualToString:@"(null)"]) {
        unit3.hidden = NO;
    }
    if (self.imagePath4.length != 0 && ![self.imagePath4 isEqualToString:@"(null)"]) {
        unit4.hidden = NO;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (CGRectContainsPoint(unit1.frame, point) && !unit1.hidden) {
        self.myIndex = self.stillIndex1;
        self.myImagePath = self.imagePath1;
    } else if (CGRectContainsPoint(unit2.frame, point) && !unit2.hidden) {
        self.myIndex = self.stillIndex2;
        self.myImagePath = self.imagePath2;
    } else if (CGRectContainsPoint(unit3.frame, point) && !unit2.hidden) {
        self.myIndex = self.stillIndex3;
        self.myImagePath = self.imagePath3;
    } else if (CGRectContainsPoint(unit4.frame, point) && !unit2.hidden) {
        self.myIndex = self.stillIndex4;
        self.myImagePath = self.imagePath4;
    } else {
        self.myIndex = -1;
        self.myImagePath = nil;
    }
    if (self.myImagePath.length > 0 && ![self.myImagePath isEqualToString:@"(null)"]) {
        MovieStillScrollViewController *ctr = [[MovieStillScrollViewController alloc] init];
        ctr.isMovie = self.isMovie;
        ctr.index = self.myIndex;
        ctr.gallerys = self.stills;

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
}

@end
