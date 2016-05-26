//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataVisualizationView.h"
#import "HDTransactionManager.h"
#import "HDTransactionPopoverViewController.h"
#import "HDTransactionsViewController.h"
#import "HDTransactionsHeaderView.h"
#import "HDDataGridTableViewCell.h"
#import "HDTransactionObject.h"
#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDSalesDataGridTableViewCell.h"
#import "UIFont+FontAdditions.h"
#import "HDItemManager.h"
#import "HDSalesHeaderView.h"
#import "HDDBManager.h"
#import "HDHelper.h"

NSString * const HDTransactionTableViewReuseIdentifier = @"HDTransactionTableViewReuseIdentifier";
NSString * const HDSalesTableViewReuseIdentifier = @"HDSalesTableViewReuseIdentifier";
NSString * const HDTableViewReusableTransactionHeaderFooterIdentifier = @"HDTableViewReusableTransactionHeaderFooterIdentifier";
NSString * const HDTableViewReusableSalesHeaderFooterIdentifier = @"HDTableViewReusableSalesHeaderFooterIdentifier";

typedef void (^HDSalesCompletionBlock)(NSUInteger count, CGFloat total);

const NSUInteger NUMBER_OF_BUTTONS = 2;
@implementation HDCalendarContainerView {
    CGSize _size;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        NSString *title = [NSString formattedStringFromDate:NSDate.date];
        
        UIFont *font = [UIFont stormGolfFontOfSize:21.0f];
    
        _size = [title sizeWithAttributes: @{ NSFontAttributeName: font }];

        for (NSInteger i = 0; i < NUMBER_OF_BUTTONS; i++) {
            const CGRect bounds = CGRectMake(0.0f, 0.0f, _size.width, _size.height);
            UIButton *btn = [[UIButton alloc] initWithFrame:bounds];
            btn.tag = i;
            btn.backgroundColor = [UIColor clearColor];
            btn.titleLabel.font = [UIFont stormGolfFontOfSize:14.0f];
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
    bezierPath.lineWidth = 2.0f;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), 12.0f)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - 12.0f)];
    [bezierPath stroke];
}

@end





static const CGFloat TABLEVIEW_HEADER_HEIGHT = 88.0f;
@interface HDTransactionsViewController () < HDCalendarViewDelegate >
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
    [self.tableView registerClass:[HDTransactionsHeaderView class]
forHeaderFooterViewReuseIdentifier:HDTableViewReusableTransactionHeaderFooterIdentifier];
    [self.tableView registerClass:[HDSalesHeaderView class]
forHeaderFooterViewReuseIdentifier:HDTableViewReusableSalesHeaderFooterIdentifier];
    
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
