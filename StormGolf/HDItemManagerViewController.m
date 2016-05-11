//
//  HDItemManagerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerViewController.h"
#import "HDItemManager.h"

static NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";

@implementation HDItemManagerViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Item Manager";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_addItem:)];
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HDItemManager sharedManager] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemDescription;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",[[HDItemManager sharedManager] itemAtIndex:indexPath.row].itemCost];
    return  cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

@end
