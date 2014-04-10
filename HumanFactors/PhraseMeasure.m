//
//  PhraseMeasure.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 08/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "PhraseMeasure.h"


@implementation PhraseMeasure

@dynamic text;
@dynamic timeInterval;
@dynamic taps;
@dynamic initialDate;
@dynamic keyboard;

- (NSComparisonResult)compare:(PhraseMeasure *)otherObject {
    return [self.initialDate compare:otherObject.initialDate];
}

@end
