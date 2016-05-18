//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionsViewController.h"
#import "HDBasePresentationController.h"
#import "HDTransactionsHeaderView.h"
#import "HDDataGridTableViewCell.h"
#import "HDPopoverViewController.h"
#import "HDTransactionObject.h"
#import "UIColor+ColorAdditions.h"
#import "HDDBManager.h"
#import "HDHelper.h"

NSString * const HDTransactionTableViewReuseIdentifier = @"identifier";
NSString * const HDTableViewReusableHeaderFooterIdentifier = @"headerFooter";

@interface HDTransactionsViewController () <HDPopoverViewControllerDelegate>
@property (nonatomic, strong) NSArray *currentTransactions;
@property (nonatomic, strong) HDBaseTransitioningDelegate *baseTransitioningDelegate;
@end

@implementation HDTransactionsViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"%@",[[HDHelper formatter] stringFromDate:NSDate.date]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[HDDataGridTableViewCell class]
           forCellReuseIdentifier:HDTransactionTableViewReuseIdentifier];
    [self.tableView registerClass:[HDTransactionsHeaderView class]
forHeaderFooterViewReuseIdentifier:HDTableViewReusableHeaderFooterIdentifier];
    
    self.baseTransitioningDelegate = [HDBaseTransitioningDelegate new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                           target:self
                                                                                           action:@selector(_presentCalendarViewController)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger unixTodayMorning = [[calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0] timeIntervalSince1970];

    NSString *query = [HDDBManager queryStringFromUnixStartDate:unixTodayMorning
                                                 finishDate:[NSDate.date timeIntervalSince1970]];
    
#if DEBUG
    query = @"select * from transactions";
#endif
    
    [[HDDBManager sharedManager] queryTransactionDataFromDatabase:query completion:^(NSArray *results) {
         self.currentTransactions = [NSArray arrayWithArray:results];
        [self.tableView reloadData];
#if DEBUG
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
           // NSLog(@"%@",startTime);
        }
#endif
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTransactionTableViewReuseIdentifier forIndexPath:indexPath];
    cell.isTopCell = indexPath.row == 0;
    
    HDTransactionObject *transaction = self.currentTransactions[indexPath.row];
    [[HDDBManager sharedManager] currentUser:transaction.userID balanceForTransactionID:transaction.iD results:^(float starting) {
        
        const CGFloat endingBalance = transaction.addition ? starting + transaction.cost : starting - transaction.cost;
        if ([tableView cellForRowAtIndexPath:indexPath]) {
            
            cell.startingBalance = [HDHelper stringFromNumber:starting];
            cell.endingBalance = [HDHelper stringFromNumber:endingBalance];
            cell.itemCost = [HDHelper stringFromNumber:transaction.cost];
            cell.transactionDate = [[HDHelper formatter] stringFromDate:transaction.date];
            cell.itemDescription = transaction.title;
            cell.memberName = [NSString stringWithFormat:@"  %@",transaction.username];
            cell.cashierName = transaction.admin;
            
        }
    }];
    return cell;
}

- (HDTransactionsHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTransactionsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDTableViewReusableHeaderFooterIdentifier];
    view.contentView.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)_presentCalendarViewController {
    self.transitioningDelegate = self.baseTransitioningDelegate;
    HDPopoverViewController *controller = [HDPopoverViewController new];
    controller.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    navigationController.transitioningDelegate = self.baseTransitioningDelegate;
    [ self presentViewController:navigationController
                        animated:YES
                      completion:nil ];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - <HDPopoverViewControllerDelegate>

- (void)popover:(HDPopoverViewController *)popover
updatedQueryStartDate:(NSDate *)start
     finishDate:(NSDate *)finish {
   
    NSString *query = [HDDBManager queryStringFromUnixStartDate:[start timeIntervalSince1970]
                                                     finishDate:[finish timeIntervalSince1970]];
    [[HDDBManager sharedManager] queryTransactionDataFromDatabase:query completion:^(NSArray *results) {
        self.currentTransactions = [NSArray arrayWithArray:results];
        [self.tableView reloadData];
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
            NSLog(@"%@",startTime);
        }
    }];
}

@end
