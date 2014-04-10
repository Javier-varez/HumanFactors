//
//  tickGestureRecognizer.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "tickGestureRecognizer.h"

@implementation tickGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    UIWindow *win = [self.view window];
    CGPoint nowPoint = [touches.anyObject locationInView:win];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    // strokeUp is a property
    if (!self.strokeUp) {
        // On downstroke, both x and y increase in positive direction
        if (nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y) {
            self.midPoint = nowPoint;
            // Upstroke has increasing x value but decreasing y value
        } else if (nowPoint.x >= self.midPoint.x && nowPoint.y <= self.midPoint.y) {
            self.strokeUp = YES;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else {
        if (!(nowPoint.x >= self.midPoint.x && nowPoint.y <= self.midPoint.y)) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint nowPoint = [touches.anyObject locationInView:[self.view window]];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    if ((self.state == UIGestureRecognizerStatePossible) && self.strokeUp && nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    [super reset];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
}

@end
