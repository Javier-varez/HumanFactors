//
//  crossGestureRecognizer.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "crossGestureRecognizer.h"

@implementation crossGestureRecognizer

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
    
    if (!self.firstStrokeUp) {
        if (nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y) {
            self.midPoint = nowPoint;
        }
        else if (nowPoint.x <= prevPoint.x && nowPoint.y >= prevPoint.y && self.midPoint.x != 0 && self.midPoint.y != 0) {
            self.firstStrokeUp = YES;
        }
        else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else if (!self.strokeDown) {
        if (nowPoint.x <= prevPoint.x && nowPoint.y >= prevPoint.y) {
            self.midPoint = nowPoint;
        }
        else if (nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y && self.midPoint.x != 0 && self.midPoint.y != 0) {
            self.strokeDown = YES;
        }
        else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else if (nowPoint.x <= prevPoint.x || nowPoint.y >= prevPoint.y) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ((self.state == UIGestureRecognizerStatePossible) && self.firstStrokeUp && self.strokeDown) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.firstStrokeUp = NO;
    self.strokeDown = NO;
    self.midPoint = CGPointZero;
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    [super reset];
    self.firstStrokeUp = NO;
    self.strokeDown = NO;
    self.midPoint = CGPointZero;
}


@end
