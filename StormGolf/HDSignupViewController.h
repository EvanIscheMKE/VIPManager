//
//  HDSignupViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/31/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@protocol HDSignupViewTableViewCellDelegate;
@interface HDSignupTableViewCell : UITableViewCell
@property (nonatomic, weak) id<HDSignupViewTableViewCellDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;
@end

@protocol HDSignupViewTableViewCellDelegate <NSObject>
- (void)finishedSignUpWithStartingBalance:(CGFloat)startingBalance;
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
- (void)dismissSignUpController:(HDSignupViewController *)controller;
@end
