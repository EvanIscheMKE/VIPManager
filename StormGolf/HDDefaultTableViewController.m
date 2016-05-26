//
//  HDDefaultTableViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/26/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDefaultTableViewController.h"

@implementation HDDefaultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
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

@end
