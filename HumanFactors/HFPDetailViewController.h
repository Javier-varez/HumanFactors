//
//  HFPDetailViewController.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFPDetailViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *letterCountLabel;
- (IBAction)resetButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@end
