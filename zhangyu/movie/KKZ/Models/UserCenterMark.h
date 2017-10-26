//
//  UserCenterMark.h
//  KoMovie
//
//  Created by Albert on 26/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserCenterMark : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *externToken;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;
@end
