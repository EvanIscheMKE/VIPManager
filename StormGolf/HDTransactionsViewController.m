//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionsViewController.h"
#import "HDBasePresentationController.h"
#import "HDDataGridTableViewCell.h"
#import "HDPopoverViewController.h"
#import "HDTransactionObject.h"
#import "HDDBManager.h"
#import "HDHelper.h"

NSString * const HDTransactionTableViewReuseIdentifier = @"identifier";

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
    
    dispatch_queue_t queue = dispatch_queue_create("com.StormGolf.SerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    });
    
    [super viewDidLoad];
    [self.tableView registerClass:[HDDataGridTableViewCell class] forCellReuseIdentifier:HDTransactionTableViewReuseIdentifier];
    
    self.baseTransitioningDelegate = [HDBaseTransitioningDelegate new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                           target:self
                                                                                           action:@selector(_presentCalendarViewController)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger unixTodayMorning = [[calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0] timeIntervalSince1970];
    

    NSString *query = [HDDBManager queryStringFromUnixStartDate:unixTodayMorning
                                                 finishDate:[NSDate.date timeIntervalSince1970]];
#if DEBUG
    query = @"select * from trans";
#endif
    [[HDDBManager sharedManager] queryDataFromDatabase:query completion:^(NSArray *results) {
        self.currentTransactions = [NSArray arrayWithArray:results];
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.transactionDate];
            NSLog(@"%@",startTime);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTransactionTableViewReuseIdentifier forIndexPath:indexPath];
    cell.isTopCell = indexPath.row == 0;
    
    HDTransactionObject *transaction = self.currentTransactions[indexPath.row];
    
//    NSString *dateAsString = [[HDHelper formatter] stringFromDate:transaction.transactionDate];
//    NSString *transactionDescription = transaction.transactionDescription;
//    
//    const float startingBalance = [HDHelper currentUser:transaction.userID balanceForTransactionID:transaction.transactionID];
//    const float endingBalance = startingBalance - transaction.transactionPrice;
//    const float itemCost = transaction.transactionPrice;
    
    return cell;
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

#pragma mark - <HDPopoverViewControllerDelegate>

- (void)popover:(HDPopoverViewController *)popover
updatedQueryStartDate:(NSDate *)start
     finishDate:(NSDate *)finish {
   
    NSString *query = [HDDBManager queryStringFromUnixStartDate:[start timeIntervalSince1970]
                                                     finishDate:[finish timeIntervalSince1970]];
    [[HDDBManager sharedManager] queryDataFromDatabase:query completion:^(NSArray *results) {
        self.currentTransactions = [NSArray arrayWithArray:results];
        [self.tableView reloadData];
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.transactionDate];
            NSLog(@"%@",startTime);
        }
    }];
}

@end
