//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "NSString+StringAdditions.h"
#import "HDItemManagerPopoverViewController.h"
#import "HDItemManagerDataGridController.h"
#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

@implementation HDDataGridCheckBoxCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor flatDataGridHeaderTextColor] setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.contentView.bounds, 16.0f, 13.0f)];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 2.0f;
    [bezierPath stroke];
    
    if ((self.checkedForRemoval)) {
        UIBezierPath *check = [UIBezierPath bezierPath];
        [check moveToPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds) - 5.0f, CGRectGetMidY(self.contentView.bounds))];
        [check addLineToPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds) - 1.0f, CGRectGetMidY(self.contentView.bounds) + 6.0f)];
        [check addLineToPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds) + 5.0f, CGRectGetMidY(self.contentView.bounds) - 5.0f)];
        check.lineCapStyle = kCGLineCapRound;
        check.lineJoinStyle = kCGLineJoinRound;
        check.lineWidth = 3.0f;
        [check stroke];
    }
}

- (void)setCheckedForRemoval:(BOOL)checkedForRemoval{
    _checkedForRemoval = checkedForRemoval;
    [self setNeedsDisplay];
}

@end





@implementation HDItemManagerDataGridController {
    NSMutableArray *_rowsToDelete;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView name:HDTableViewReloadDataNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        _rowsToDelete = [NSMutableArray new];
        self.title = @"Item Manager";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[HDDataGridCheckBoxCell class] forCellWithReuseIdentifier:@"CheckBox"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView selector:@selector(reloadData)
                                                 name:HDTableViewReloadDataNotification object:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor flatDataGridHeaderTextColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(_presentPopoverViewController:)];
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

- (IBAction)_deletedRows:(id)sender {
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"Are you sure you want to delete:"];
    
    BOOL attemptedToDeleteVIPCard = NO;
    for (NSNumber *row in _rowsToDelete) {
        HDItem *item = [[HDItemManager sharedManager] itemAtIndex:[row integerValue]];
        if (![item.itemDescription isEqualToString:@"VIP Card"]) {
            NSString *itemCost = [HDHelper stringFromNumber:fabs(item.itemCost)];
            [message appendString:[NSString stringWithFormat:@" \n %@ %@",item.itemDescription, itemCost]];
        } else {
            attemptedToDeleteVIPCard = YES;
        }
    } if (attemptedToDeleteVIPCard) {
        NSString *cardCost = [HDHelper stringFromNumber:fabs([[HDItemManager sharedManager] currentVIPCardPrice])];
        [message appendString:[NSString stringWithFormat:@"\n Items that cannot be erased: \n VIP Card %@", cardCost]];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    for (NSNumber *row in _rowsToDelete) {
                                                        HDItem *item = [[HDItemManager sharedManager] itemAtIndex:[row integerValue]];
                                                        if (![item.itemDescription isEqualToString:@"VIP Card"]) {
                                                            [[HDItemManager sharedManager] removeItem:item];
                                                        }
                                                    }
                                                    [self.collectionView reloadData];
                                                }];
     [alert addAction:yes];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];

    HDItem *item = [[HDItemManager sharedManager] itemAtIndex:row];
    
     UIColor *color = row % 2 == 0 ? [UIColor flatDataGridCellColor] : [UIColor whiteColor];
    
    if (column == 0) {
        HDDataGridCheckBoxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CheckBox" forIndexPath:indexPath];
        cell.backgroundColor = color;
        return cell;
    }
    
    HDDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDDataGridReuseIdentifier forIndexPath:indexPath];
    cell.editable = YES;
    cell.backgroundColor = color;
    
    
    if (column > 0) {
        cell.textLabel.text = [NSString stringWithFrontOffset:item.data[column - 1]];
    }
    
    return cell;
    
}

#pragma mark - Super Getters

- (void)dataGridDidSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];
    
    if (column == 0) {
        HDDataGridCheckBoxCell *cell = (HDDataGridCheckBoxCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.checkedForRemoval = !cell.isCheckedForRemoval;
        if (cell.isCheckedForRemoval) {
            [self dataGridHighlightColumnsInRow:row];
            [_rowsToDelete addObject:@(row)];
            if (!self.navigationItem.leftBarButtonItem) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                                      target:self
                                                                                                      action:@selector(_deletedRows:)];
            }
        } else {
            [self dataGridUnHighlightColumnsInRow:row];
            [_rowsToDelete removeObjectIdenticalTo:@(row)];
            if (_rowsToDelete.count == 0) {
                self.navigationItem.leftBarButtonItem = nil;
            }
        }
    }
}

- (NSInteger)numberOfRowsInDataGridView {
    return [HDItemManager sharedManager].count;
}

- (NSInteger)numberOfColumnsInDataGridView {
    return 3;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    return COLLECTIONVIEW_DEFAULT_ROW_HEIGHT;
}

- (CGFloat)widthForCellAtIndexPath:(NSIndexPath *)indexPath {
   
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];
    NSArray *columnWidths = @[@(CHECK_BOX_SCREEN_PERCENTAGE),
                              @(ITEM_TITLE_SCREEN_PERCENTAGE),
                              @(ITEM_VALUE_SCREEN_PERCENTAGE)];
    return [columnWidths[column] doubleValue];
}

- (NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];
    NSArray *columnTitles = @[[NSString stringWithFormat:@""],
                              [NSString stringWithFrontOffset:@"Item"],
                              [NSString stringWithFrontOffset:@"Cost"]];
    return columnTitles[column];
}

@end
