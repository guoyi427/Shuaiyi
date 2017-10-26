//
//  UserGroup.h
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserGroup : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *groupCode;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSNumber *groupID;
@end
