//
//  HDItemManagerPopoverViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManager.h"
#import "HDItemManagerPopoverViewController.h"

static NSString * const HDTableViewTextFieldCellReuseIdentifier = @"HDTableViewTextFieldCellReuseIdentifier";
static NSString * const HDTableViewSwitchCellReuseIdentifier = @"HDTableViewSwitchCellReuseIdentifier";
static NSString * const HDDictionaryDescriptionKey = @"HDDictionaryDescriptionKey";
static NSString * const HDDictionaryPlaceholderKey = @"HDDictionaryPlaceholderKey";
static NSString * const HDDictionaryKeyboardKey = @"HDDictionaryKeyboardKey";
static NSString * const HDDictionaryReturnKey = @"HDDictionaryReturnKey";

NSString * const HDTableViewReloadDataNotification = @"HDTableViewReloadDataNotification";
@interface HDTextFieldTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@end

@implementation HDTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, CGRectGetHeight(self.contentView.bounds))];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.contentView.bounds;
}

@end

@interface HDItemManagerPopoverViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *items;
@end

@implementation HDItemManagerPopoverViewController {
    NSString *_description;
    BOOL _shouldReduce;
    CGFloat _cost;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self.tableView registerClass:[HDTextFieldTableViewCell class] forCellReuseIdentifier:HDTableViewTextFieldCellReuseIdentifier];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTableViewSwitchCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[ @{ HDDictionaryPlaceholderKey:@"Item Description",
                       HDDictionaryDescriptionKey:@"Enter a brief item description (1-3 words)",
                       HDDictionaryReturnKey:@(UIReturnKeyNext),
                       HDDictionaryKeyboardKey:@(UIKeyboardTypeDefault) },
                    @{ HDDictionaryPlaceholderKey:@"Item Cost",
                       HDDictionaryDescriptionKey:@"Enter the item cost in '0.00' format excluding any symbols($).",
                       HDDictionaryReturnKey:@(UIReturnKeyDone),
                       HDDictionaryKeyboardKey:@(UIKeyboardTypePhonePad) },
                    @{ HDDictionaryPlaceholderKey:@"Reduce Cost",
                       HDDictionaryDescriptionKey:@"'ON' will reduce the cost from the users current balance,'OFF' will increase the users current balance by item cost.",
                       HDDictionaryReturnKey:@(UIReturnKeyDone),
                       HDDictionaryKeyboardKey:@(UIKeyboardTypePhonePad) }];
    
    self.title = @"Add Item";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(_save:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(_cancel:)];
}

- (IBAction)_save:(id)sender {
    HDItem *item = [[HDItem alloc] init];
    item.itemCost = _cost;
    item.itemDescription = _description;
    [[HDItemManager sharedManager] addItem:item];
    [[NSNotificationCenter defaultCenter] postNotificationName:HDTableViewReloadDataNotification object:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.items[section] objectForKey:HDDictionaryDescriptionKey];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastRow = (indexPath.section == self.items.count - 1);
    if (isLastRow) {
        UISwitch *accessorySwitch = [[UISwitch alloc] init];
        [accessorySwitch addTarget:self action:@selector(_updateSwitch:) forControlEvents:UIControlEventValueChanged];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewSwitchCellReuseIdentifier forIndexPath:indexPath];
        cell.accessoryView = accessorySwitch;
        cell.textLabel.text = [self.items[indexPath.section] objectForKey:HDDictionaryPlaceholderKey];
        return cell;
    } else {
        HDTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewTextFieldCellReuseIdentifier forIndexPath:indexPath];
        cell.textField.tag = indexPath.section;
        cell.textField.delegate = self;
        cell.textField.placeholder   =  [self.items[indexPath.section] objectForKey:HDDictionaryPlaceholderKey];
        cell.textField.returnKeyType = [[self.items[indexPath.section] objectForKey:HDDictionaryReturnKey] integerValue];
        cell.textField.keyboardType  = [[self.items[indexPath.section] objectForKey:HDDictionaryKeyboardKey] integerValue];
        return cell;
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textFieldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0:
            _description = textFieldText;
            break;
        case 1:
            _cost = [textFieldText floatValue];
            break;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        HDTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        return [cell.textField becomeFirstResponder];
    }
    return [textField resignFirstResponder];
}

#pragma mark - IBAction

- (IBAction)_updateSwitch:(UISwitch *)sender {
    _shouldReduce = sender.on;
}

@end
