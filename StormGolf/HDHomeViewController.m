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
#import "HDSearchViewController.h"
#import "HDUserObject.h"
#import "HDSearchBar.h"
#import "HDDBManager.h"

const CGFloat TEXTFIELD_HEIGHT = 70.0f;

NSString * const HDNewMemberKey = @"New Member";
NSString * const HDItemManagerKey = @"Item Manager";
NSString * const HDAccountManagerKey = @"Account Manager";
NSString * const HDTransactionsKey = @"Transactions";

NSString * const HDTableViewCellReuseIdentifier = @"HDTableViewCellReuseIdentifier";
@interface HDHomeViewController () < UITableViewDelegate,
                                     UITableViewDataSource,
                                     UISearchBarDelegate >
@property (nonatomic, strong) HDSearchViewController *searchController;
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HDHomeViewController {
    BOOL _shouldShowSearchResults;
    CGRect _previousTextFieldFrame;
    NSArray *_queryResults;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    
    self.navigationController.navigationBarHidden = TRUE;
    self.view.backgroundColor = [UIColor whiteColor];
    
    const CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0.0f, statusBarHeight)];
    imageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:imageView];
    
    const CGRect searchControllerBounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), TEXTFIELD_HEIGHT);
    self.searchController = [[HDSearchViewController alloc] initWithSearchResultsController:nil
                                                                             searchBarFrame:searchControllerBounds
                                                                                  textColor:[UIColor blackColor]
                                                                                  tintColor:[UIColor whiteColor]];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.placeholder = @"Search For A Current VIP Member";
    self.searchController.searchBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0.0f, statusBarHeight)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTableViewCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.searchController.customSearchBar;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    const CGRect bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.5f, TEXTFIELD_HEIGHT);
    self.searchBar = [[HDSearchBar alloc] initWithFrame:bounds textColor:[UIColor flatPeterRiverColor]];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor flatPeterRiverColor];
    self.searchBar.placeholder = self.searchController.searchBar.placeholder;
    self.searchBar.center = self.view.center;
    self.searchBar.layer.cornerRadius = 5.0f;
    self.searchBar.layer.masksToBounds = YES;
    [self.view addSubview:self.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        self.searchController.active = NO;
        return;
    }
    
    NSString *firstName, *lastName;
    NSArray *nameParts = [searchText componentsSeparatedByString:@" "];
    firstName = nameParts.firstObject;
    if (nameParts.count == 2) {
        lastName = [nameParts objectAtIndex:1];
    }
    
    NSString *queryString = [HDDBManager queryStringForFirstName:firstName
                                                        lastName:lastName];
    [[HDDBManager sharedManager] queryUserDataFromDatabase:queryString completion:^(NSArray *results) {
        _queryResults = results;
        [self.tableView reloadData];
    }];
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    _shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(HDSearchBar *)searchBar {
    _shouldShowSearchResults = NO;
    [self.tableView reloadData];
    [self.searchController.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(HDSearchBar *)searchBar {
    if (!_shouldShowSearchResults) {
        _shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
    [self.searchController.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewCellReuseIdentifier
                                                            forIndexPath:indexPath];
    
    HDUserObject *user = _queryResults[indexPath.row];
    cell.textLabel.text = user.fullname;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _shouldShowSearchResults) {
        return _queryResults.count;
    }
    return 0;
}

#pragma mark - <Actions>

- (IBAction)_keyboardWillShow:(NSNotification *)notification {
    
     _previousTextFieldFrame = self.searchBar.frame;
    
    [self.searchController.customSearchBar becomeFirstResponder];

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
                         self.tableView.hidden = NO;
                         self.searchBar.hidden = YES;
                     }];
}

- (IBAction)_keyboardWillHide:(NSNotification *)notification {
    
    _queryResults = nil;
    
    self.searchBar.hidden = NO;
    self.tableView.hidden = YES;
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.searchBar.frame = _previousTextFieldFrame;
                         self.searchBar.layer.masksToBounds = YES;
                     } completion:nil];
}

@end
