//
//  HDTransactionsHeaderView.m
//  StormGolf
//
//  Created by Evan Ische on 5/6/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionsHeaderView.h"
#import "UIColor+ColorAdditions.h"

static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .24414062;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .078125;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .078125;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .078125;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .078125;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .21875;

@implementation HDTableViewGridView

- (void)drawRect:(CGRect)rect {
      
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor flatPeterRiverColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0f);
    
    NSArray *values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                      @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                      @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                      @(ITEM_COST_SCREEN_PERCENTAGE),
                      @(ADMIN_NAME_SCREEN_PERCENTAGE),
                      @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                      @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
    
    CGFloat previousWidth = 0.0f;
    for (NSUInteger i = 0; i < values.count; i++) {
        const CGFloat width = [[values objectAtIndex:i] floatValue] * CGRectGetWidth(self.bounds);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousWidth, 0.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), previousWidth, CGRectGetHeight(self.bounds));
        previousWidth += width;
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    /* Draw Top Line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, 1.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), 1.0f);
    
    /* Stroke Em All */
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

@end

@implementation HDTransactionsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[HDTableViewGridView alloc] initWithFrame:self.contentView.bounds];
        self.backgroundView.backgroundColor = [UIColor flatSTWhiteColor];
    }
    return self;
}

@end
