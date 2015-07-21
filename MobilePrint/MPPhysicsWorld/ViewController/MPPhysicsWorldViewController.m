//
//  MPPhysicsWorldViewController.m
//  MobilePrint
//
//  Created by guoyi on 15/6/13.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPPhysicsWorldViewController.h"

#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

//  View
#import "Masonry.h"
#import "MPGameShankView.h"

//  Scene
#import "MPMazeFloor.h"
#import "MPMazeBox.h"

/// 随即位置的基数
#define RandomNumber 100

/// 陀螺仪更新时间
#define MotionTimerInterval 0.01

/// 3D文字
#define Text_Drop3DModel @"郭毅就是辣么帅！"

/// 下落方块的时间间隔
static NSUInteger dropBoxInterval = 30;

@interface MPPhysicsWorldViewController ()<SCNPhysicsContactDelegate,MPGameShankViewDelegate>
{
    //  Data
    /// 缓存所有坠落动画的3DO型  元素为：Node
    NSMutableArray * _dropNodeCache;
    /// 陀螺仪管理器
    CMMotionManager * _motionManager;
    /// 坠落方块的定时器
    NSTimer * _updateTimer;
    /// 当前坠落方块的时间间隔
    NSInteger _currentInterval;
    
    //  Scene
    /// 场景
    SCNScene * _scene;
    /// 实例化 3D展现视图
    SCNView * _sceneView;
    /// 迷宫地面节点
    MPMazeFloor * _floorNode;
    /// 实例化摄像机节点
    SCNNode * _cameraNode;
    /// 正在坠落的盒子
    MPMazeBox *_currentDropBox;
    
    //  UI
    
}

@end

@implementation MPPhysicsWorldViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareScene];
    [self _prepareSceneKitModels];
    [self _prepareUI];
}

#pragma mark - Prepare  准备方法

- (void)_prepareData {
    //  实例化 球体节点的缓存
    _dropNodeCache = [NSMutableArray array];
    
}

- (void)_prepareScene {
    
    //  实例化场景
    _scene = [SCNScene scene];
    //  设置 物理世界的代理~
    _scene.physicsWorld.contactDelegate = self;
    _scene.physicsWorld.gravity = SCNVector3Make(0, -9.8, 0);
    
    /// 实例化摄像机节点
    _cameraNode = [SCNNode node];
    _cameraNode.camera = [SCNCamera camera];
    _cameraNode.position = SCNVector3Make(0, 0, 50);
    [_scene.rootNode addChildNode:_cameraNode];
    
    /// 实例化 灯光
    SCNNode * lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 100, 100);
    [_scene.rootNode addChildNode:lightNode];
    
    /// 实例化 环绕光
    SCNNode * ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [_scene.rootNode addChildNode:ambientLightNode];
    
    _sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    _sceneView.scene = _scene;
    _sceneView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_sceneView];
    
    _sceneView.allowsCameraControl = YES;
    _sceneView.showsStatistics = YES;
}

/// 准备 3D模型
- (void)_prepareSceneKitModels {
    /// 迷宫地面
    _floorNode = [[MPMazeFloor alloc] init];
    [_scene.rootNode addChildNode:_floorNode];
}

/// 准备着落物体
- (void)_prepareDropNode {
    //  循环实例化 需要坠落的节点
    for (int i = 0; i < 100; i ++) {
        /// 随机中心位置
        SCNVector3 randomPosition = SCNVector3Make(arc4random()%RandomNumber - RandomNumber/2.0f,
                                                   arc4random()%RandomNumber,
                                                   arc4random()%RandomNumber);
        /// 随机字体大小
        CGFloat randomFontSize = arc4random()%3 + 2;
        /// 文字
        SCNText * text = [SCNText textWithString:Text_Drop3DModel extrusionDepth:0.25];
        text.font = [UIFont systemFontOfSize:randomFontSize];
        SCNNode * textNode = [SCNNode nodeWithGeometry:text];
        textNode.position = randomPosition;
        textNode.physicsBody = [SCNPhysicsBody dynamicBody];
        [_scene.rootNode addChildNode:textNode];
        [_dropNodeCache addObject:textNode];
    }
}

- (void)_prepareUI {
    /// 清空按钮
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.backgroundColor = [UIColor redColor];
    [clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    __weak UIView * weakView = self.view;
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakView);
        make.top.equalTo(weakView).offset(64);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    /// 开始按钮
    UIButton * startGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startGameButton .backgroundColor = [UIColor greenColor];
    [startGameButton addTarget:self action:@selector(startGameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startGameButton];
    
    [startGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakView);
        make.top.equalTo(weakView).offset(64);
    }];
    
    //  游戏柄
    MPGameShankView *gameShankView = [MPGameShankView gameShankWithSuperView:self.view];
    gameShankView.delegate = self;
}

#pragma mark - Private Methods 私有方法

/// 游戏开始的 更新方法  0.1秒 走一次
- (void)_updateAction {
    //  单位时间内 下落一个方块
    _currentInterval ++;
    if (_currentInterval % dropBoxInterval == 0) {
        
        MPMazeBox *boxNode = [MPMazeBox mazeBox];
        boxNode.position = SCNVector3Make(0, 10, 0);
        [_scene.rootNode addChildNode:boxNode];
        _currentDropBox = boxNode;
    }
    if (_currentDropBox) {
        NSLog(@"x = %f y = %f z = %f",_currentDropBox.position.x,_currentDropBox.position.y,_currentDropBox.position.y);
    }
}

#pragma mark - Button & Gesture Action  按钮 和 手势 触发方式

/// 清空按钮触发方法
- (void)clearButtonAction {
    /// 根节点的 子节点个数
    NSUInteger childNodesCount = _dropNodeCache.count;
    for (int i = 0; i < childNodesCount; i ++) {
        SCNNode * node = _dropNodeCache[i];
        [node removeFromParentNode];
    }
    
    [_dropNodeCache removeAllObjects];
    
    [self _prepareDropNode];
}

/// 开始按钮触发方法
- (void)startGameButtonAction {
    if (!_updateTimer) {
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_updateAction) userInfo:nil repeats:YES];
    }
}

#pragma mark - Physics World - ContactDelegate  物理世界的碰撞代理

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {

}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact {

}

- (void)physicsWorld:(SCNPhysicsWorld *)world didEndContact:(SCNPhysicsContact *)contact {
    //  判断清除碰撞到地面的坠落物体    参数为两个碰撞物体
    NSLog(@"physics contact = %@",contact);
}

#pragma mark - GameShank - Delegate 游戏柄代理

/// 触摸 代理
- (void)gameShankView:(MPGameShankView *)gameShankView touchMove:(CGPoint)point {
    NSLog(@"point = %@",NSStringFromCGPoint(point));
    CGFloat multiple = 0.1;
    _currentDropBox.position = SCNVector3Make(_currentDropBox.position.x + point.x * multiple,
                                              _currentDropBox.position.y,
                                              _currentDropBox.position.z + point.y * multiple);

    
}

@end
