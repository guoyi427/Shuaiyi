//
//  MPMazeBox.m
//  MobilePrint
//
//  Created by guoyi on 15/7/10.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPMazeBox.h"

@implementation MPMazeBox

/// 便利构造器 创造一个 带物理属性的盒子
+ (instancetype)mazeBox {
   
    // 10个 单位时间 下落一个方块
    SCNBox * box = [SCNBox boxWithWidth:arc4random()%2 + 1
                                 height:arc4random()%2 + 1
                                 length:arc4random()%2 + 1
                          chamferRadius:0];
    
    /// 物理属性
    SCNPhysicsBody * boxPhysics = [SCNPhysicsBody dynamicBody];
    boxPhysics.charge = 10;
    boxPhysics.friction = 10;
    boxPhysics.restitution = 0.0f;
    boxPhysics.rollingFriction = 10;
    
    /// 盒子节点
    MPMazeBox * boxNode = (MPMazeBox *)[self nodeWithGeometry:box];
    boxNode.physicsBody = boxPhysics;
    
    return boxNode;
}

@end
