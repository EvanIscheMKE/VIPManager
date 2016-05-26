//
//  HDDataGridHeaderFooterView.m
//  StormGolf
//
//  Created by Evan Ische on 5/26/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIFont+FontAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDDataGridHeaderFooterView.h"
#import "HDTableViewHeaderBackgroundView.h"

/* Transactions */
static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .21;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .09916016;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .09916016;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .16875;

/* Sales */
static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = .2f;
static const CGFloat SALE_GRAPH_FULL_PERCENTAGE = .4f;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = .2f;
static const CGFloat TOTAL_AMOUNT_SCREEN_PERCENTAGE  = .2f;

/* Item Manager */
static const CGFloat ITEM_TITLE_SCREEN_PERCENTAGE = .8f;
static const CGFloat ITEM_VALUE_SCREEN_PERCENTAGE = .2f;

NSString * const HDDataGridValueKey = @"HDDataGridValueKey";
NSString * const HDDataGridTextKey = @"HDDataGridTextKey";

static const CGFloat DEFAULT_HEADER_HEIGHT = 44.0f;
@implementation HDDataGridHeaderFooterView {
    NSArray *_values;
    NSArray *_texts;
    CGFloat _height;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)performLayoutForValues:(NSArray *)values
                          text:(NSArray *)text {
    
    if (!self.backgroundView) {
        self.backgroundView = [[HDTableViewHeaderBackgroundView alloc] initWithFrame:self.contentView.bounds values:values];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        [(HDTableViewHeaderBackgroundView*)self.backgroundView setValues:values];
    }
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSUInteger i = 0; i < _values.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.text = text[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont stormGolfFontOfSize:16.0f];
        [self.contentView addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UILabel *subview in self.contentView.subviews) {
        const CGFloat labelWidthMultiplier = [[_values objectAtIndex:index] doubleValue];
        const CGFloat labelHeight = DEFAULT_HEADER_HEIGHT;
        const CGFloat labelWidth = labelWidthMultiplier * CGRectGetWidth(self.contentView.bounds);
        
        const CGRect labelFrame = CGRectMake(previousWidth,
                                             CGRectGetHeight(self.contentView.bounds) - DEFAULT_HEADER_HEIGHT,
                                             labelWidth,
                                             labelHeight);
        subview.frame = labelFrame;
        previousWidth += labelWidthMultiplier  * CGRectGetWidth(self.contentView.bounds);
        
        index++;
    }
}

+ (NSDictionary *)transaction {
    
    NSArray *values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                        @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                        @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                        @(ITEM_COST_SCREEN_PERCENTAGE),
                        @(ADMIN_NAME_SCREEN_PERCENTAGE),
                        @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                        @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
    
    NSArray *text = @[[NSString stringWithFrontOffset:@"Customer"],
                      [NSString stringWithFrontOffset:@"Starting"],
                      [NSString stringWithFrontOffset:@"Ending"],
                      [NSString stringWithFrontOffset:@"Cost"],
                      [NSString stringWithFrontOffset:@"Cashier"],
                      [NSString stringWithFrontOffset:@"Transaction Date"],
                      [NSString stringWithFrontOffset:@"Description"]];
    
    return @{HDDataGridValueKey:values,HDDataGridTextKey:text};
}

+ (NSDictionary *)sales {
    
    NSArray *values = @[@(ITEM_NAME_SCREEN_PERCENTAGE),
                        @(SALE_GRAPH_FULL_PERCENTAGE),
                        @(SALE_NUMBER_SCREEN_PERCENTAGE),
                        @(TOTAL_AMOUNT_SCREEN_PERCENTAGE)];
    
    NSArray *text = @[[NSString stringWithFrontOffset:@"Item Name"],
                      [NSString stringWithFrontOffset:@"Visual"],
                      [NSString stringWithFrontOffset:@"Sales"],
                      [NSString stringWithFrontOffset:@"Total"]];
    
    return @{HDDataGridValueKey:values,HDDataGridTextKey:text};
}

+ (NSDictionary *)itemManager {
    
    NSArray *values = @[@(ITEM_TITLE_SCREEN_PERCENTAGE),
                        @(ITEM_VALUE_SCREEN_PERCENTAGE)];
    
    NSArray *text = @[[NSString stringWithFrontOffset:@"Item Description"],
                      [NSString stringWithFrontOffset:@"Item Cost"]];
    
    return @{HDDataGridValueKey:values,HDDataGridTextKey:text};
}


@end
