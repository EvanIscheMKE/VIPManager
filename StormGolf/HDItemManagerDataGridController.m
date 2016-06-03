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
}

- (void)setCheckedForRemoval:(BOOL)checkedForRemoval{
    _checkedForRemoval = checkedForRemoval;
    NSLog(_checkedForRemoval ? @"Selected" : @"Not Selected");
}

@end

@implementation HDItemManagerDataGridController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView name:HDTableViewReloadDataNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Item Manager";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[HDDataGridCheckBoxCell class] forCellWithReuseIdentifier:@"CheckBox"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView selector:@selector(reloadData)
                                                 name:HDTableViewReloadDataNotification object:nil];
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

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];

    HDItem *item = [[HDItemManager sharedManager] itemAtIndex:row];
    
     UIColor *color = row % 2 == 0 ? [UIColor colorWithRed:(246/255.0f) green:(246/255.0f) blue:(246/255.0f) alpha:1] : [UIColor whiteColor];
    
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
        } else {
            [self dataGridUnHighlightColumnsInRow:row];
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
