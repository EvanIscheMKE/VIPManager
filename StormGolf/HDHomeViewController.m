//
//  ViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/22/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDHomeViewController.h"
#import "UIColor+ColorAdditions.h"
#import "HDPopoverViewController.h"
#import "HDBasePresentationController.h"
#import "HDItemManagerViewController.h"
#import "HDDBManager.h"

const CGFloat BUTTON_WIDTH = 120.0f;
const CGFloat BUTTON_PADDING = 5.0f;
const CGFloat TEXTFIELD_HEIGHT = 70.0f;
const CGFloat TEXTFIELD_PADDING = 30.0f;

NSString * const HDNewMemberKey = @"New Member";
NSString * const HDItemManagerKey = @"Item Manager";
NSString * const HDAccountManagerKey = @"Account Manager";
NSString * const HDTransactionsKey = @"Transactions";

@interface HDHomeViewController () <UITextFieldDelegate>

@end

@implementation HDHomeViewController {
    HDBaseTransitioningDelegate *_transitioningDelegate;
    UITextField *_textField;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    
    self.navigationController.navigationBarHidden = TRUE;
    self.title = @"VIP Search";
    
    NSString *query = @"select * from userInfo";
    [[HDDBManager sharedManager] queryUserDataFromDatabase:query completion:^(NSArray *results) {
        NSArray *queryResults = [[NSArray alloc] initWithArray:results];
        NSLog(@"%@",queryResults);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    const CGRect bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.5f, TEXTFIELD_HEIGHT);
    _textField = [[UITextField alloc] initWithFrame:bounds];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, TEXTFIELD_PADDING, TEXTFIELD_HEIGHT)];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.center = self.view.center;
    _textField.attributedPlaceholder = [self _attributedPlaceholderString:@"Search For Current VIP Members"];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.layer.cornerRadius = 5.0f;
    [self.view addSubview:_textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
}

- (NSAttributedString *)_attributedPlaceholderString:(NSString *)string {
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22.0f]}];
}

#pragma mark - <Actions>

- (IBAction)_keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         _textField.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 265.0f);
                     } completion:nil];
}

- (IBAction)_keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         _textField.center = self.view.center;
                     } completion:nil];
}

#pragma mark - <UITextFieldDelegate>

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
