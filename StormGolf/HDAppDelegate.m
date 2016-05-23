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
    HDHomeViewController *controller = [[HDHomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;
    navigationController.toolbarHidden = NO;
    controller.toolbarItems = [self _toolBarItems];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    /* Global appearance */
    [[UIToolbar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor flatSTRedColor]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        [self _populateWithSampleData];
    }
    
    return YES;
}

#pragma mark - Private

- (UINavigationController *)_navigationController {
    return (UINavigationController *)self.window.rootViewController;
}

- (HDHomeViewController *)_controller {
     return [(UINavigationController *)self.window.rootViewController viewControllers].firstObject;
}

- (BOOL)_controllerHasChildrenViewController {
    return [self _controller].childViewControllers.count > 0;
}

- (NSArray *)_toolBarItems {
    
    UIBarButtonItem *fixedSpaceSmall = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceSmall.width = 20.0f;
    
    UIBarButtonItem *fixedSpaceMedium = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceMedium.width = 50.0f;
    
    UIBarButtonItem *fixedSpaceLarge = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceLarge.width = 100.0f;
    
    NSArray *toolBarItems = @[
                              fixedSpaceMedium,
                              [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(_dismissToPresentingViewController:)],
                              fixedSpaceLarge,
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(_presentItemManagerViewController:)],
                              fixedSpaceLarge,
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                            target:self
                                                                            action:@selector(_presentTransactionViewController:)],
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil],
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo
                                                                            target:self
                                                                            action:@selector(_present:)], fixedSpaceSmall];
    return toolBarItems;
}

- (IBAction)_dismissToPresentingViewController:(id)sender {
    if ([self _controllerHasChildrenViewController]) {
        [self _removeChildViewController];
    }
}

- (IBAction)_presentItemManagerViewController:(id)sender {
    
    if ([self _controllerHasChildrenViewController]) {
        [self _removeChildViewController];
        [self _itemManagerViewController];
    } else {
        [self _itemManagerViewController];
    }
}

- (void)_itemManagerViewController {
    
    HDItemManagerViewController *controller = [[HDItemManagerViewController  alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [[self _controller] addChildViewController:navigationController];
    [[self _controller].view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:[self _controller]];
}

- (IBAction)_presentTransactionViewController:(id)sender {
    
    if ([self _controllerHasChildrenViewController]) {
        [self _removeChildViewController];
        [self _transactionViewController];
    } else {
        [self _transactionViewController];
    }
}

- (void)_transactionViewController {
    
    HDTransactionsViewController *controller = [[HDTransactionsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
  
    [[self _controller] addChildViewController:navigationController];
    [[self _controller].view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:[self _controller]];
}

- (void)_removeChildViewController {
    /* There should always be only one child in the stack, but in case another one creeps in, destroy all them, bitches. */
    for (UIViewController *viewController in [self _controller].childViewControllers) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
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
                                                              admin:@"Admin"];
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

@end
