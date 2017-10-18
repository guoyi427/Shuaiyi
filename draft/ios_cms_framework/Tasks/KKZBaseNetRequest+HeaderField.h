//
//  KKZBaseNetRequest+HeaderField.h
//  KoMovie
//
//  Created by Albert on 7/4/16.
//  Copyright © 2016 kokozu. All rights reserved.
//

#import <NetCore_KKZ/KKZBaseNetRequest.h>
/**
 * KKZBaseNetRequest默认header
 */
@interface KKZBaseNetRequest (HeaderField)
@property (nonatomic, copy, readonly) NSString *appVersion;
@end
