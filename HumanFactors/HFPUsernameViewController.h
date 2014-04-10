//
//  HFPUsernameViewController.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFPUsernameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) BOOL allowSwipeDown;

- (IBAction)buttonPressed:(id)sender;
@end
