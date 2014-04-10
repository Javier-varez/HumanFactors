//
//  BouncePresentAnimationController.m
//  ILoveCatz
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containterView = [transitionContext containerView];
    
    CGRect initialFrame = CGRectMake(finalFrame.size.width/2.0 - 0.1*finalFrame.size.width/2.0,
                                     finalFrame.size.height/2.0 - 0.1*finalFrame.size.height/2.0,
                                     0.1*finalFrame.size.width ,
                                     0.1*finalFrame.size.height);
    
    toViewController.view.frame = finalFrame;
    
    UIView *snapshot = [toViewController.view snapshotViewAfterScreenUpdates:YES];
    
    snapshot.frame = initialFrame;
    
    [containterView addSubview:snapshot];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            fromViewController.view.alpha = 0.5;
                            snapshot.frame = finalFrame;
                        }
                     completion:^(BOOL finished){
                            fromViewController.view.alpha = 1.0;
                            [snapshot removeFromSuperview];
                            [containterView addSubview:toViewController.view];
                            [transitionContext completeTransition:YES];
                        }];
}

@end