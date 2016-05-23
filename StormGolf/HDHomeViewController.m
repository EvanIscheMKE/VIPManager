//
//  ViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/22/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDUserSearchTableViewCell.h"
#import "UIImage+ImageAdditions.h"
#import "HDHomeViewController.h"
#import "UIColor+ColorAdditions.h"
#import "HDPopoverViewController.h"
#import "HDBasePresentationController.h"
#import "HDItemManagerViewController.h"
#import "HDUserObject.h"
#import "HDDBManager.h"
#import "HDHelper.h"

const CGFloat TEXTFIELD_HEIGHT = 70.0f;

NSString * const HDNewMemberKey = @"New Member";
NSString * const HDItemManagerKey = @"Item Manager";
NSString * const HDAccountManagerKey = @"Account Manager";
NSString * const HDTransactionsKey = @"Transactions";

static NSString * const HDTableViewCellReuseIdentifier = @"HDTableViewCellReuseIdentifier";

@implementation HDSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        self.attributedPlaceholder = [self _attributedPlaceholderWithString:@"Search For Current VIP Card Member"];
        self.keyboardType = UIKeyboardAppearanceDark;
        self.returnKeyType = UIReturnKeyDone;
        self.leftView = [self _leftViewWithHeight:CGRectGetHeight(frame)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = self.leftViewMode;
        self.rightView = [self _rightButtonWithHeight:CGRectGetHeight(frame)];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (UIButton *)rightActionButton {
    return (UIButton *)self.rightView;
}

#pragma mark - Private

- (UIButton *)_rightButtonWithHeight:(CGFloat)height {
    CGRect buttonFrame = CGRectMake(0.0, 0.0, height, height);
    UIButton *btn = [[UIButton alloc] initWithFrame:buttonFrame];
    [btn setImage:[UIImage additionSignImageWithSize:buttonFrame.size] forState:UIControlStateNormal];
    return btn;
}

- (UIView *)_leftViewWithHeight:(CGFloat)height {
    CGRect containerFrame = CGRectMake(0.0, 0.0, height * 1.5f, height);
    UIView *container = [[UIView alloc] initWithFrame:containerFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golf-icon"]];
    imageView.center = CGPointMake(CGRectGetMidX(container.bounds), CGRectGetMidY(container.bounds));
    [container addSubview:imageView];
    
    return container;
}

- (NSAttributedString *)_attributedPlaceholderWithString:(NSString *)placeholder {
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                  NSForegroundColorAttributeName:[UIColor blackColor] };
    return [[NSAttributedString alloc] initWithString:placeholder
                                           attributes:attributes];
}

@end

@interface HDHomeViewController () < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate >
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *userSearchDictionary;
@end

@implementation HDHomeViewController {
    NSString *_currentSearchString;
    CGRect _previousTextFieldFrame;
    NSArray *_queryResults;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    
    self.userSearchDictionary = [NSMutableDictionary new];
    
    self.navigationController.navigationBarHidden = TRUE;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stormWP2048"]];
    [self.view addSubview:imageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableView registerClass:[HDUserSearchTableViewCell class]
           forCellReuseIdentifier:HDTableViewCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    const CGRect searchBarFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.15f, TEXTFIELD_HEIGHT);
    self.searchBar = [[HDSearchBar alloc] initWithFrame:searchBarFrame];
    self.searchBar.delegate = self;
    self.searchBar.center = self.view.center;
    [self.searchBar.rightActionButton addTarget:self action:@selector(_presentUserViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
}

- (void)_presentUserViewController {
  
}

- (void)firstname:(NSString **)firstname lastname:(NSString **)lastname {
    NSArray *nameParts = [_currentSearchString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    *firstname = nameParts.firstObject;
    if (nameParts.count == 2) {
        *lastname = [nameParts objectAtIndex:1];
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    _currentSearchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([_currentSearchString isEqualToString:@""]) {
        _queryResults = nil;
        [_userSearchDictionary removeAllObjects];
        [self.tableView reloadData];
        return YES;
    }
    
    if (_userSearchDictionary[_currentSearchString]) {
        _queryResults = _userSearchDictionary[_currentSearchString];
        [self.tableView reloadData];
        return YES;
    }
    
    NSString *firstName, *lastName;
    [self firstname:&firstName lastname:&lastName];
    
    NSString *queryString = [HDDBManager queryStringForFirstName:firstName lastName:lastName];
    [[HDDBManager sharedManager] queryUserDataFromDatabase:queryString completion:^(NSArray *results) {
        _queryResults = results;
        [_userSearchDictionary setObject:_queryResults forKey:_currentSearchString];
        [self.tableView reloadData];
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     _queryResults = nil;
    textField.text = nil;
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (HDUserSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDUserSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewCellReuseIdentifier
                                                            forIndexPath:indexPath];
    
    HDUserObject *user = _queryResults[indexPath.row];
    [[HDDBManager sharedManager] currentUserBalanceWithUserID:user.userID results:^(float startingBalance) {
        NSRange range =[user.fullname rangeOfString:_currentSearchString options:NSCaseInsensitiveSearch];
        cell.textLabel.attributedText = [self highlightedString:user.fullname forRange:range color:cell.detailTextLabel.textColor];
        cell.detailTextLabel.text = [HDHelper stringFromNumber:startingBalance];
        cell.emailLabel.text = user.email;
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _queryResults.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self _presentUserViewController];
}

#pragma mark - <Actions>

- (IBAction)_keyboardWillShow:(NSNotification *)notification {
    
     _previousTextFieldFrame = self.searchBar.frame;
    
    self.searchBar.rightViewMode = UITextFieldViewModeNever;

    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect frame = self.searchBar.frame;
                         frame.origin.x = 0.0f;
                         frame.origin.y = 20.0f;
                         frame.size.width = CGRectGetWidth(self.view.bounds);
                         self.searchBar.frame = frame;
                         self.searchBar.layer.masksToBounds = NO;
                     } completion:^(BOOL finished) {
                         self.tableView.tableHeaderView = self.searchBar;
                         self.tableView.hidden = NO;
                     }];
}

- (IBAction)_keyboardWillHide:(NSNotification *)notification {
    
    _queryResults = nil;
    
    const CGRect searchBarBounds = CGRectMake(0.0f, 0.0, CGRectGetWidth(self.view.bounds), TEXTFIELD_HEIGHT);
    self.searchBar.frame = searchBarBounds;
    [self.view addSubview:self.searchBar];
    
    self.searchBar.rightViewMode = UITextFieldViewModeAlways;
    
    self.tableView.hidden = YES;
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.searchBar.frame = _previousTextFieldFrame;
                         self.searchBar.layer.masksToBounds = YES;
                     } completion:nil];
}

- (NSMutableAttributedString *)highlightedString:(NSString *)string forRange:(NSRange)range color:(UIColor *)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    return attributedString;
}

@end
