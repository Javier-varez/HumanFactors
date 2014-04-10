//
//  HFPDetailViewController.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "HFPDetailViewController.h"
#import "HFPStatsTableViewController.h"
#import "HFPUsernameViewController.h"

#import "tickGestureRecognizer.h"
#import "crossGestureRecognizer.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)

@interface HFPDetailViewController ()

@end

@implementation HFPDetailViewController {
    NSDate *_initialDate;
    
    CGRect openKeyboardFrame;
    CGRect closedKeyboardFrame;
    BOOL setKeyboards;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    //Set navigarion bar titleView
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ILOVETYPO.png"]];
    view.center = [self navigationItem].titleView.center;
    view.frame = CGRectMake(view.center.x - 98/2, view.center.y - 25/2, 98, 25);
    [self navigationItem].titleView = view;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"User"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HFPUsernameViewController* usernameVC = [storyboard instantiateViewControllerWithIdentifier:@"UserVC"];
        
        [self presentViewController:usernameVC animated:YES completion:nil];
    }
    
    tickGestureRecognizer *tickGesture = [[tickGestureRecognizer alloc] initWithTarget:self action:@selector(saveCurrentMeasure:)];
    [self.view addGestureRecognizer:tickGesture];
    tickGesture.delegate = self;
    self.tickImageView.alpha = 0.0;
    
    crossGestureRecognizer *crossGesture = [[crossGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCurrentMeasure:)];
    crossGesture.delegate = self;
    [self.view addGestureRecognizer:crossGesture];
    
    self.crossImageView.alpha = 0.0;
}

-(void)saveCurrentMeasure:(tickGestureRecognizer*)gesture {
    NSLog(@"Tick Gesture received");
    
    if (self.currentPhraseMeasure) {
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        self.currentPhraseMeasure = nil;
        self.textView.text = @"";
        
        self.tickImageView.frame = CGRectMake(98, 165-(!IS_IPHONE_5 * 40), 125, 92);
        [UIView animateKeyframesWithDuration:1.0
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.20
                                                                    animations:^{
                                                                        self.tickImageView.alpha = 1.0;
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:1.0
                                                                    animations:^{
                                                                        self.tickImageView.frame = CGRectMake(44, 124-(!IS_IPHONE_5 * 40), 233, 174);
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.80
                                                              relativeDuration:0.20
                                                                    animations:^{
                                                                        self.tickImageView.alpha = 0.0;
                                                                    }];
                                  }
                                  completion:^(BOOL finished){
                                      self.tickImageView.frame = CGRectMake(98, 165-(!IS_IPHONE_5 * 40), 125, 92);
                                  }];
    }
}

-(void)deleteCurrentMeasure:(crossGestureRecognizer*)gesture {
    NSLog(@"Cross Gesture received");
    
    if (self.currentPhraseMeasure) {
        [self.currentPhraseMeasure deleteEntity];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        self.currentPhraseMeasure = nil;
        self.textView.text = @"";
        
        self.crossImageView.frame = CGRectMake(114, 165-(!IS_IPHONE_5 * 40), 92, 92);
        [UIView animateKeyframesWithDuration:1.0
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.20
                                                                    animations:^{
                                                                        self.crossImageView.alpha = 1.0;
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:1.0
                                                                    animations:^{
                                                                        self.crossImageView.frame = CGRectMake(73, 124-(!IS_IPHONE_5 * 40), 174, 174);
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.80
                                                              relativeDuration:0.20
                                                                    animations:^{
                                                                        self.crossImageView.alpha = 0.0;
                                                                    }];
                                  }
                                  completion:^(BOOL finished){
                                      self.crossImageView.frame = CGRectMake(114, 165-(!IS_IPHONE_5 * 40), 92, 92);
                                  }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView {
    if (!self.currentPhraseMeasure) {
        self.currentPhraseMeasure = [PhraseMeasure createEntity];
        self.currentPhraseMeasure.keyboard = [self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]];
    }
    
    //Set initial date
    if (!self.currentPhraseMeasure.initialDate) {
        self.currentPhraseMeasure.initialDate = [NSDate date];
    }
    
    //Update number of taps and text
    self.currentPhraseMeasure.taps = @([self.currentPhraseMeasure.taps integerValue] + 1);
    self.currentPhraseMeasure.text = self.textView.text;
    
    //Update time interval if taps >= 2...
    if ([self.currentPhraseMeasure.taps integerValue] >= 2) {
        self.currentPhraseMeasure.timeInterval = @([[NSDate date] timeIntervalSinceDate:self.currentPhraseMeasure.initialDate]);
    }
}

-(void)keyboardWillShow:(NSNotification*)aNotification {
    [self moveViewForKeyboard:aNotification up:YES];
}

-(void)keyboardWillHide:(NSNotification*)aNotification {
    [self moveViewForKeyboard:aNotification up:NO];
}

- (void)moveViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    
    if (!setKeyboards) {
        NSDictionary* userInfo = [aNotification userInfo];
        
        // Get animation info from userInfo
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        // Animate up or down
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        CGRect newFrame = self.view.frame;
        CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
        
        closedKeyboardFrame = self.view.frame;
        
        newFrame.size.height += (up? -1 : 1) * keyboardFrame.size.height;
        
        //Frames for every chance
        NSLog(@"%f, %f\n", newFrame.size.width, newFrame.size.height);
        NSLog(@"%f, %f\n", newFrame.origin.x, newFrame.origin.y);
        
        self.view.frame = newFrame;
        
        openKeyboardFrame = self.view.frame;
        setKeyboards = !setKeyboards;
        
        [UIView commitAnimations];
    }
    else {
        if (up) {
            self.view.frame = openKeyboardFrame;
        }
        else {
            self.view.frame = closedKeyboardFrame;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.textView resignFirstResponder];
}

- (IBAction)SCValueChanged:(id)sender {
    if (self.currentPhraseMeasure) {
        self.currentPhraseMeasure.keyboard = [self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]];

    }
}

- (IBAction)presentStats:(id)sender {
    if (self.currentPhraseMeasure){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save?"
                                                        message:@"Do you wish to save last measurement?"
                                                       delegate:self
                                              cancelButtonTitle:@"Save"
                                              otherButtonTitles:@"Discard...",nil];
        [alert show];
    }
    else {
        UIStoryboard *Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HFPStatsTableViewController *toVC = [Storyboard instantiateViewControllerWithIdentifier:@"StatsVC"];
        [self.navigationController pushViewController:toVC animated:YES];
    }
}


#pragma mark Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (self.currentPhraseMeasure) {
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
            self.currentPhraseMeasure = nil;
            self.textView.text = @"";
        }
    }
    else {
        if (self.currentPhraseMeasure) {
            [self.currentPhraseMeasure deleteEntity];
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
            self.currentPhraseMeasure = nil;
            self.textView.text = @"";
        }
    }
    
    UIStoryboard *Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    HFPStatsTableViewController *toVC = [Storyboard instantiateViewControllerWithIdentifier:@"StatsVC"];
    [self.navigationController pushViewController:toVC animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // return YES (the default) to allow the gesture recognizer to examine the touch object, NO to prevent the gesture recognizer from seeing this touch object.
    if([touch.view isKindOfClass:[UISegmentedControl class]] == YES) {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
