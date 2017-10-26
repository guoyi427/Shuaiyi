//
//  MovieDialogue.h
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

//经典台词
@interface MovieDialogue : Model

@property (nonatomic, assign) int dialogueId;
@property (nonatomic, retain) NSString * dialogueDetail;
@property (nonatomic, retain) NSNumber * hot;
@property (nonatomic, assign) int movieId;
@property (nonatomic, retain) NSString * dialogueSpeaker;//说台词的人

+ (MovieDialogue *)getDialogueWithId:(int)dialogueId;

@end
