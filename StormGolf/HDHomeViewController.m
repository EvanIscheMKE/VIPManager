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
#import "HDSearchBar.h"
#import "HDDBManager.h"

const CGFloat TEXTFIELD_HEIGHT = 70.0f;
const CGFloat TEXTFIELD_PADDING = 30.0f;

NSString * const HDNewMemberKey = @"New Member";
NSString * const HDItemManagerKey = @"Item Manager";
NSString * const HDAccountManagerKey = @"Account Manager";
NSString * const HDTransactionsKey = @"Transactions";

@interface HDHomeViewController () < UITableViewDelegate,
                                     UITableViewDataSource,
                                     UISearchBarDelegate >
@property (nonatomic, strong) HDSearchViewController *searchController;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HDHomeViewController {
    BOOL _shouldShowSearchResults;
    CGRect _previousTextFieldFrame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    const CGRect bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.5f, TEXTFIELD_HEIGHT);
    self.searchController.customSearchBar.frame = bounds;
    self.searchController.customSearchBar.center = self.view.center;
    self.searchController.customSearchBar.layer.cornerRadius = 5.0f;
    self.searchController.customSearchBar.layer.masksToBounds = YES;
    [self.view addSubview:self.searchController.customSearchBar];
    
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

#pragma mark - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        self.searchController.active = NO;
        return;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    _shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(HDSearchBar *)searchBar {
    _shouldShowSearchResults = NO;
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _shouldShowSearchResults) {
        return 5;
    }
    return 10;
}

#pragma mark - <Actions>

- (IBAction)_keyboardWillShow:(NSNotification *)notification {
    
     _previousTextFieldFrame = self.searchController.customSearchBar.frame;
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect frame = self.searchController.customSearchBar.frame;
                         frame.origin.x = 0.0f;
                         frame.origin.y = 20.0f;
                         frame.size.width = CGRectGetWidth(self.view.bounds);
                         self.searchController.customSearchBar.frame = frame;
                         self.searchController.customSearchBar.layer.masksToBounds = NO;
                     } completion:^(BOOL finished) {
                         self.tableView.tableHeaderView = self.searchController.customSearchBar;
                         self.tableView.hidden = NO;
                     }];
}

- (IBAction)_keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfoDictionary = [notification userInfo];
    NSTimeInterval duration = [userInfoDictionary[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.searchController.customSearchBar.frame = _previousTextFieldFrame;
                         self.searchController.customSearchBar.layer.cornerRadius = 5.0f;
                     } completion:nil];
}

@end
