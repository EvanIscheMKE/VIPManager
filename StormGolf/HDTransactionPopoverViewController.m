//
//  HDTransactionPopoverViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/20/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionPopoverViewController.h"

@implementation HDTransactionPopoverViewController {
    UIDatePicker *_datePicker;
    NSDate *currentlySelectedDate;
}

- (void)viewDidLoad {
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.center = self.view.center;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(_dateHasChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _datePicker.frame = self.view.bounds;
}

- (IBAction)_dateHasChanged:(UIDatePicker *)datePicker {
    currentlySelectedDate = datePicker.date;
}

@end
