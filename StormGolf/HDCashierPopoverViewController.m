//
//  HDCashierViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDCashierPopoverViewController.h"

NSString * const HDTableViewReuseIdentifier = @"";
@implementation HDCashierPopoverViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
}

@end
