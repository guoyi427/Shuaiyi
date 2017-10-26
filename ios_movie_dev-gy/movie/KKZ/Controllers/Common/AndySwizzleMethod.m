//
//  AndySwizzleMethod.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/3.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "AndySwizzleMethod.h"
#import <objc/runtime.h>

void swizzleMethod(Class c,SEL origSEL,SEL newSEL){
    Method originMethod = class_getInstanceMethod(c, origSEL);
    Method newMthod;
    if (!originMethod) {
        originMethod = class_getClassMethod(c, origSEL);
        if (!originMethod) {
            return;
        }
        newMthod = class_getClassMethod(c, newSEL);
        if (!newSEL) {
            return;
        }
    }else {
        newMthod = class_getInstanceMethod(c, newSEL);
        if (!newMthod) {
            return;
        }
    }
    
    if (class_addMethod(c, origSEL, method_getImplementation(newMthod), method_getTypeEncoding(newMthod))) {
        //自身已经有了就添加不成功，直接交换即可
        class_replaceMethod(c, newSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, newMthod);
    }
}
