//
//  ShrinkDismissAnimationController.m
//  ILoveCatz
//
//  Created by Francisco Javier Álvarez García on 07/04/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "ShrinkDismissAnimationController.h"

@implementation ShrinkDismissAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    
    toViewController.view.frame = finalFrame;
    toViewController.view.alpha = 0.5;
    
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGRect shrunkenFrame = CGRectInset(fromViewController.view.frame,
                                       fromViewController.view.frame.size.width/4.0,
                                       fromViewController.view.frame.size.height/4.0);
    
    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *intermediateView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    
    [containerView addSubview:intermediateView];
    
    [fromViewController.view removeFromSuperview];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    intermediateView.frame = shrunkenFrame;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    intermediateView.frame = fromFinalFrame;
                                                                    toViewController.view.alpha = 1.0;
                                                                }];
                              }
                              completion:^(BOOL finished){
                                  [intermediateView removeFromSuperview];
                                  [transitionContext completeTransition:YES];
                              }];
}

@end
