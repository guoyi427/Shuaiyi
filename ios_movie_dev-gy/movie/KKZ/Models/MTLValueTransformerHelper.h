//
//  MTLValueTransformerHelper.h
//  KoMovie
//
//  Created by Albert on 12/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSString to NSNumber valueTansformer

 @return NSValueTransformer
 */
NSValueTransformer * KKZ_StringToNumberTransformer();


/**
 NSString to NSDate valueTansformer

 @param formatter dateformatter

 @return NSValueTransformer
 */
NSValueTransformer * KKZ_StringToDateTransformer(NSString *formatter);
