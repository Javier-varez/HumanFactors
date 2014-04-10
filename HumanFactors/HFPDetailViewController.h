//
//  HFPDetailViewController.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhraseMeasure.h"

@interface HFPDetailViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) PhraseMeasure *currentPhraseMeasure;
@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crossImageView;

- (IBAction)SCValueChanged:(id)sender;
- (IBAction)presentStats:(id)sender;
@end
