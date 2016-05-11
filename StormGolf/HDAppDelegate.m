//
//  AppDelegate.m
//  StormGolf
//
//  Created by Evan Ische on 4/22/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDAppDelegate.h"
#import "HDHomeViewController.h"
#import "HDItemManagerViewController.h"
#import "HDTransactionsViewController.h"
#import "HDNewMemberViewController.h"
#import "UIColor+ColorAdditions.h"

@interface HDAppDelegate () <UISplitViewControllerDelegate>

@end

@implementation HDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* */
    HDHomeViewController *controller1 = [[HDHomeViewController alloc] init];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    
    UISplitViewController *controller2 = [[UISplitViewController alloc] init];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:2];
    
    HDTransactionsViewController *controller3 = [[HDTransactionsViewController alloc] init];
    controller3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3];
    
    HDNewMemberViewController *controller4 = [[HDNewMemberViewController alloc] init];
    controller4.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:4];
    
    HDHomeViewController *controller5 = [[HDHomeViewController alloc] init];
    controller5.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:5];
    
    controller2.delegate = self;
    controller2.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:[HDItemManagerViewController new]],
                                    [[UINavigationController alloc] initWithRootViewController:[UIViewController new]]];
    
    /* */
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:controller1];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:controller3];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:controller4];
    UINavigationController *navigationController5 = [[UINavigationController alloc] initWithRootViewController:controller5];
    
    /* */
    NSMutableArray *controllers = [@[] mutableCopy];
    [controllers addObject:navigationController1];
    [controllers addObject:controller2];
    [controllers addObject:navigationController3];
    [controllers addObject:navigationController4];
    [controllers addObject:navigationController5];
    
    /* */
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
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
    
    return YES;
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
