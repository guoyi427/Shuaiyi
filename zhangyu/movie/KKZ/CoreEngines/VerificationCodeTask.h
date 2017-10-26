//
//  VerificationCodeTask.h
//  KoMovie
//
//  Created by KKZ on 15/11/11.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface VerificationCodeTask : NetworkTask

@property(nonatomic,copy)NSString *codeKey;
@property(nonatomic,copy)NSString *codeText;
@property(nonatomic,copy)NSString *actionName;

- (id)initVerificationCodeWithCodeKey:(NSString *)codekey andCodeText:(NSString *)codeText andActionName:(NSString *)actionname finished:(FinishDownLoadBlock)block;
- (id)initResetVerificationCodeFinished:(FinishDownLoadBlock)block;
@end
