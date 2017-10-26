//
//  OrderCommentInfo.h
//  KoMovie
//
//  Created by Albert on 01/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderCommentInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *commentId;
@property (nonatomic, copy) NSNumber *integral;
@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSNumber *userId;
@end
