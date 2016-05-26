//
//  HDSalesHeaderView.m
//  StormGolf
//
//  Created by Evan Ische on 5/23/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSalesHeaderView.h"
#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDTableViewHeaderBackgroundView.h"

static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = .2f;
static const CGFloat SALE_GRAPH_FULL_PERCENTAGE = .4f;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = .2f;
static const CGFloat TOTAL_AMOUNT_SCREEN_PERCENTAGE  = .2f;

@implementation HDSalesHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self.values = @[@(ITEM_NAME_SCREEN_PERCENTAGE),
                @(SALE_GRAPH_FULL_PERCENTAGE),
                @(SALE_NUMBER_SCREEN_PERCENTAGE),
                @(TOTAL_AMOUNT_SCREEN_PERCENTAGE)];
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) { }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    /* */
}

- (NSString *)labelForIndex:(NSUInteger)index {
    NSString *title = nil;
    switch (index) {
        case 0:
            title = @"Item Name";
            break;
        case 1:
            title = @"Visual";
            break;
        case 2:
            title = @"Sales";
            break;
        case 3:
            title = @"Total";
            break;
    }
    return [NSString stringWithFrontOffset:title];
}

@end
