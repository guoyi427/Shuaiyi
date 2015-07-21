//
//  MPDrawBoardViewController.m
//  MobilePrint
//
//  Created by GuoYi on 15/4/9.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPDrawBoardViewController.h"

#import <SceneKit/SceneKit.h>

//  View
#import "Masonry.h"

@interface MPDrawBoardViewController ()
{
    /// 场景
    SCNScene * _scene;
    /// 三角铁节点
    SCNNode * _torusNode;
    /// 球体节点
    SCNNode * _sphereNode;
}
@end

@implementation MPDrawBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //  准备场景
    [self _prepareScene];
    
    //  准备其他 对象 到场景中
    [self _prepareOtherNodeInScene];
    
    //  准备 UIKit 空间
    [self _prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

/// 准备场景
- (void)_prepareScene {
    //  创建场景
    _scene = [SCNScene scene];
    
    //  创建摄影 并加入到 场景中
    SCNNode * cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 30);
    [_scene.rootNode addChildNode:cameraNode];
    
    //  创建灯光
    SCNNode * lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(10, 10, 10);
    [_scene.rootNode addChildNode:lightNode];
    
    //  创建环绕灯光
    SCNNode * ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [_scene.rootNode addChildNode:ambientLightNode];
    
    //  将场景 加载到 视图上
    SCNView * sceneView = [[SCNView alloc] initWithFrame:self.view.bounds];
    sceneView.backgroundColor = [UIColor blackColor];
    sceneView.scene = _scene;
    [self.view addSubview:sceneView];
    
    //  打开摄像操控
    sceneView.allowsCameraControl = YES;
    
    //  打开定时信息
    sceneView.showsStatistics = YES;
}

/// 准备其他节点 加入到场景当中
- (void)_prepareOtherNodeInScene {
    
    /// 球体
    SCNSphere * sphere = [SCNSphere sphereWithRadius:1.0f];
    _sphereNode = [SCNNode nodeWithGeometry:sphere];
    _sphereNode.position = SCNVector3Make(0, 8, 0);
    [_scene.rootNode addChildNode:_sphereNode];
    
    /// 左侧球体
    SCNSphere * leftSphere = [SCNSphere sphereWithRadius:1.5f];
    SCNNode * leftSphereNode = [SCNNode nodeWithGeometry:leftSphere];
    leftSphereNode.position = SCNVector3Make(-4, 0, 0);
    [_sphereNode addChildNode:leftSphereNode];
    
    /// 环
    SCNTorus * torus = [SCNTorus torusWithRingRadius:2 pipeRadius:0.5];
    torus.ringSegmentCount = 6;
    torus.pipeSegmentCount = 24;
    _torusNode = [SCNNode nodeWithGeometry:torus];
    _torusNode.position = SCNVector3Make(0, 0, 0);
    _torusNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0);
    [_scene.rootNode addChildNode:_torusNode];
    
    NSLog(@"torus = %@",_torusNode.description);

}

/// 准备UIKit的控件
- (void)_prepareUI {
    /// 动画 按钮
    UIButton *animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animationButton.backgroundColor = [UIColor magentaColor];
    [animationButton addTarget:self action:@selector(animationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animationButton];
    
    __weak UIView * weakView = self.view;
    [animationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakView).offset(64);
        make.right.equalTo(weakView);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

#pragma mark - Private Methods


#pragma mark - UIButton & Gesture Action

/// 动画按钮触发方法
- (void)animationButtonAction {

    /*
    //  环 动画
    [_torusNode removeAllAnimations];
    
    //  旋转动画
    CATransform3D rotation = CATransform3DMakeRotation(M_PI / 2.0f, 1, 1, 1);
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotation];
    animation.duration= 0.25;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount = FLT_MAX;
    [_torusNode addAnimation:animation forKey:nil];
    */
    
    //  球体 动画
    [_sphereNode removeAllAnimations];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 10);
    
    CABasicAnimation *sphereAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
    
    sphereAnimation.toValue= [NSValue valueWithCATransform3D:transform];
    sphereAnimation.duration= 0.25;
    sphereAnimation.removedOnCompletion=NO;
    sphereAnimation.fillMode=kCAFillModeForwards;
    
    
    CATransform3D transformRotaion = CATransform3DMakeRotation(M_PI * 2 * 1.5 / 12, 1, 0,0);
    
    CABasicAnimation *sphereAnmation2 = [CABasicAnimation animationWithKeyPath:@"rotation"];
    sphereAnmation2.toValue = [NSValue valueWithCATransform3D:transformRotaion];
    sphereAnmation2.duration = 0.25;
    sphereAnmation2.removedOnCompletion = NO;
    sphereAnmation2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *sphereAnmationGroup = [CAAnimationGroup animation];
    sphereAnmationGroup.animations = @[sphereAnimation, sphereAnmation2];
    sphereAnmationGroup.duration = 0.25;
    sphereAnmationGroup.removedOnCompletion = NO;
    sphereAnmationGroup.fillMode = kCAFillModeForwards;
    
    [_sphereNode addAnimation:sphereAnimation forKey:nil];
}


@end
