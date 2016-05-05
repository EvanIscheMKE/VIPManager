//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionsViewController.h"
#import "HDBasePresentationController.h"
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
        self.title = @"Transactions";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTransactionTableViewReuseIdentifier];
    
    self.baseTransitioningDelegate = [HDBaseTransitioningDelegate new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                           target:self
                                                                                           action:@selector(_presentCalendarViewController)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
   
    NSUInteger epochToday = [NSDate.date timeIntervalSince1970];
    NSUInteger epochTodayMorning = [[calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0] timeIntervalSince1970];
    
    NSString *q = [NSString stringWithFormat:@"select * from trans where createdAt >= %zd AND createdAt <= %zd", epochTodayMorning,epochToday];
    self.currentTransactions = [[NSArray alloc] initWithArray:[[HDDBManager sharedManager] loadTransactionDataFromDatabase:q]];
    for (HDTransactionObject *transaction in self.currentTransactions) {
        NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.transactionDate];
        NSLog(@"%@",startTime);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTransactionTableViewReuseIdentifier forIndexPath:indexPath];
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
   
    NSUInteger epochToday = [finish timeIntervalSince1970];
    NSUInteger epochTodayMorning = [start timeIntervalSince1970];
    
    NSString *q = [NSString stringWithFormat:@"select * from trans where createdAt >= %zd AND createdAt <= %zd", epochTodayMorning,epochToday];
    self.currentTransactions = [[NSArray alloc] initWithArray:[[HDDBManager sharedManager] loadTransactionDataFromDatabase:q]];
    for (HDTransactionObject *transaction in self.currentTransactions) {
        NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.transactionDate];
        NSLog(@"%@",startTime);
    }

}

@end
