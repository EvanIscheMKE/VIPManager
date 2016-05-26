//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridHeaderFooterView.h"
#import "HDDataVisualizationView.h"
#import "HDTransactionManager.h"
#import "HDTransactionPopoverViewController.h"
#import "HDTransactionsViewController.h"
#import "HDDataGridTableViewCell.h"
#import "HDTransactionObject.h"
#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDSalesDataGridTableViewCell.h"
#import "UIFont+FontAdditions.h"
#import "HDItemManager.h"
#import "HDDBManager.h"
#import "HDHelper.h"

NSString * const HDTransactionTableViewReuseIdentifier = @"HDTransactionTableViewReuseIdentifier";
NSString * const HDSalesTableViewReuseIdentifier = @"HDSalesTableViewReuseIdentifier";
NSString * const HDDataGridHeaderFooterIdentifier = @"HDDataGridHeaderFooterIdentifier";

typedef void (^HDSalesCompletionBlock)(NSUInteger count, CGFloat total);

static const CGFloat TABLEVIEW_HEADER_HEIGHT = 88.0f;
@interface HDTransactionsViewController ()
@property (nonatomic, strong) NSArray *currentTransactions;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation HDTransactionsViewController {
    BOOL _displayTransactions;
    NSUInteger _dataViewMaxValue;
}

- (void)viewDidLoad {
    
    _displayTransactions = YES;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    [self.tableView registerClass:[HDDataGridTableViewCell class]
           forCellReuseIdentifier:HDTransactionTableViewReuseIdentifier];
    [self.tableView registerClass:[HDSalesDataGridTableViewCell class]
           forCellReuseIdentifier:HDSalesTableViewReuseIdentifier];
    [self.tableView registerClass:[HDDataGridHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HDDataGridHeaderFooterIdentifier];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Transactions", @"Sales"]];
    self.segmentControl.tintColor = [UIColor blackColor];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(_updateTableViewData:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont stormGolfFontOfSize:15.0f]}
                                       forState:UIControlStateSelected];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont stormGolfFontOfSize:15.0f]}
                                       forState:UIControlStateNormal];
    [self.segmentControl setWidth:120.0f forSegmentAtIndex:0];
    [self.segmentControl setWidth:120.0f forSegmentAtIndex:1];
    self.navigationItem.titleView = self.segmentControl;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger unixTodayMorning = [[calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0] timeIntervalSince1970];

    NSString *query = [HDDBManager queryStringFromUnixStartDate:unixTodayMorning
                                                 finishDate:[NSDate.date timeIntervalSince1970]];
    
    query = @"select * from transactions";
    [[HDDBManager sharedManager] queryTransactionDataFromDatabase:query completion:^(NSArray *results) {
        
        self.currentTransactions = results;
        
        _dataViewMaxValue = [[HDTransactionManager sharedManager] updateCurrentTransactionQueryResults:results];
        
        [self.tableView reloadData];
    
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
        }
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_displayTransactions) {
        return self.currentTransactions.count;
    }
    return [HDItemManager sharedManager].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_displayTransactions) {
        HDDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTransactionTableViewReuseIdentifier forIndexPath:indexPath];
        
        HDTransactionObject *transaction = self.currentTransactions[indexPath.row];
        [[HDDBManager sharedManager] currentUser:transaction.userID balanceForTransactionID:transaction.iD results:^(float starting) {
            const CGFloat endingBalance = starting + transaction.cost;
            if ([tableView cellForRowAtIndexPath:indexPath]) {
                cell.startingBalance = [HDHelper stringFromNumber:starting];
                cell.endingBalance = [HDHelper stringFromNumber:endingBalance];
                cell.itemCost = [HDHelper stringFromNumber:fabs(transaction.cost)];
                cell.transactionDate = [[HDHelper formatter] stringFromDate:transaction.date];
                cell.itemDescription = transaction.title;
                cell.memberName = transaction.username;
                cell.cashierName = transaction.admin;
                
                if ([transaction.title isEqualToString:@"VIP Card"]||[transaction.title isEqualToString:@"Created Account"]) {
                    [cell setBackgroundColor:[UIColor flatSTYellowColor]];
                } else {
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
            }
        }];
        
        return cell;
    } else {
        
        HDItem *item = [[HDItemManager sharedManager] itemAtIndex:indexPath.row];
        HDSalesDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDSalesTableViewReuseIdentifier forIndexPath:indexPath];
        [[HDTransactionManager sharedManager] infoForItemWithDescription:item.itemDescription
                                                              completion:^(NSUInteger count, CGFloat total) {
            cell.itemDescription = item.itemDescription;
            cell.amountSold = [NSString stringWithFormat:@"%lu",count];
            cell.totalSold = [HDHelper stringFromNumber:total];
            
            cell.dataView.min = 0;
            cell.dataView.max = _dataViewMaxValue;
            cell.dataView.plot = count;
            cell.dataView.strokeColor = [UIColor colorForRowAtIndex:indexPath.row];
        }];
        
        return cell;
    }
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSDictionary *dictionary = nil;
    if (_displayTransactions) {
        dictionary = [HDDataGridHeaderFooterView transaction];
    } else {
        dictionary = [HDDataGridHeaderFooterView sales];
    }
    
    HDDataGridHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDDataGridHeaderFooterIdentifier];
    [header performLayoutForValues:dictionary[HDDataGridValueKey]
                              text:dictionary[HDDataGridTextKey]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLEVIEW_HEADER_HEIGHT;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - <HDPopoverViewControllerDelegate>

//- (void)popover:(HDPopoverViewController *)popover
//updatedQueryStartDate:(NSDate *)start
//     finishDate:(NSDate *)finish {
//   
//    NSString *query = [HDDBManager queryStringFromUnixStartDate:[start timeIntervalSince1970]
//                                                     finishDate:[finish timeIntervalSince1970]];
//    [[HDDBManager sharedManager] queryTransactionDataFromDatabase:query completion:^(NSArray *results) {
//        self.currentTransactions = [NSArray arrayWithArray:results];
//        [self.tableView reloadData];
//        for (HDTransactionObject *transaction in self.currentTransactions) {
//            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
//            NSLog(@"%@",startTime);
//        }
//    }];
//}

#pragma mark - Private

//- (void)_presentDatePickerPopoverWithType:(HDCalendarType)type {
//    HDTransactionPopoverViewController *controller = [[HDTransactionPopoverViewController alloc] init];
//    controller.preferredContentSize = CGSizeMake(250.0f, 200.0f);
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.backgroundColor = [UIColor whiteColor];
//    popController.canOverlapSourceViewRect = YES;
//    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//}

#pragma mark - Selector

- (IBAction)_updateTableViewData:(UISegmentedControl *)sender {
    _displayTransactions = (sender.selectedSegmentIndex == 0);
    [self.tableView reloadData];
}

@end
