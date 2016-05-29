//
//  HDTransactionsViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDVisualDataGridCell.h"
#import "HDTransactionManager.h"
#import "HDTransactionPopoverViewController.h"
#import "HDTransactionDataGridController.h"
#import "HDTransactionObject.h"
#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "UIFont+FontAdditions.h"
#import "HDDataGridController.h"
#import "HDItemManager.h"
#import "HDDBManager.h"
#import "HDHelper.h"

typedef NS_ENUM(NSUInteger, HDDataType){
    HDDataTypeTransactions = 0,
    HDDataTypeSales = 1,
    HDDataTypeNone
};

@interface HDTransactionDataGridController ()
@property (nonatomic, strong) NSArray *currentTransactions;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation HDTransactionDataGridController {
    HDDataType _dataType;
    NSUInteger _dataViewMaxValue;
    NSMutableDictionary *_transactionDictionary;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataType = HDDataTypeTransactions;
    _transactionDictionary = [NSMutableDictionary new];
    
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
        
        [self reloadData];
    
        for (HDTransactionObject *transaction in self.currentTransactions) {
            NSString *startTime = [[HDHelper formatter] stringFromDate:transaction.date];
        }
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataType == HDDataTypeTransactions) {
        return self.currentTransactions.count * self.columnWidths.count;
    }
    return [HDItemManager sharedManager].count * self.columnWidths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];
    
    if (_dataType == HDDataTypeTransactions) {
        
        HDTransactionObject *transaction = self.currentTransactions[row];
        
        HDDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDDataGridReuseIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [self _cellBackgroundColorForTransactionTitle:transaction.title];
        
        if (_transactionDictionary[@(transaction.iD)]) {
            cell.textLabel.text = [NSString stringWithFrontOffset:_transactionDictionary[@(transaction.iD)][column]];
            return cell;
        }
        
        [[HDDBManager sharedManager] currentUser:transaction.userID balanceForTransactionID:transaction.iD results:^(float starting) {
          
            if ([collectionView cellForItemAtIndexPath:indexPath]) {
                NSArray *values = [transaction dataWithStartingBalance:starting];
                cell.textLabel.text = [NSString stringWithFrontOffset:[transaction dataWithStartingBalance:starting][column]];
                [_transactionDictionary setObject:values forKey:@(transaction.iD)];
            }
        }];
    
        return cell;
        
    } else {
        
        NSLog(@"ROW:%lu COLUMN:%lu",row, column);
        
        HDItem *item = [[HDItemManager sharedManager] itemAtIndex:row];
        
        if (column != 1) {
            HDDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDDataGridReuseIdentifier forIndexPath:indexPath];
            [[HDTransactionManager sharedManager] infoForItem:item.itemDescription completion:^(NSUInteger count, CGFloat total) {
                    NSString *labelText = nil;
                    switch (column) {
                        case 0:
                            labelText = item.itemDescription;
                            break;
                        case 2:
                            labelText = [NSString stringWithFormat:@"%lu",count];
                            break;
                        case 3:
                            labelText = [HDHelper stringFromNumber:total];
                            break;
                        default:
                            break;
                    }
                NSLog(@"%@",labelText);
                cell.textLabel.text = [NSString stringWithFrontOffset:labelText];
            }];
            
            return cell;
            
        } else {
            
            HDVisualDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDVisualDataGridReuseIdentifier
                                                                                   forIndexPath:indexPath];
            [[HDTransactionManager sharedManager] infoForItem:item.itemDescription completion:^(NSUInteger count, CGFloat total) {
                cell.min = 0;
                cell.max = _dataViewMaxValue;
                cell.plot = count;
                cell.strokeColor = [UIColor colorForRowAtIndex:row];
            }];
            
            return cell;
            
        }
    }
}

#if 0
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        }];
        
        return cell;
    }
}
                                   
#endif
                                   
- (UIColor *)_cellBackgroundColorForTransactionTitle:(NSString *)title {
    if ([title isEqualToString:@"VIP Card"]||[title isEqualToString:@"Created Account"]) {
        return [UIColor flatSTYellowColor];
    } else {
        return [UIColor whiteColor];
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

- (NSArray *)columnWidths {
    
    if (_dataType == HDDataTypeTransactions) {
        return @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                 @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                 @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                 @(ITEM_COST_SCREEN_PERCENTAGE),
                 @(ADMIN_NAME_SCREEN_PERCENTAGE),
                 @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                 @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
    }
    
    return @[@(ITEM_NAME_SCREEN_PERCENTAGE),
             @(SALE_GRAPH_FULL_PERCENTAGE),
             @(SALE_NUMBER_SCREEN_PERCENTAGE),
             @(TOTAL_AMOUNT_SCREEN_PERCENTAGE)];
}

- (NSArray *)columnTitles {
    
    if (_dataType == HDDataTypeTransactions) {
        return  @[[NSString stringWithFrontOffset:@"Customer"],
                  [NSString stringWithFrontOffset:@"Starting"],
                  [NSString stringWithFrontOffset:@"Ending"],
                  [NSString stringWithFrontOffset:@"Cost"],
                  [NSString stringWithFrontOffset:@"Cashier"],
                  [NSString stringWithFrontOffset:@"Transaction Date"],
                  [NSString stringWithFrontOffset:@"Description"]];
    }
    
    return @[[NSString stringWithFrontOffset:@"Item Name"],
             [NSString stringWithFrontOffset:@"Visual"],
             [NSString stringWithFrontOffset:@"Sales"],
             [NSString stringWithFrontOffset:@"Total"]];
}

#pragma mark - Selector

- (IBAction)_updateTableViewData:(UISegmentedControl *)sender {
    _dataType = sender.selectedSegmentIndex;
    [self reloadData];
}

@end
