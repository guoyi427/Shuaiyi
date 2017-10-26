//
//  Actor.m
//  KoMovie
//
//  Created by XuYang on 13-8-6.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Actor.h"
#import "MemContainer.h"

@implementation Actor

//@dynamic starId;
//@dynamic chineseName;
//@dynamic doubanId;
//@dynamic foreignName;
//@dynamic gender;
//@dynamic hot;
//@dynamic imageBig;
//@dynamic imageSmall;
//@dynamic bornPlace;
//@dynamic birthday;
//@dynamic actorIntro;
//@dynamic character;



+ (NSString *)primaryKey {
    return @"starId";
}



#pragma mark - MJE
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"birthday"]) {
        if (oldValue == nil) return nil;
        
        if (property.type.typeClass == [NSDate class]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt dateFromString:oldValue];
        }
        
    }
    
    return oldValue;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"actorIntro": @"starIntro"
             };
}


//+ (NSDictionary *)propertyMapping {
//    static NSDictionary *map = nil;
//    if(!map){
//        map = @{
//                 @"actorIntro": @"starIntro",
//                 }
//               ;
//    }
//    return map;
//}
//
//+ (NSDictionary *)formatMapping {
//    static NSDictionary *map = nil;
//    if(!map){
//        map = @{
//                 @"birthday": @"yyyy-MM-dd",
//                 };
//    }
//    return map;
//}
//
+ (Actor *)getActorWithId:(unsigned int)starId {
    return [[MemContainer me] getObject:[Actor class]
                                 filter:[Predicate predictForKey: @"starId" compare:Equal value:@(starId)], nil];
}

@end
