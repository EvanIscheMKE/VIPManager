//
//  HDDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/5/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridTableViewCell.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .21;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .09916016;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .09916016;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .09916016;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .16875;

@implementation HDDataGridTableViewCell {
    NSArray *_values;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                    @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                    @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                    @(ITEM_COST_SCREEN_PERCENTAGE),
                    @(ADMIN_NAME_SCREEN_PERCENTAGE),
                    @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                    @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
        
   
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
        for (NSUInteger i = 0; i < _values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsTopCell:(BOOL)isTopCell {
    _isTopCell = isTopCell;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor flatPeterRiverColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    
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
    
    if (self.isTopCell) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, 1.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.contentView.bounds), 1.0f);
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f,
                         CGRectGetHeight(self.contentView.bounds));
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            CGRectGetWidth(self.contentView.bounds),
                            CGRectGetHeight(self.contentView.bounds));
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

#pragma mark - Setters

- (void)setMemberName:(NSString *)memberName {
    [(UILabel *)self.contentView.subviews[0] setText:memberName];
}

- (void)setStartingBalance:(NSString *)startingBalance {
    [(UILabel *)self.contentView.subviews[1] setText:startingBalance];
}

- (void)setEndingBalance:(NSString *)endingBalance {
     [(UILabel *)self.contentView.subviews[2] setText:endingBalance];
}

- (void)setItemCost:(NSString *)itemCost {
     [(UILabel *)self.contentView.subviews[3] setText:itemCost];
}

- (void)setCashierName:(NSString *)cashierName {
    [(UILabel *)self.contentView.subviews[4] setText:cashierName];
}

- (void)setTransactionDate:(NSString *)transactionDate {
    [(UILabel *)self.contentView.subviews[5] setText:transactionDate];
}

- (void)setItemDescription:(NSString *)itemDescription {
     [(UILabel *)self.contentView.subviews[6] setText:itemDescription];
}

@end
