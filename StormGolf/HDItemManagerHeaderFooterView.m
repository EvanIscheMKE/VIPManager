//
//  HDItemManagerHeaderFooterView.m
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//


#import "UIColor+ColorAdditions.h"
#import "NSString+StringAdditions.h"
#import "HDTableViewHeaderBackgroundView.h"
#import "HDItemManagerHeaderFooterView.h"

static const CGFloat ITEM_TITLE_SCREEN_PERCENTAGE = .8f;
static const CGFloat ITEM_VALUE_SCREEN_PERCENTAGE = .2f;
@implementation HDItemManagerHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self.values = @[@(ITEM_TITLE_SCREEN_PERCENTAGE),
                    @(ITEM_VALUE_SCREEN_PERCENTAGE)];
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) { }
    return self;
}

- (NSString *)labelForIndex:(NSUInteger)index {
    NSString *title = nil;
    switch (index) {
        case 0:
            title = @"Item Description";
            break;
        case 1:
            title = @"Item Cost";
            break;
    }
    return [NSString stringWithFrontOffset:title];
}

@end
