//
//  FlipAnimationController.h
//  ILoveCatz
//
//  Created by Francisco Javier Álvarez García on 07/04/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlipAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL reverse;

@end
