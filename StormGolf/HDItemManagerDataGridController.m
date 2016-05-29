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

@interface HDItemManagerDataGridController ()<UIPopoverPresentationControllerDelegate>
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_presentPopoverViewController:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView
                                             selector:@selector(reloadData)
                                                 name:HDTableViewReloadDataNotification
                                               object:nil];
    [super viewDidLoad];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [HDItemManager sharedManager].count * self.columnTitles.count;
}

- (HDDataGridCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row, column;
    [self row:&row column:&column fromIndexPath:indexPath];
    NSLog(@"%lu",row);
    
    HDItem *item = [[HDItemManager sharedManager] itemAtIndex:row];
    
    HDDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDDataGridReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFrontOffset:item.data[column]];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

- (NSArray *)columnTitles {
    return @[[NSString stringWithFrontOffset:@"Item Description"],
             [NSString stringWithFrontOffset:@"Item Cost"]];
}

- (NSArray *)columnWidths {
    return @[@(ITEM_TITLE_SCREEN_PERCENTAGE),
             @(ITEM_VALUE_SCREEN_PERCENTAGE)];
}

@end
