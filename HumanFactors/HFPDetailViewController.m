//
//  HFPDetailViewController.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "HFPDetailViewController.h"
@interface HFPDetailViewController ()

@end

@implementation HFPDetailViewController {
    NSDate *_initialDate;
    NSDate *_currentDate;
    NSUInteger numData;
    double total;
    
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
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ILOVETYPO.png"]];

    view.center = [self navigationItem].titleView.center;
    
    view.frame = CGRectMake(view.center.x - 98/2, view.center.y - 25/2, 98, 25);
    
    [self navigationItem].titleView = view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView {
    NSDate *date = [NSDate date];
    
    numData++;
    
    if (_currentDate) {
        total = [date timeIntervalSinceDate:_initialDate];
        self.label.text = [NSString stringWithFormat:@"TPM: %d",(int)(60/(total/(double)numData))];
        self.letterCountLabel.text = [NSString stringWithFormat:@"CPM: %d", (int)(60/(total/(double)self.textView.text.length))];
    }
    else {
        _initialDate = date;
    }
    
    _currentDate = date;
    
    if (_initialDate) {
        self.secondsLabel.text = [NSString stringWithFormat:@"Eff: %f", (double)self.textView.text.length/numData];
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

- (IBAction)resetButtonPressed:(id)sender {
    _currentDate = nil;
    _initialDate = nil;
    total = 0.0;
    numData = 0;
    
    self.textView.text = @"";
    self.label.text = @"TPM: 0";
    self.letterCountLabel.text = @"CPM: 0";
    self.secondsLabel.text = @"Eff: 0";
}


@end
