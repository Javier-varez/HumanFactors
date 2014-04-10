//
//  PhraseMeasure.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 08/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhraseMeasure : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) NSNumber * taps;
@property (nonatomic, retain) NSDate * initialDate;
@property (nonatomic, retain) NSString * keyboard;

- (NSComparisonResult)compare:(PhraseMeasure *)otherObject;

@end
