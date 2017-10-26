//
//  演员详情页面演员信息的View
//
//  Created by xuyang on 13-4-10.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActorDetailView.h"

#import "Actor.h"
#import "ActorIntroPopView.h"
#import "Constants.h"
#import "DateEngine.h"
#import "KKZTextUtility.h"
#import "TaskQueue.h"

#define kMarginX 15
#define kFontSize 12

@implementation ActorDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 90, 130)];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:avatarImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //    Actor *actor = [Actor getActorWithId:self.actorId];
    Actor *actor = self.actorD;
    
    [appDelegate.kkzTextColor set];
    
    [actor.chineseName drawInRect:CGRectMake(120, 20, 190, 20)
                         withFont:[UIFont boldSystemFontOfSize:14]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentLeft];
    if (actor.birthday) {
        NSString *birthDay = [[DateEngine sharedDateEngine] stringFromDate:actor.birthday withFormat:@"yyyy-MM-dd"];
        [[NSString stringWithFormat:@"生日：%@", birthDay] drawInRect:CGRectMake(120, 43, screentWith - 120 - 10, 20)
                                                          withFont:[UIFont systemFontOfSize:12]
                                                     lineBreakMode:NSLineBreakByTruncatingTail
                                                         alignment:NSTextAlignmentLeft];
        NSString *astro = [[DateEngine sharedDateEngine] getAstroWithMonth:actor.birthday];
        [[NSString stringWithFormat:@"星座：%@座", astro] drawInRect:CGRectMake(120, 58, screentWith - 120 - 10, 20)
                                                        withFont:[UIFont systemFontOfSize:12]
                                                   lineBreakMode:NSLineBreakByTruncatingTail
                                                       alignment:NSTextAlignmentLeft];
        
    } else {
        [[NSString stringWithFormat:@"生日：未知"] drawInRect:CGRectMake(120, 43, screentWith - 120 - 10, 20)
                                                withFont:[UIFont systemFontOfSize:12]
                                           lineBreakMode:NSLineBreakByTruncatingTail
                                               alignment:NSTextAlignmentLeft];
        [[NSString stringWithFormat:@"星座：未知"] drawInRect:CGRectMake(120, 58, screentWith - 120 - 10, 20)
                                                withFont:[UIFont systemFontOfSize:12]
                                           lineBreakMode:NSLineBreakByTruncatingTail
                                               alignment:NSTextAlignmentLeft];
    }
    [[NSString stringWithFormat:@"出生地：%@", actor.bornPlace ? actor.bornPlace : @"未知"] drawInRect:CGRectMake(120, 73, screentWith - 120 - 10, 20)
                                                                                        withFont:[UIFont systemFontOfSize:13]
                                                                                   lineBreakMode:NSLineBreakByTruncatingTail
                                                                                       alignment:NSTextAlignmentLeft];
    
    detailRect = CGRectMake(120, 88, screentWith - 120 - 10, 65);
    [actor.actorIntro drawInRect:detailRect
                        withFont:[UIFont systemFontOfSize:12]
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:NSTextAlignmentLeft];
    
    [@"影片代表作" drawInRect:CGRectMake(18, 158, screentWith - 120 - 10, 30)
                withFont:[UIFont boldSystemFontOfSize:13]
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentLeft];
}

#pragma mark utilities
- (void)updateLayout {
    //    Actor *actor = [Actor getActorWithId:self.actorId];
    Actor *actor = self.actorD;
    self.avatarUrl = actor.imageSmall;
    
    [avatarImageView loadImageWithURL:self.avatarUrl andSize:ImageSizeSmall];
    [self setNeedsDisplay];
}

- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(detailRect, point)) {
        [self showActorIntroPop];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

- (void)showActorIntroPop {
    //    Actor *actor = [Actor getActorWithId:self.actorId];
    Actor *actor = self.actorD;
    
    if (actor.actorIntro && [actor.actorIntro length]) {
        CGFloat width = screentWith * 0.9;
        
        CGSize detailSize = [KKZTextUtility
                             measureText:actor.actorIntro
                             size:CGSizeMake(width, MAXFLOAT)
                             font:[UIFont systemFontOfSize:15]];
        
        //        CGSize detailSize = [actor.actorIntro sizeWithFont:[UIFont systemFontOfSize:15]
        //                                                                              constrainedToSize:CGSizeMake(width, MAXFLOAT)
        //                                                                                  lineBreakMode:NSLineBreakByTruncatingTail];
        
        CGFloat height = MIN(detailSize.height + 50, screentContentHeight * 0.8);
        CGFloat yOffset = screentHeight - height;
        
        self.poplistview = [[ActorIntroPopView alloc] initWithFrame:CGRectMake((screentWith - width) / 2.0, yOffset / 2.0, width, height)];
        self.poplistview.content = actor.actorIntro;
        [self.poplistview show];
    }
}

- (void)disMissIntro {
    [self.poplistview dismiss];
}

@end
