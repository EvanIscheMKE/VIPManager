//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionPopoverViewController.h"
#import "HDTransactionsViewController.h"
#import "HDTransactionsHeaderView.h"
#import "HDDataGridTableViewCell.h"
#import "HDTransactionObject.h"
#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDSalesDataGridTableViewCell.h"
#import "HDItemManager.h"
#import "HDSalesHeaderView.h"
#import "HDDBManager.h"
#import "HDHelper.h"

NSString * const HDTransactionTableViewReuseIdentifier = @"HDTransactionTableViewReuseIdentifier";
NSString * const HDSalesTableViewReuseIdentifier = @"HDSalesTableViewReuseIdentifier";
NSString * const HDTableViewReusableTransactionHeaderFooterIdentifier = @"HDTableViewReusableTransactionHeaderFooterIdentifier";
NSString * const HDTableViewReusableSalesHeaderFooterIdentifier = @"HDTableViewReusableSalesHeaderFooterIdentifier";

const NSUInteger NUMBER_OF_BUTTONS = 2;
@interface HDCalendarContainerView ()
@end

@implementation HDCalendarContainerView {
    CGSize _size;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        NSString *title = [NSString formattedStringFromDate:NSDate.date];
        
        UIFont *font = [UIFont systemFontOfSize:19.0f];
    
        _size = [title sizeWithAttributes: @{ NSFontAttributeName: font }];

        for (NSInteger i = 0; i < NUMBER_OF_BUTTONS; i++) {
            const CGRect bounds = CGRectMake(0.0f, 0.0f, _size.width, _size.height);
            UIButton *btn = [[UIButton alloc] initWithFrame:bounds];
            btn.tag = i;
            btn.backgroundColor = [UIColor clearColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:[NSString formattedStringFromDate:NSDate.date] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(_presentCalendar:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger i = 0;
    const CGFloat startingPointX = CGRectGetMidX(self.bounds) - _size.width / 2.0f;
    for (UIButton *btn in self.subviews) {
        btn.center = CGPointMake(startingPointX + (i * _size.width), CGRectGetMidY(self.bounds));
        i++;
    }
}

#pragma mark - Public

- (void)updateStartingDate:(NSDate *)startingDate {
    UIButton *btn = (UIButton *)self.subviews.firstObject;
    [btn setTitle:[NSString formattedStringFromDate:startingDate] forState:UIControlStateNormal];
}

- (void)updateEndingDate:(NSDate *)endingDate {
    UIButton *btn = (UIButton *)self.subviews.lastObject;
    [btn setTitle:[NSString formattedStringFromDate:endingDate] forState:UIControlStateNormal];
}

#pragma mark - Private

- (IBAction)_presentCalendar:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentCalendarOfType:)]) {
        [self.delegate presentCalendarOfType:sender.tag];
    }
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1.0f;
    [bezierPath moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), 10.0f)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - 10.0f)];
    [bezierPath stroke];
}

@end

const CGFloat TABLEVIEW_HEADER_HEIGHT = 36.0f;
@interface HDTransactionsViewController () < HDCalendarViewDelegate >
@property (nonatomic, strong) NSArray *currentTransactions;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation HDTransactionsViewController {
    BOOL _displayTransactions;
}

- (void)viewDidLoad {
    
    _displayTransactions = YES;
    
    [super viewDidLoad];
    [self.tableView registerClass:[HDDataGridTableViewCell class]
           forCellReuseIdentifier:HDTransactionTableViewReuseIdentifier];
    [self.tableView registerClass:[HDSalesDataGridTableViewCell class]
           forCellReuseIdentifier:HDSalesTableViewReuseIdentifier];
    [self.tableView registerClass:[HDTransactionsHeaderView class]
forHeaderFooterViewReuseIdentifier:HDTableViewReusableTransactionHeaderFooterIdentifier];
    [self.tableView registerClass:[HDSalesHeaderView class]
forHeaderFooterViewReuseIdentifier:HDTableViewReusableSalesHeaderFooterIdentifier];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"TRANSACTIONS", @"SALES"]];
    self.segmentControl.tintColor = [UIColor flatSTRedColor];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(_updateTableViewData:) forControlEvents:UIControlEventValueChanged];

    for (NSUInteger i = 0; i < 2; i++) {
        [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0f]}
                                           forState: (i == 0) ? UIControlStateSelected : UIControlStateNormal];
    }
    
    UIView *space = [[UIView alloc] initWithFrame:self.segmentControl.bounds];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:space];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
    
    const CGRect containerBounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 44.0f);
    HDCalendarContainerView *container = [[HDCalendarContainerView alloc] initWithFrame:containerBounds];
    container.delegate = self;
    self.navigationItem.titleView = container;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger unixTodayMorning = [[calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0] timeIntervalSince1970];

    NSString *query = [HDDBManager queryStringFromUnixStartDate:unixTodayMorning
                                                 finishDate:[NSDate.date timeIntervalSince1970]];
    
    query = @"select * from transactions";
    [[HDDBManager sharedManager] queryTransactionDataFromDatabase:query completion:^(NSArray *results) {
         self.currentTransactions = results;
        [self.tableView reloadData];
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
           // NSLog(@"%@",startTime);
        }
    }];
    
    self.tableView.rowHeight = 50.0f;
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
                cell.memberName = [NSString stringWithFormat:@"   %@",transaction.username];
                cell.cashierName = transaction.admin;
            }
        }];
        
        return cell;
    } else {
        HDItem *item = [[HDItemManager sharedManager] itemAtIndex:indexPath.row];
        HDSalesDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDSalesTableViewReuseIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = item.itemDescription;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_displayTransactions) {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDTableViewReusableTransactionHeaderFooterIdentifier];
    }
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:HDTableViewReusableSalesHeaderFooterIdentifier];
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

#pragma mark - <HDCalendarViewDelegate>

- (void)presentCalendarOfType:(HDCalendarType)type {
    [self _presentDatePickerPopoverWithType:type];
    switch (type) {
        case HDCalendarTypeStarting:
            NSLog(@"STARTING");
            break;
        case HDCalendarTypeEnding:
            NSLog(@"ENDING");
            break;
        default:
            break;
    }
}

#pragma mark - Convenice

- (UIView *)_sourceRectFromType:(HDCalendarType)type {
    switch (type) {
        case HDCalendarTypeStarting:
            return self.navigationItem.titleView.subviews.firstObject;
        case HDCalendarTypeEnding:
            return self.navigationItem.titleView.subviews.lastObject;
        default:
            break;
    }
}

- (CGRect)_rectFromCalendarType:(HDCalendarType)type {
    switch (type) {
        case HDCalendarTypeStarting:
            return CGRectInset(self.navigationItem.titleView.subviews.firstObject.bounds, 0.0, 10.0f);
        case HDCalendarTypeEnding:
            return CGRectInset(self.navigationItem.titleView.subviews.lastObject.bounds, 0.0, 10.0f);
        default:
            break;
    }
}

#pragma mark - Private

- (void)_presentDatePickerPopoverWithType:(HDCalendarType)type {
    HDTransactionPopoverViewController *controller = [[HDTransactionPopoverViewController alloc] init];
    controller.preferredContentSize = CGSizeMake(250.0f, 200.0f);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.backgroundColor = [UIColor whiteColor];
    popController.canOverlapSourceViewRect = YES;
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.sourceView = [self _sourceRectFromType:type];
    popController.sourceRect = [self _rectFromCalendarType:type];
}

#pragma mark - Selector

- (IBAction)_updateTableViewData:(UISegmentedControl *)sender {
    _displayTransactions = (sender.selectedSegmentIndex == 0);
    [self.tableView reloadData];
}

@end
