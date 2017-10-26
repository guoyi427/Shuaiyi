//
//  VerificationCodeTask.m
//  KoMovie
//
//  Created by KKZ on 15/11/11.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "VerificationCodeTask.h"

@implementation VerificationCodeTask


- (id)initVerificationCodeWithCodeKey:(NSString *)codekey andCodeText:(NSString *)codeText andActionName:(NSString *)actionname finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeVerificationCode;
        
        self.codeKey = codekey;
        self.codeText = codeText;
        self.actionName = actionname;
        
        self.finishBlock = block;
    }
    return self;
}


- (id)initResetVerificationCodeFinished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeResetVerificationCode;
        self.finishBlock = block;
    }
    return self;
}


- (void)getReady {
    if (taskType == TaskTypeVerificationCode) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"authcode_Check" forKey:@"action"];
        [self addParametersWithValue:self.codeKey forKey:@"code_key"];
        [self addParametersWithValue:self.codeText forKey:@"valid_code"];
        [self addParametersWithValue:self.actionName forKey:@"action_name"];
        [self setRequestMethod:@"GET"];
    }
    
    if (taskType == TaskTypeResetVerificationCode) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"authcode_Reset" forKey:@"action"];
        [self setRequestMethod:@"GET"];
    }

}

- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeVerificationCode) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeActivityList task succeded: %@", dict);
        [self doCallBack:YES info:nil];
        
    }else if (taskType == TaskTypeResetVerificationCode) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeActivityList task succeded: %@", dict);
        NSDictionary *code = result[@"code"];
        NSString *codeKeyCurrent = code[@"codeKey"];
        NSString *codeUrl = code[@"codeUrl"];
        if (codeKeyCurrent.length && codeUrl.length) {
            
        }
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:codeKeyCurrent,@"codeKeyCurrent",codeUrl,@"codeUrl",nil]];
        
    }
}


- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeVerificationCode) {
        DLog(@"TaskTypeVerificationCode task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeResetVerificationCode) {
        DLog(@"TaskTypeResetVerificationCode task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }

}

@end
