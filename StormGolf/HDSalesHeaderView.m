//
//  HDSalesHeaderView.m
//  StormGolf
//
//  Created by Evan Ische on 5/23/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSalesHeaderView.h"
#import "UIColor+ColorAdditions.h"

static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = .2;
static const CGFloat SALE_GRAPH_MIN_SCREEN_PERCENTAGE = .6;
static const CGFloat SALE_GRAPH_MAX_SCREEN_PERCENTAGE = .1;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = .1;

@implementation HDSalesHeaderView {
    NSArray *_values;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.backgroundView.backgroundColor = [UIColor flatSTRedColor];
        
        _values = @[@(ITEM_NAME_SCREEN_PERCENTAGE),
                    @(SALE_GRAPH_MIN_SCREEN_PERCENTAGE),
                    @(SALE_GRAPH_MAX_SCREEN_PERCENTAGE),
                    @(SALE_NUMBER_SCREEN_PERCENTAGE)];
        
        for (NSUInteger i = 0; i < _values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.text = [[self _labelForIndex:i] uppercaseString];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:9.0f];
            [self.contentView addSubview:label];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UILabel *subview in self.contentView.subviews) {
        const CGFloat labelWidthMultiplier = [[_values objectAtIndex:index] doubleValue];
        const CGFloat labelHeight = CGRectGetHeight(self.contentView.bounds);
        const CGFloat labelWidth = labelWidthMultiplier * CGRectGetWidth(self.contentView.bounds);
        const CGRect labelFrame = CGRectMake(previousWidth, 0.0f, labelWidth, labelHeight);
        subview.frame = labelFrame;
        previousWidth += labelWidthMultiplier  * CGRectGetWidth(self.contentView.bounds);
        
        index++;
    }
}

- (NSString *)_labelForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"   Item Name";
        case 1:
            return @"0";
        case 2:
            return @"40";
        case 3:
            return @"Sales";
    }
    return nil;
}

@end
