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
    return 0.75;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containterView = [transitionContext containerView];
    
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    
    [containterView addSubview:toViewController.view];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        fromViewController.view.alpha = 0.5;
        toViewController.view.frame = finalFrame;
    } completion:^(BOOL finished){
        fromViewController.view.alpha = 1.0;
        [transitionContext completeTransition:YES];
    }];
}

@end