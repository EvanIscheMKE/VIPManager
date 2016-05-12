//
//  HDItemManagerDetailViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerDetailViewController.h"

@interface HDItemManagerDetailViewController ()

@end

@implementation HDItemManagerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create New Item";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_addItem:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
