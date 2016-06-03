//
//  HDDataGridTestHeader.m
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridHeader.h"
#import "UIFont+FontAdditions.h"
#import "UIColor+ColorAdditions.h"

@implementation HDDataGridHeader {
    NSArray *_columnWidths;
    NSArray *_columnTitles;
}

- (void)layoutColumnWidths:(NSArray *)columnWidths
              columnTitles:(NSArray *)columnTitles {
    
    self.backgroundColor = [UIColor flatDataGridSeperatorColor];
    
    self.clearsContextBeforeDrawing = YES;
    
    _columnWidths = columnWidths;
    _columnTitles = columnTitles;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger i = 0; i < columnWidths.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor flatDataGridHeaderTextColor];
        label.text = columnTitles[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0f];
        [self addSubview:label];
    }
}

- (void)layoutSubviews {
    
    CGFloat previousWidth = 0.0f;
    [super layoutSubviews];
    
    NSUInteger index = 0;
    for (UILabel *subview in self.subviews) {
        const CGFloat labelHeight = CGRectGetHeight(CGRectInset(self.bounds, 0.0f, 1.0f));
        subview.frame = CGRectMake(previousWidth, 1.0f, [_columnWidths[index] doubleValue], labelHeight);
        previousWidth += CGRectGetWidth(subview.bounds) + 1.0f;
        index++;
    }
}


@end
