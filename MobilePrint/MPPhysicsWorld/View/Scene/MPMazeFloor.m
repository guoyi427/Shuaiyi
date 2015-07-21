//
//  MPMazeFloor.m
//  MobilePrint
//
//  Created by guoyi on 15/6/16.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPMazeFloor.h"

/// 迷宫墙壁厚度
#define Thickness_MazeFloor 0.5
/// 迷宫墙壁高度
#define Height_MazeFloor 1
/// 正方形 迷宫外墙的 边长
#define Lenght_MazeFloor 10

@implementation MPMazeFloor

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _prepare];
    }
    return self;
}

#pragma mark - Prepare Scene

/// 准备场景
- (void)_prepare {
    /// 地板
    SCNFloor * floor = [SCNFloor floor];
    self.geometry = floor;
    self.position = SCNVector3Make(0, -20, 0);
    
    /// 物理属性
    SCNPhysicsBody *body = [SCNPhysicsBody staticBody];
    body.restitution = 10;
    body.rollingFriction = 10;
    body.friction = 10;
    
    self.physicsBody = body;
    
    [self _prepareMazeFloor];
}

/// 准备迷宫墙壁
- (void)_prepareMazeFloor {
    /// 后面 墙壁
    SCNBox * topFloor = [SCNBox boxWithWidth:Lenght_MazeFloor height:Height_MazeFloor length:Thickness_MazeFloor chamferRadius:2];
    SCNNode * topFloorNode = [SCNNode nodeWithGeometry:topFloor];
    topFloorNode.position = SCNVector3Make(0, Height_MazeFloor / 2.0f, -Lenght_MazeFloor/2.0f);
    topFloorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self addChildNode:topFloorNode];
    
    /// 左侧 墙壁
    SCNBox * leftFloor = [SCNBox boxWithWidth:Thickness_MazeFloor height:Height_MazeFloor length:Lenght_MazeFloor chamferRadius:2];
    SCNNode * leftFloorNode = [SCNNode nodeWithGeometry:leftFloor];
    leftFloorNode.position = SCNVector3Make(-Lenght_MazeFloor / 2.0f, Height_MazeFloor / 2.0f, 0);
    leftFloorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self addChildNode:leftFloorNode];
    
    /// 右侧 墙壁
    SCNBox * rightFloor = [SCNBox boxWithWidth:Thickness_MazeFloor height:Height_MazeFloor length:Lenght_MazeFloor chamferRadius:2];
    SCNNode * rightFloorNode = [SCNNode nodeWithGeometry:rightFloor];
    rightFloorNode.position = SCNVector3Make(Lenght_MazeFloor / 2.0f, Height_MazeFloor / 2.0f, 0);
    rightFloorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self addChildNode:rightFloorNode];
    
    /// 前面 墙壁
    SCNBox * bottomFloor = [SCNBox boxWithWidth:Lenght_MazeFloor height:Height_MazeFloor length:Thickness_MazeFloor chamferRadius:2];
    SCNNode * bottomFloorNode = [SCNNode nodeWithGeometry:bottomFloor];
    bottomFloorNode.position = SCNVector3Make(0, Height_MazeFloor / 2.0f, Lenght_MazeFloor / 2.0f);
    bottomFloorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self addChildNode:bottomFloorNode];
    
}

@end
