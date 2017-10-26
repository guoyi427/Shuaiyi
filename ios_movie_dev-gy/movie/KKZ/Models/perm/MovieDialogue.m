//
//  MovieDialogue.m
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "MovieDialogue.h"
#import "MemContainer.h"

@implementation MovieDialogue

@dynamic dialogueId;
@dynamic dialogueDetail;
@dynamic dialogueSpeaker;
@dynamic hot;
@dynamic movieId;

+ (NSString *)primaryKey {
    return @"dialogueId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"dialogueDetail": @"dialogue",
                 @"dialogueSpeaker": @"actor",
                            
                 } retain];
    }
    return map;
}

+ (MovieDialogue *)getDialogueWithId:(int)dialogueId {
    return [[MemContainer me] getObject:[MovieDialogue class]
                                 filter:[Predicate predictForKey: @"dialogueId" compare:Equal value:@(dialogueId)], nil];

}




@end
