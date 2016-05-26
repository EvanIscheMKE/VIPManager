//
//  HDTableViewHeaderBackgroundView.m
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIColor+ColorAdditions.h"
#import "HDTableViewHeaderBackgroundView.h"

static const CGFloat DEFAULT_HEADER_HEIGHT = 44.0f;
@implementation HDTableViewHeaderBackgroundView

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values {
    if (self = [super initWithFrame:frame]) {
        self.values = values;
    }
    return self;
}

- (void)setValues:(NSArray *)values {
    _values = values;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(0.0f, CGRectGetHeight(self.bounds) - DEFAULT_HEADER_HEIGHT, CGRectGetWidth(self.bounds), DEFAULT_HEADER_HEIGHT));
    
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0f);
    
    const CGFloat topLineOriginY = CGRectGetHeight(self.bounds) - DEFAULT_HEADER_HEIGHT + .5f;
    
    CGFloat previousWidth = 0.0f;
    for (NSUInteger i = 0; i < _values.count; i++) {
        const CGFloat width = [[_values objectAtIndex:i] floatValue] * CGRectGetWidth(self.bounds);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousWidth, topLineOriginY);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), previousWidth, CGRectGetHeight(self.bounds));
        previousWidth += width;
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, CGRectGetHeight(self.bounds) - .5f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - .5f);
    
    /* Draw Top Line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, topLineOriginY);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), topLineOriginY);
    
    /* Stroke Em All */
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

@end
