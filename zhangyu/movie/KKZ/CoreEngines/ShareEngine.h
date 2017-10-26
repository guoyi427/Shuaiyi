//
//  DataEngine.h
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApiObject.h"


@interface ShareEngine : NSObject <ISSShareViewDelegate>{

    
}


+ (ShareEngine *)shareEngine;

- (void)shareToSinaWeiBo:(NSString *)content
                   title:(NSString *)title
                   image:(UIImage *)image
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type;

- (void)shareToQQWeiBo:(NSString *)content
                   title:(NSString *)title
                 image:(UIImage *)image
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type;

- (void)inviteFromWeiBo:(NSString *)content
               username:(NSString *)username
                   title:(NSString *)title
                  image:(UIImage *)image
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type;

- (void)shareToRenRen:(NSString *)content
                   title:(NSString *)title
                image:(UIImage *)image
                     url:(NSString *)url
          description:(NSString*)description
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type;

- (void)shareToWeiXin:(NSString *)content
                title:(NSString *)title
                image:(UIImage *)image
                  url:(NSString *)url
             soundUrl:(NSString *)sUrl
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type;

- (void)shareToQZone:(NSString *)content
                title:(NSString *)title
               image:(UIImage *)image
            imageURL:(NSString*)imageURL
                  url:(NSString *)url
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type;






- (void)shareToSinaWeiBo:(NSString *)content
                   title:(NSString *)title
                   imageUrl:(NSString *)imageUrl
                     url:(NSString *)url
                delegate:(id)viewDelegate
               mediaType:(SSPublishContentMediaType)mediaType
                    type:(ShareType)type;


- (void)inviteFromWeiBo:(NSString *)content
               username:(NSString *)username
                  title:(NSString *)title
                  imageUrl:(NSString *)imageUrl
                    url:(NSString *)url
               delegate:(id)viewDelegate
              mediaType:(SSPublishContentMediaType)mediaType
                   type:(ShareType)type;


- (void)shareToWeiXin:(NSString *)content
                title:(NSString *)title
               imageUrl:(NSString *)imageUrl
                  url:(NSString *)url
             soundUrl:(NSString *)sUrl
             delegate:(id)viewDelegate
            mediaType:(SSPublishContentMediaType)mediaType
                 type:(ShareType)type;

- (void)shareToQZone:(NSString *)content
               title:(NSString *)title
              imageUrl:(NSString *)imageUrl
            imageURL:(NSString*)imageURL
                 url:(NSString *)url
            delegate:(id)viewDelegate
           mediaType:(SSPublishContentMediaType)mediaType
                type:(ShareType)type;
@end

