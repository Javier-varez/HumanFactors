//
//  HFPStatsTableViewController.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFPStatsTableViewController : UITableViewController <UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

- (IBAction)clearDataButtonPressed:(id)sender;
@end
