//
//  FlipAnimationController.m
//  ILoveCatz
//
//  Created by Francisco Javier Álvarez García on 07/04/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "FlipAnimationController.h"

@implementation FlipAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34 = -0.002;
    
    [containerView.layer setSublayerTransform:transform];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    fromViewController.view.frame = initialFrame;
    toViewController.view.frame = initialFrame;
    
    float factor = self.reverse ? 1.0 : -1.0;
    
    toViewController.view.layer.transform = [self yRotation:factor * -M_PI_2];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    fromViewController.view.layer.transform = [self yRotation:factor * M_PI_2];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    toViewController.view.layer.transform = [self yRotation:0.0];
                                                                }];
                              }
                              completion:^(BOOL finished){
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}

-(CATransform3D)yRotation:(CGFloat)angle {
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

@end
