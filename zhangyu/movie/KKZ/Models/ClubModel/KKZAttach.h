//
//  KKZAttach.h
//  KoMovie
//
//  Created by Albert on 26/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface KKZAttach : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *attachId;
@property (nonatomic, copy) NSString *url;
@end
