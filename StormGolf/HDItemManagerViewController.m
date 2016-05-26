//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridHeaderFooterView.h"
#import "HDItemManagerPopoverViewController.h"
#import "HDItemManagerViewController.h"
#import "HDItemManagerTableViewCell.h"
#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";
static NSString * const HDDataGridHeaderFooterIdentifier = @"HDDataGridHeaderFooterIdentifier";

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
    [self.tableView registerClass:[HDDataGridHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HDDataGridHeaderFooterIdentifier];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLEVIEW_HEADER_HEIGHT;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dictionary = [HDDataGridHeaderFooterView itemManager];
    HDDataGridHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDDataGridHeaderFooterIdentifier];
    [header performLayoutForValues:dictionary[HDDataGridValueKey] text:dictionary[HDDataGridTextKey]];
    return header;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
}



@end
