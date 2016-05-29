//
//  HDDataGridTestHeader.m
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridTestHeader.h"
#import "UIFont+FontAdditions.h"
#import "UIColor+ColorAdditions.h"

@implementation HDDataGridTestHeader {
    NSArray *_columnWidths;
    NSArray *_columnTitles;
}

- (void)layoutColumnWidths:(NSArray *)columnWidths
              columnTitles:(NSArray *)columnTitles {
    
    self.backgroundColor = [UIColor blackColor];
    
    self.clearsContextBeforeDrawing = YES;
    
    _columnWidths = columnWidths;
    _columnTitles = columnTitles;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger i = 0; i < columnWidths.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.text = columnTitles[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont stormGolfFontOfSize:16.0f];
        [self addSubview:label];
    }
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UILabel *subview in self.subviews) {
        const CGFloat labelHeight = CGRectGetHeight(self.bounds);
        subview.frame = CGRectMake(previousWidth, 0.0f, [_columnWidths[index] doubleValue], labelHeight);
        previousWidth += CGRectGetWidth(subview.bounds);
        index++;
    }
}

- (void)drawRect:(CGRect)rect {
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0f);
    
    CGFloat previousWidth = [_columnWidths.firstObject doubleValue];
    for (NSUInteger i = 1; i < _columnWidths.count; i++) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousWidth - .5f, 0.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), previousWidth - .5f, CGRectGetHeight(self.bounds));
        previousWidth += [[_columnWidths objectAtIndex:i] floatValue];
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, CGRectGetHeight(self.bounds) - .5f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - .5f);
    
    /* Draw Top Line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.bounds), 0.0f);
    
    /* Stroke Em All */
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

@end
