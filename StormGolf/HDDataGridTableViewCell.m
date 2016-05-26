//
//  HDDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/5/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "NSString+StringAdditions.h"
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

@implementation HDDataGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self.values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                    @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                    @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                    @(ITEM_COST_SCREEN_PERCENTAGE),
                    @(ADMIN_NAME_SCREEN_PERCENTAGE),
                    @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                    @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    return self;
}

#pragma mark - Setters

- (void)setMemberName:(NSString *)memberName {
    [(UILabel *)self.contentView.subviews[0] setText:[NSString stringWithFrontOffset:memberName]];
}

- (void)setStartingBalance:(NSString *)startingBalance {
    [(UILabel *)self.contentView.subviews[1] setText:[NSString stringWithFrontOffset:startingBalance]];
}

- (void)setEndingBalance:(NSString *)endingBalance {
    [(UILabel *)self.contentView.subviews[2] setText:[NSString stringWithFrontOffset:endingBalance]];
}

- (void)setItemCost:(NSString *)itemCost {
    [(UILabel *)self.contentView.subviews[3] setText:[NSString stringWithFrontOffset:itemCost]];
}

- (void)setCashierName:(NSString *)cashierName {
    [(UILabel *)self.contentView.subviews[4] setText:[NSString stringWithFrontOffset:cashierName]];
}

- (void)setTransactionDate:(NSString *)transactionDate {
    [(UILabel *)self.contentView.subviews[5] setText:[NSString stringWithFrontOffset:transactionDate]];
}

- (void)setItemDescription:(NSString *)itemDescription {
    [(UILabel *)self.contentView.subviews[6] setText:[NSString stringWithFrontOffset:itemDescription]];
}

@end
