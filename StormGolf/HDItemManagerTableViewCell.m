//
//  HDItemManagerTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "NSString+StringAdditions.h"
#import "UIColor+ColorAdditions.h"
#import "HDItemManagerTableViewCell.h"

static const CGFloat ITEM_TITLE_SCREEN_PERCENTAGE = .8f;
static const CGFloat ITEM_VALUE_SCREEN_PERCENTAGE = .2f;

@implementation HDItemManagerTableViewCell {
    NSArray *_values;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.values = @[@(ITEM_TITLE_SCREEN_PERCENTAGE),
                  @(ITEM_VALUE_SCREEN_PERCENTAGE)];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setItemTitle:(NSString *)itemTitle {
    [(UILabel *)self.contentView.subviews.firstObject setText:[NSString stringWithFrontOffset:itemTitle]];
}

- (void)setItemCost:(NSString *)itemCost {
    [(UILabel *)self.contentView.subviews.lastObject setText:[NSString stringWithFrontOffset:itemCost]];
}

@end
