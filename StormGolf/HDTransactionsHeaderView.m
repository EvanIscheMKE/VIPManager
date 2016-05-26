//
//  HDTransactionsHeaderView.m
//  StormGolf
//
//  Created by Evan Ische on 5/6/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTableViewHeaderBackgroundView.h"
#import "HDTransactionsHeaderView.h"
#import "NSString+StringAdditions.h"
#import "UIColor+ColorAdditions.h"

static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .21;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .09916016;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .09916016;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .16875;

@implementation HDTransactionsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self.values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                    @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                    @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                    @(ITEM_COST_SCREEN_PERCENTAGE),
                    @(ADMIN_NAME_SCREEN_PERCENTAGE),
                    @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                    @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //self.backgroundView =
    }
    return self;
}

- (NSString *)labelForIndex:(NSUInteger)index {
    NSString *title = nil;
    switch (index) {
        case 0:
            title = @"Customer";
            break;
        case 1:
            title = @"Starting";
            break;
        case 2:
            title = @"Ending";
            break;
        case 3:
            title = @"Cost";
            break;
        case 4:
            title = @"Cashier";
            break;
        case 5:
            title = @"Transaction Date";
            break;
        case 6:
            title = @"Description";
            break;
    }
    return [NSString stringWithFrontOffset:title];
}

@end
