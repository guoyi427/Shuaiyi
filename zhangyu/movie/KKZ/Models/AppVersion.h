//
//  AppVersion.h
//  KoMovie
//
//  Created by Albert on 9/21/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 应用版本的实体类
 */
@interface AppVersion : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *version;
@property (nonatomic) BOOL forceUpdate;
@property (nonatomic, copy) NSString *downloadLink;
@property (nonatomic, copy) NSString *updateMessage;
@end
