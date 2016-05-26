//
//  HDItemManagerPopoverViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import QuartzCore;

#import "HDItemManager.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "HDItemManagerPopoverViewController.h"
#import "UIFont+FontAdditions.h"

static NSString * const HDTableViewTextFieldCellReuseIdentifier = @"HDTableViewTextFieldCellReuseIdentifier";
static NSString * const HDTableViewSwitchCellReuseIdentifier = @"HDTableViewSwitchCellReuseIdentifier";
static NSString * const HDDictionaryDescriptionKey = @"HDDictionaryDescriptionKey";
static NSString * const HDDictionaryPlaceholderKey = @"HDDictionaryPlaceholderKey";
static NSString * const HDDictionaryKeyboardKey = @"HDDictionaryKeyboardKey";
static NSString * const HDDictionaryReturnKey = @"HDDictionaryReturnKey";

NSString * const HDTableViewReloadDataNotification = @"HDTableViewReloadDataNotification";

static const NSUInteger NUMBER_OF_SUBVIEWS = 4;
@interface HDItemManagerPopoverViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *items;
@end

@implementation HDItemManagerPopoverViewController {
    NSMutableArray *_btns;
    NSString *_description;
    CGFloat _cost;
}

- (instancetype)init {
    if (self = [super init]) {
        _btns = [@[] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = @[ @{ HDDictionaryPlaceholderKey:@"Item Description",
                       HDDictionaryReturnKey:@(UIReturnKeyNext),
                       HDDictionaryKeyboardKey:@(UIKeyboardTypeDefault) },
                    @{ HDDictionaryPlaceholderKey:@"Item Cost",
                       HDDictionaryReturnKey:@(UIReturnKeyDone),
                       HDDictionaryKeyboardKey:@(UIKeyboardTypePhonePad) }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.superview.layer.cornerRadius = 0;
    self.view.layer.cornerRadius = 0;
    
    const CGSize size = CGSizeMake(CGRectGetWidth(CGRectInset(self.view.bounds, 10.0f, 0.0)),
                                   CGRectGetHeight(self.view.bounds) / 6.f);
    const CGFloat startingPositionY = CGRectGetMidY(self.view.bounds) - (((NUMBER_OF_SUBVIEWS - 1) * (size.height + 18.0f)) / 2);
    for (NSUInteger i = 0; i < NUMBER_OF_SUBVIEWS; i++) {
        CGRect bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
        CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), startingPositionY + i * (size.height + 18.0f));
        switch (i) {
            case 0:
            case 1:{
                UITextField *textField = [[UITextField alloc] initWithFrame:bounds];
                textField.center = center;
                textField.font = [UIFont stormGolfFontOfSize:18.0f];
                textField.backgroundColor = [UIColor whiteColor];
                textField.layer.borderWidth = 1.0f;
                textField.layer.borderColor = [UIColor blackColor].CGColor;
                textField.placeholder = [self.items[i] objectForKey:HDDictionaryPlaceholderKey];
                textField.keyboardType = [[self.items[i] objectForKey:HDDictionaryKeyboardKey] integerValue];
                textField.returnKeyType = [[self.items[i] objectForKey:HDDictionaryReturnKey] integerValue];
                textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, CGRectGetHeight(textField.bounds))];
                textField.leftViewMode = UITextFieldViewModeAlways;
                [self.view addSubview:textField];
            } break;
            case 2: {
                
                UIView *container = [[UIView alloc] initWithFrame:bounds];
                container.center = center;
                [self.view addSubview:container];
                
                CGRect startingFrame = CGRectMake(0.0f, 0.0f, (size.width - 10.0f) / 2.0, size.height);
                
                CGRect previousFrame = CGRectZero;
                for (NSUInteger i = 0; i < 2; i++) {
                    CGRect currentFrame = previousFrame;
                    if (i==0) {
                        currentFrame = startingFrame;
                    } else {
                        CGRect f = currentFrame;
                        f.origin.x += CGRectGetWidth(currentFrame) + 10.0f;
                        currentFrame = f;
                    }
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:currentFrame];
                    button.layer.borderWidth = 1.0f;
                    button.layer.borderColor = [UIColor blackColor].CGColor;
                    button.adjustsImageWhenDisabled = NO;
                    button.adjustsImageWhenHighlighted = NO;
                    button.titleLabel.font = [UIFont stormGolfFontOfSize:18.0f];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    [button setBackgroundImage:[UIImage backgroundWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage backgroundWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
                    [button addTarget:self action:@selector(_updateButtonState:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:(i==0)?@"Increase":@"Decrease" forState:UIControlStateNormal];
                    button.selected = (i==1);
                    [_btns addObject:button];
                    [container addSubview:button];
                    
                    previousFrame = currentFrame;
                }
                
            } break;
            case 3: {
                UIButton *button = [[UIButton alloc] initWithFrame:bounds];
                button.backgroundColor = [UIColor blackColor];
                button.center = center;
                button.titleLabel.font = [UIFont stormGolfFontOfSize:18.0f];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:@"Add Item" forState:UIControlStateNormal];
                [self.view addSubview:button];
            } break;
            default:
                break;
        }
    }
}

- (IBAction)_updateButtonState:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [_btns makeObjectsPerformSelector:@selector(setSelected:) withObject:0];
    sender.selected = YES;
}

- (IBAction)_save:(id)sender {
    
    if (_description.length > 2) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
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
    }
    return [textField resignFirstResponder];
}

@end
