//
//  HDSearchBar.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSearchBar.h"

@interface HDSearchBar ()
@property (nonatomic, strong) UIColor *preferredTextColor;
@end

@implementation HDSearchBar {
    UIColor *_preferredTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.preferredTextColor = color;
        self.translucent = NO;
        self.searchBarStyle = UISearchBarStyleProminent;
        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (NSUInteger)indexOfSearchFieldInSubviews {
    
    NSUInteger index = 0;

    UIView *containerView = self.subviews.firstObject;
    for (int i = 0; i < containerView.subviews.count; i++) {
        if ([containerView.subviews[i] isKindOfClass:[UITextField class]]) {
            index = i;
        }
    }
    return index;
}

- (void)drawRect:(CGRect)rect {
    UITextField *textField = self.subviews.firstObject.subviews[[self indexOfSearchFieldInSubviews]];
    textField.frame = CGRectInset(self.bounds, 5.0f, 5.0f);
    textField.backgroundColor = self.barTintColor;
    textField.textColor = _preferredTextColor;
}


@end
