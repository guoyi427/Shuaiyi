//
//  SinaClient.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "OAuthClient.h"
#import "OAuthRequest.h"

@interface SinaClient : OAuthClient <OAuthRequestDelegate> {
    OAuthRequest *request;
}

@property (nonatomic, retain) OAuthRequest *request;

+ (SinaClient *)sharedSinaClient;
- (void)startXAuthWithId:(NSString *)theUserID andPassword:(NSString *)thePassword;

@end
