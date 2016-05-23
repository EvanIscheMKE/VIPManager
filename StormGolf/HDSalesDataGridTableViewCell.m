//
//  HDSalesDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/23/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSalesDataGridTableViewCell.h"
#import "UIColor+ColorAdditions.h"
#import "HDHelper.h"

static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = .25;
static const CGFloat SALE_GRAPH_SCREEN_PERCENTAGE = .65;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = .1;

@implementation HDSalesDataGridTableViewCell {
    NSArray *_values;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _values = @[@(ITEM_NAME_SCREEN_PERCENTAGE),
                    @(SALE_GRAPH_SCREEN_PERCENTAGE),
                    @(SALE_NUMBER_SCREEN_PERCENTAGE)];
        
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        for (NSUInteger i = 0; i < _values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont boldSystemFontOfSize:13.0f];
            label.textColor = [UIColor flatSTDarkBlueColor];
            label.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:label];
        }
    }
    return self;
}


@end
