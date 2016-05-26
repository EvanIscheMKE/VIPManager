//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerHeaderFooterView.h"
#import "HDItemManagerPopoverViewController.h"
#import "HDItemManagerViewController.h"
#import "HDItemManagerTableViewCell.h"
#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";
static NSString * const HDTableViewHeaderViewReuseIdentifier = @"HDTableViewReuseIdentifier";

static const CGFloat TABLEVIEW_HEADER_HEIGHT = 44.0f;
@interface HDItemManagerViewController ()<UIPopoverPresentationControllerDelegate>
@end

@implementation HDItemManagerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:HDTableViewReloadDataNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Item Manager";
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[HDItemManagerTableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
    [self.tableView registerClass:[HDItemManagerHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HDTableViewHeaderViewReuseIdentifier];
    
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
   
    HDItemManagerPopoverViewController *controller = [[HDItemManagerPopoverViewController alloc] init];
    controller.preferredContentSize = CGSizeMake(290.0f, 320.0f);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.barButtonItem = self.navigationItem.rightBarButtonItem;
    popController.backgroundColor = [UIColor whiteColor];
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
    cell.itemTitle = [[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemDescription;
    cell.itemCost = [HDHelper stringFromNumber:fabs([[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemCost)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLEVIEW_HEADER_HEIGHT;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDTableViewHeaderViewReuseIdentifier];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

@end
