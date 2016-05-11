//
//  HDNewMemberViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDNewMemberViewController.h"
#import "HDItemManager.h"
#import "HDDBManager.h"

@interface HDNewMemberViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation HDNewMemberViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Add Member";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    const CGRect bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.5f, 50.0f);
    self.textField = [[UITextField alloc] initWithFrame:bounds];
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 50)];
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.center = self.view.center;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.layer.cornerRadius = 5.0f;
    [self.view addSubview:_textField];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

@end
