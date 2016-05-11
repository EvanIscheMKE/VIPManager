//
//  HDSearchBar.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSearchBar.h"

@implementation HDSearchBar {
    UIColor *_preferredTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        
        //
        _preferredTextColor = color;
        
        //
        self.translucent = NO;
        
        //
        self.searchBarStyle = UISearchBarStyleProminent;
    }
    return self;
}

- (NSUInteger)indexOfSearchFieldInSubviews {
    
    //
    NSUInteger index = 0;
    
    //
    UIView *containerView = self.subviews.firstObject;
    for (int i = 0; i < containerView.subviews.count; i++) {
        if ([containerView.subviews[i] isKindOfClass:[UITextField class]]) {
            index = i;
        }
    }
    return index;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UITextField *textField = self.subviews.firstObject.subviews[[self indexOfSearchFieldInSubviews]];
    textField.frame = CGRectInset(self.bounds, 5.0f, 5.0f);
    textField.backgroundColor = self.barTintColor;
    textField.textColor = _preferredTextColor;
}


@end
