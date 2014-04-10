//
//  HFPAppDelegate.m
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 03/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "HFPAppDelegate.h"

#import "HFPDetailViewController.h"

@implementation HFPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:188/255.0 green:18/255.0 blue:114/255.0 alpha:1.0f]];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:188/255.0 green:18/255.0 blue:114/255.0 alpha:1.0f]];
    
    [[UIButton appearance] setTintColor:[UIColor colorWithRed:188/255.0 green:18/255.0 blue:114/255.0 alpha:1.0f]];
    
    [MagicalRecord setupCoreDataStack];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
    
    HFPDetailViewController* controller = (HFPDetailViewController*)[nav topViewController];
    if ([controller isKindOfClass:[HFPDetailViewController class]]) [controller.textView resignFirstResponder];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}



@end
