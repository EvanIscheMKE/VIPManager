//
//  HDDefaultHeaderFooterView.m
//  StormGolf
//
//  Created by Evan Ische on 5/25/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDefaultHeaderFooterView.h"
#import "HDTableViewHeaderBackgroundView.h"
#import "UIFont+FontAdditions.h"

@implementation HDDefaultHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.backgroundView = [[HDTableViewHeaderBackgroundView alloc] initWithFrame:self.contentView.bounds values:self.values];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        for (NSUInteger i = 0; i < self.values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.text = [self labelForIndex:i];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont stormGolfFontOfSize:16.0f];
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
        const CGFloat labelWidthMultiplier = [[self.values objectAtIndex:index] doubleValue];
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

- (NSString *)labelForIndex:(NSUInteger)index {
    NSAssert(NO, @"'%@' must be overridden in subclass",NSStringFromSelector(_cmd));
    return false;
}

@end
