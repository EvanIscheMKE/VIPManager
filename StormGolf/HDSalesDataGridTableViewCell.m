//
//  HDSalesDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/23/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "NSString+StringAdditions.h"
#import "HDSalesDataGridTableViewCell.h"
#import "HDDataVisualizationView.h"
#import "UIColor+ColorAdditions.h"
#import "UIFont+FontAdditions.h"
#import "HDHelper.h"

static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = .2f;
static const CGFloat SALE_GRAPH_SCREEN_PERCENTAGE = .4f;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = .2f;
static const CGFloat TOTAL_AMOUNT_SCREEN_PERCENTAGE  = .2f;

static const CGFloat INDEX_OF_VISUALIZATIONS = 1;
@implementation HDSalesDataGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self.values = @[@(ITEM_NAME_SCREEN_PERCENTAGE),
                    @(SALE_GRAPH_SCREEN_PERCENTAGE),
                    @(SALE_NUMBER_SCREEN_PERCENTAGE),
                    @(TOTAL_AMOUNT_SCREEN_PERCENTAGE)];
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {}
    return self;
}

- (void)layoutLabels {
    for (NSUInteger i = 0; i < self.values.count; i++) {
        if (INDEX_OF_VISUALIZATIONS == i) {
            self.dataView = [HDDataVisualizationView new];
            [self.contentView addSubview:self.dataView];
        } else {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont stormGolfFontOfSize:16.0f];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:label];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UIView *subview in self.contentView.subviews) {
        const CGFloat labelWidthMultiplier = [[self.values objectAtIndex:index] doubleValue];
        const CGFloat labelHeight = CGRectGetHeight(self.contentView.bounds);
        const CGFloat labelWidth = labelWidthMultiplier * CGRectGetWidth(self.contentView.bounds);
        const CGRect labelFrame = CGRectMake(previousWidth, 0.0f, labelWidth, labelHeight);
        
        if (INDEX_OF_VISUALIZATIONS == index) {
            subview.frame = CGRectInset(labelFrame, 1.0f, 1.0f);
        } else {
            subview.frame = labelFrame;
        }
        
        previousWidth += labelWidthMultiplier  * CGRectGetWidth(self.contentView.bounds);
        
        index++;
    }
}

- (void)setItemDescription:(NSString *)itemDescription {
    [(UILabel *)self.contentView.subviews.firstObject setText:[NSString stringWithFrontOffset:itemDescription]];
}

- (void)setAmountSold:(NSString *)amountSold {
    [(UILabel *)self.contentView.subviews[2] setText:[NSString stringWithFrontOffset:amountSold]];
}

- (void)setTotalSold:(NSString *)totalSold {
    [(UILabel *)self.contentView.subviews.lastObject setText:[NSString stringWithFrontOffset:totalSold]];
}

@end
