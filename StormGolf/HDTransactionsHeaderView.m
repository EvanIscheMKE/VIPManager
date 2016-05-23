//
//  HDTransactionsHeaderView.m
//  StormGolf
//
//  Created by Evan Ische on 5/6/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionsHeaderView.h"
#import "UIColor+ColorAdditions.h"

static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .21;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .09916016;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .09916016;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .16875;

@implementation HDTransactionsHeaderView{
    NSArray *_values;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.backgroundView.backgroundColor = [UIColor flatSTRedColor];
        
        _values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                    @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                    @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                    @(ITEM_COST_SCREEN_PERCENTAGE),
                    @(ADMIN_NAME_SCREEN_PERCENTAGE),
                    @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                    @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
        
        for (NSUInteger i = 0; i < _values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.text = [[self _labelForIndex:i] uppercaseString];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:9.0f];
            [self.contentView addSubview:label];
            
            if ([[self _labelForIndex:i] isEqualToString:@"Transaction Date"]) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_updateQuery:)];
                tap.numberOfTapsRequired = 1;
                [label addGestureRecognizer:tap];
            }
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
            return @"   Customer Name";
        case 1:
            return @"Starting";
        case 2:
            return @"Ending";
        case 3:
            return @"Cost";
        case 4:
            return @"Cashier";
        case 5:
            return @"Transaction Date";
        case 6:
            return @"Description";
    }
    return nil;
}

- (IBAction)_updateQuery:(id)sender {
    NSLog(@"FLIP QUERY");
}

@end
