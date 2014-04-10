//
//  HFPStatsTableViewController.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "HFPStatsTableViewController.h"
#import "PhraseMeasure.h"
#import "HFPPhraseMeasureTableViewCell.h"
#import "HFPUsernameViewController.h"

#import "BouncePresentAnimationController.h"
#import "ShrinkDismissAnimationController.h"

@interface HFPStatsTableViewController () {
    BouncePresentAnimationController *_bounceAnimation;
    ShrinkDismissAnimationController *_shrinkAnimation;
}

@end

@implementation HFPStatsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dataArray = [[PhraseMeasure findAll] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return [self.dataArray count];
    else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *reuseIdentifier = @"PhraseMeasureIdentifier";
        
        HFPPhraseMeasureTableViewCell *cellForPhraseMeasure = (HFPPhraseMeasureTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        PhraseMeasure *measureForCurrentCell = [self.dataArray objectAtIndex:indexPath.row];
        
        cellForPhraseMeasure.charactersPerMinuteLabel.text = [NSString stringWithFormat:@"%d", (int)([measureForCurrentCell.text length] / ([measureForCurrentCell.timeInterval doubleValue]/60.0))];
        
        cellForPhraseMeasure.efficiencyLabel.text = [NSString stringWithFormat:@"%.3f", (double)[measureForCurrentCell.text length]/[measureForCurrentCell.taps doubleValue]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMMM dd 'at' HH:mm";
        cellForPhraseMeasure.dateLabel.text = [dateFormatter stringFromDate:measureForCurrentCell.initialDate];
        
        cellForPhraseMeasure.keyboardLabel.text = measureForCurrentCell.keyboard;
        
        cell = (UITableViewCell*)cellForPhraseMeasure;
    }
    else {
        static NSString *reuseIdentifier = @"userIdentifier";

        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Username: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"User"]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 105.0;
    else return 44.0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Measurements";
    else return @"Logged as";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HFPUsernameViewController *userVC = [storyboard instantiateViewControllerWithIdentifier:@"UserVC"];
        userVC.allowSwipeDown = YES;
        
        userVC.transitioningDelegate = self;
        
        [self presentViewController:userVC animated:YES completion:nil];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return YES;
    else return NO;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return YES;
    else return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0) {
        // Delete the row from the data source
        PhraseMeasure *measureToDelete = [self.dataArray objectAtIndex:indexPath.row];
        NSMutableArray *array = [self.dataArray mutableCopy];
        [array removeObject:measureToDelete];
        self.dataArray = [array copy];
        [measureToDelete deleteEntity];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert && indexPath.section == 0) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Methods related to CSV Export...

-(NSString*)stringFromData {
    NSString *finalString;
    
    finalString = [NSString stringWithFormat:@" ,%@\niPhone W/O, ", [[NSUserDefaults standardUserDefaults] objectForKey:@"User"]];
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"iPhone W/O"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length] / ([measure.timeInterval doubleValue]/60.0)];
        }
    }
    finalString = [finalString stringByAppendingString:@"\niPhone W, "];
    
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"iPhone W"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length] / ([measure.timeInterval doubleValue]/60.0)];
        }
    }
    finalString = [finalString stringByAppendingString:@"\nFleksy, "];
    
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"Fleksy"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length] / ([measure.timeInterval doubleValue]/60.0)];
        }
    }
    finalString = [finalString stringByAppendingString:@"\n"];
    
    finalString = [finalString stringByAppendingFormat:@"\n\n ,%@\niPhone W/O, ", [[NSUserDefaults standardUserDefaults] objectForKey:@"User"]];
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"iPhone W/O"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length]/[measure.taps doubleValue]];
        }
    }
    finalString = [finalString stringByAppendingString:@"\niPhone W, "];
    
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"iPhone W"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length]/[measure.taps doubleValue]];
        }
    }
    finalString = [finalString stringByAppendingString:@"\nFleksy, "];
    
    for (PhraseMeasure* measure in self.dataArray) {
        if ([measure.keyboard isEqualToString: @"Fleksy"]) {
            finalString = [finalString stringByAppendingFormat:@"%f,", (double)[measure.text length]/[measure.taps doubleValue]];
        }
    }
    finalString = [finalString stringByAppendingString:@"\n"];
    
    return finalString;
}

- (IBAction)exportData:(id)sender {
    if (self.dataArray && [self.dataArray count] != 0) {
        NSString *stringToExport = [self stringFromData];
        
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Export.csv"];
        
        [stringToExport writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
        
        if (path) {
            
            NSURL *URLMolona = [[NSURL alloc] initFileURLWithPath:path];
            
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URLMolona];
            self.documentInteractionController.delegate = self;
            [self.documentInteractionController presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No measurements to export"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)clearDataButtonPressed:(id)sender {
    if (self.dataArray && [self.dataArray count] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Keep data"
                                              otherButtonTitles:@"Delete", nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No measurements to delete"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self clearData];
    }
}

-(void)clearData {
    for (PhraseMeasure *measure in self.dataArray) {
        [measure deleteEntity];
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    self.dataArray = [[NSArray alloc] init];
    [self.tableView reloadData];
}

#pragma mark Transitioning delegate methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (!_bounceAnimation) {
        _bounceAnimation = [[BouncePresentAnimationController alloc] init];
    }
    return _bounceAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (!_shrinkAnimation) {
        _shrinkAnimation = [[ShrinkDismissAnimationController alloc] init];
    }
    return _shrinkAnimation;
}

@end
