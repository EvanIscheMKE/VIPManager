//
//  HDUserTableViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDUserTableViewController.h"

static NSString * const HDUserTableViewCellReuseIdentifier = @"HDUserTableViewReuseIdentifier";

static const NSUInteger NUMBER_OF_SECTIONS = 2;
static const NSUInteger NUMBER_OF_ROWS_IN_SECTION_ONE = 4;

@interface HDUserTableViewController ()

@end

@implementation HDUserTableViewController

- (void)viewDidLoad {
     self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDUserTableViewCellReuseIdentifier];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return NUMBER_OF_ROWS_IN_SECTION_ONE;
    }
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDUserTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

@end
