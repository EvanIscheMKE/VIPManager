//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerPopoverViewController.h"
#import "HDItemManagerViewController.h"
#import "HDItemManagerTableViewCell.h"
#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";

@interface HDItemManagerViewController ()<UIPopoverPresentationControllerDelegate>
@end

@implementation HDItemManagerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:HDTableViewReloadDataNotification object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerClass:[HDItemManagerTableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
    
    self.title = @"Item Manager";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_presentPopoverViewController:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:HDTableViewReloadDataNotification
                                               object:nil];
}

#pragma mark - IBAction

- (IBAction)_presentPopoverViewController:(id)sender {
   
    HDItemManagerPopoverViewController *controller = [[HDItemManagerPopoverViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.preferredContentSize = CGSizeMake(320.0f, 360.0f);
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:navigationController animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [navigationController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.barButtonItem = self.navigationItem.rightBarButtonItem;
    popController.delegate = self;
}

#pragma mark - <UIPopoverPresentationControllerDelegate>

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - <UITableViewCellDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HDItemManager sharedManager].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDItemManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemDescription;
    cell.detailTextLabel.text = [HDHelper stringFromNumber:fabs([[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemCost)];
    cell.detailTextLabel.textColor = [UIColor flatPeterRiverColor];
    return  cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[HDItemManager sharedManager] removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:YES];
    }
}

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

@end
