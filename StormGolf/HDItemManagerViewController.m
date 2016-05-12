//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerViewController.h"
#import "HDItemManagerTableViewCell.h"
#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";

@implementation HDItemManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[HDItemManagerTableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Item Manager";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HDItemManager sharedManager] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDItemManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemDescription;
    cell.detailTextLabel.text = [HDHelper stringFromNumber:[[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemCost];
    cell.detailTextLabel.textColor = [UIColor flatPeterRiverColor];
    return  cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

@end
