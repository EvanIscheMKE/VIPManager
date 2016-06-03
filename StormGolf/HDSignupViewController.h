//
//  HDSignupViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/31/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@interface HDSignupTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@end

@protocol HDSignupViewControllerDelegate;
@interface HDSignupViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic, weak) id<HDSignupViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) CGFloat startingBalance;
@end

@protocol HDSignupViewControllerDelegate <NSObject>
- (void)signupIsCompleted:(HDSignupViewController *)controller;
@end
