//
//  CommentOrder.h
//  KoMovie
//
//  Created by Albert on 01/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "Ticket.h"
#import "OrderCommentInfo.h"


@interface CommentOrder : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) Ticket *plan;

@property (nonatomic, strong) OrderCommentInfo *commentOrder;

@end
