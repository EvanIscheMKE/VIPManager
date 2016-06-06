//
//  HDSignupViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/31/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIImage+ImageAdditions.h"
#import "HDSignupViewController.h"
#import "HDItemManager.h"
#import "UIFont+FontAdditions.h"
#import "HDHelper.h"

static NSString * const HDTableViewCell1ReuseIndentifier = @"HDTableViewCell1ReuseIndentifier";
static NSString * const HDTableViewCell2ReuseIndentifier = @"HDTableViewCell2ReuseIndentifier";

@implementation HDSignupTableViewCell {
    NSMutableArray *_btns;
    CGFloat _startingBalance;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont stormGolfFontOfSize:16.0f];
        
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont stormGolfFontOfSize:40.0f];
        self.textField.returnKeyType = UIReturnKeyNext;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview: self.textField];
        
        self.textField.inputAccessoryView = self.toolbar;
        
        _startingBalance = [[HDItemManager sharedManager] currentVIPCardPrice];
    }
    return self;
}

- (UIToolbar *)toolbar {
    
    static UIToolbar *toolbar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect bounds = CGRectMake(0.0f, 0.0f, CGRectGetMidX([[UIScreen mainScreen] bounds]), 64.0f);
        UIView *container = [[UIView alloc] initWithFrame:bounds];
        
        _btns = [NSMutableArray new];
        
        const CGSize buttonSize = CGSizeMake(50.0f, 50.0f);
        
        CGFloat startingPointX = CGRectGetMidX(container.bounds) - (2.0 * (buttonSize.width + 10.0f)) / 2.0f;
        for (NSInteger i = 0; i < 3; i++) {
            CGRect bounds = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height);
            UIButton *button = [[UIButton alloc] initWithFrame:bounds];
            button.selected = (i==0);
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = (i==0)?[UIColor blackColor].CGColor:[UIColor grayColor].CGColor;
            button.layer.borderWidth = 1.0f;
            button.layer.cornerRadius = CGRectGetMidX(button.bounds);
            button.titleLabel.font = [UIFont stormGolfFontOfSize:12.0f];
            button.center = CGPointMake(startingPointX + (i * (50.0f + 10.0f)), CGRectGetMidY(container.bounds));
            [button addTarget:self action:@selector(_selectStartingBalance:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [button setTitle:[HDHelper stringFromNumber:([[HDItemManager sharedManager] currentVIPCardPrice] * (i + 1))]
                    forState:UIControlStateNormal];
            [container addSubview:button];
            [_btns addObject:button];
        }
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Save"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(dismiss)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:container];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
        UIBarButtonItem *fix  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                              target:nil
                                                                              action:nil];
        fix.width = 20.0f;
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentView.bounds), 64.0f)];
        toolbar.barTintColor = [UIColor whiteColor];
        toolbar.items = @[fix, item, flex, done, fix];

    });
    return toolbar;
}

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishedSignUpWithStartingBalance:)]) {
        /* FIX !Must point to selected Starting Balance! FIX */
        [self.delegate finishedSignUpWithStartingBalance:_startingBalance];
    }
}

- (IBAction)_selectStartingBalance:(UIButton *)sender {

    for (UIButton *btn in _btns) {
        btn.selected = NO;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    sender.selected = !sender.selected;
    sender.layer.borderColor = sender.selected ? [UIColor blackColor].CGColor : [UIColor grayColor].CGColor;
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    NSString *results = [[sender.titleLabel.text componentsSeparatedByCharactersInSet:[set invertedSet]] componentsJoinedByString:@""];
    
    _startingBalance = [results floatValue];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectInset(self.contentView.bounds, self.insetX, self.insetY);
    self.textField.center = CGPointMake(CGRectGetMidX(self.contentView.bounds),
                                        CGRectGetHeight(self.contentView.bounds) - CGRectGetMidY(self.textField.bounds));
    
    [self.contentView bringSubviewToFront:self.textLabel];
    if (self.textLabel.text) {
        [self.textLabel sizeToFit];
        self.textLabel.center = CGPointMake(self.insetX + CGRectGetMidX(self.textLabel.bounds),
                                            CGRectGetHeight(self.contentView.bounds) / 6.0f);
    }
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] setStroke];
    
    const CGFloat lineWidth = 1.0f;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = lineWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath moveToPoint:CGPointMake(self.insetX, CGRectGetHeight(self.contentView.bounds) - lineWidth / 2.0f)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.contentView.bounds) - self.insetX,
                                           CGRectGetHeight(self.contentView.bounds) - lineWidth / 2.0f)];
    [bezierPath stroke];
}

- (CGFloat)insetY {
    return 15.0f;
}

- (CGFloat)insetX {
    return CGRectGetWidth(self.contentView.bounds) / 6.0f;
}

@end

static const CGFloat TABLE_HEADER_HEIGHT = 20.0f;
static const CGFloat TABLE_HEADER__HEIGHT = 170.0f;
static const CGFloat TABLE_ROW_HEIGHT = 90.0f;

static const NSUInteger NUMBER_OF_ROWS_PER_SECTION = 1;
static const NSUInteger NUMBER_OF_SECTIONS = 3;

@interface HDSignupViewController ()<HDSignupViewTableViewCellDelegate>
@end

@implementation HDSignupViewController {
    NSArray *_titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = @[@"First Name", @"Last Name", @"Email (Optional)"];
    
    self.email = @"No Current Email";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerClass:[HDSignupTableViewCell class] forCellReuseIdentifier:HDTableViewCell1ReuseIndentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(_dismiss:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HDSignupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.textField becomeFirstResponder];
}

- (IBAction)_dismiss:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSignUpController:)]) {
        [self.delegate dismissSignUpController:self];
    }
}

- (void)finishedSignUpWithStartingBalance:(CGFloat)startingBalance {

    self.startingBalance = startingBalance;
    for (NSUInteger index = 0; index < [self numberOfSectionsInTableView:self.tableView]; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        HDSignupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        BOOL textFieldIsEmpty = NO;
        NSString *trimmedString = [cell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedString.length == 0) {
            textFieldIsEmpty = YES;
        }
        
        switch (index) {
            case 0:
                if (textFieldIsEmpty) {
                    NSLog(@"First Name Empty");
                    return;
                }
                
                self.firstName = cell.textField.text;
                break;
            case 1:
                if (textFieldIsEmpty) {
                    NSLog(@"Last Name Empty");
                    return;
                }
                
                self.lastName = cell.textField.text;
                break;
            case 2: {
                if (!textFieldIsEmpty) {
                    self.email = cell.textField.text;
                }
            } break;
            default:
                break;
        }
    }
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(signupIsCompleted:)]) {
        [self.delegate signupIsCompleted:self];
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:textField.tag + 1];
    HDSignupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (textField.tag == 1) { cell.textField.keyboardType = UIKeyboardTypeEmailAddress; }
    [cell.textField becomeFirstResponder];
    return NO;
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDSignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewCell1ReuseIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.textField.tag = indexPath.section;
    cell.textField.delegate = self;
    cell.textField.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_titles[indexPath.section] uppercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  TABLE_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return TABLE_HEADER__HEIGHT;
        case 1:
        case 2:
            return TABLE_HEADER_HEIGHT;
        default:
            return 0.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROWS_PER_SECTION;
}

@end
