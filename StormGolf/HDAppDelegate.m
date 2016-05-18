//
//  AppDelegate.m
//  StormGolf
//
//  Created by Evan Ische on 4/22/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManager.h"
#import "HDDBManager.h"
#import "HDAppDelegate.h"
#import "HDHomeViewController.h"
#import "HDItemManagerViewController.h"
#import "HDTransactionsViewController.h"
#import "UIColor+ColorAdditions.h"

@interface HDAppDelegate ()
@end

@implementation HDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* */
    application.statusBarHidden = YES;
    
    /* */
    HDHomeViewController *controller1 = [[HDHomeViewController alloc] init];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    
    HDItemManagerViewController *controller2 = [[HDItemManagerViewController  alloc] init];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:2];
    
    HDTransactionsViewController *controller3 = [[HDTransactionsViewController alloc] init];
    controller3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    
    /* */
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:controller1];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:controller2];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:controller3];
    
    /* */
    NSMutableArray *controllers = [@[] mutableCopy];
    [controllers addObject:navigationController1];
    [controllers addObject:navigationController2];
    [controllers addObject:navigationController3];
    
    /* */
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.tabBar.itemPositioning = UITabBarItemPositioningAutomatic;
    [tabbarController setViewControllers:controllers];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    
    /* Global appearance */
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor flatSTRedColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor flatSTRedColor]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        [self _populateWithSampleData];
    }
    
    return YES;
}

- (void)_populateWithSampleData {
    /* populate App With Test Data */
    NSString* path = [[NSBundle mainBundle] pathForResource:@"FullNames"
                                                     ofType:@"txt"];
    
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    NSArray *names = [content componentsSeparatedByString:@"\n"];
    
    NSUInteger userID = 1;
    for (NSString *fullname in names) {
        
        NSString *firstname = [fullname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].firstObject;
        NSString *lastname = [fullname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].lastObject;
        NSString *email = [NSString stringWithFormat:@"%@%@@icloud.com",firstname,lastname];
        
        NSString *query1 = [HDDBManager executableStringWithFirstName:firstname
                                                             lastname:lastname
                                                                email:email];
        [[HDDBManager sharedManager] executeQuery:query1];
        if ([HDDBManager sharedManager].affectedRows != 0) {
            NSLog(@"Query 1 was executed successfully. Affected rows = %ld", (long)[HDDBManager sharedManager].affectedRows);
        } else {
            NSLog(@"Could not execute the query.");
        }
        
        NSString *query2 = [HDDBManager executableStringWithUserName:[NSString stringWithFormat:@"%@ %@",firstname,lastname]
                                                              price:75.00
                                                        description:@"Created Account"
                                                             userID:userID
                                                              admin:@"ADMIN"];
        [[HDDBManager sharedManager] executeQuery:query2];
        for (NSUInteger i = 0; i < (arc4random() % 4); i++) {
            NSUInteger index = arc4random() % [[HDItemManager sharedManager] count];
            NSString *query = [HDDBManager executableStringWithUserName:[NSString stringWithFormat:@"%@ %@",firstname,lastname]
                                                                  price:[[HDItemManager sharedManager] itemAtIndex:index].itemCost
                                                            description:[[HDItemManager sharedManager] itemAtIndex:index].itemDescription
                                                                 userID:userID
                                                                  admin:@"ADMIN"];
            [[HDDBManager sharedManager] executeQuery:query];
            if ([HDDBManager sharedManager].affectedRows != 0) {
                NSLog(@"Query 1 was executed successfully. Affected rows = %ld", (long)[HDDBManager sharedManager].affectedRows);
            } else {
                NSLog(@"Could not execute the query.");
            }
        }
        userID++;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
