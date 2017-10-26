//
//  KKZAuthor.h
//  KoMovie
//
//  Created by Albert on 24/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface KKZAuthor : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *userGroup;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSNumber *userGroupId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *rel;
@end
