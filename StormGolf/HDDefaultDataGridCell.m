//
//  HDDefaultDataGridCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDHelper.h"
#import "UIColor+ColorAdditions.h"
#import "HDDefaultDataGridCell.h"
#import "UIFont+FontAdditions.h"

@implementation HDDefaultDataGridCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        
        [self layoutLabels];
    }
    return self;
}

- (void)layoutLabels {
    for (NSUInteger i = 0; i < self.values.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont stormGolfFontOfSize:16.0f];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UILabel *subview in self.contentView.subviews) {
        const CGFloat labelWidthMultiplier = [[self.values objectAtIndex:index] doubleValue];
        const CGFloat labelHeight = CGRectGetHeight(self.contentView.bounds);
        const CGFloat labelWidth = labelWidthMultiplier * CGRectGetWidth(self.contentView.bounds);
        const CGRect labelFrame = CGRectMake(previousWidth, 0.0f, labelWidth, labelHeight);
        subview.frame = labelFrame;
        previousWidth += labelWidthMultiplier  * CGRectGetWidth(self.contentView.bounds);
        
        index++;
    }
}

- (void)drawRect:(CGRect)rect {
    
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    
    CGFloat previousWidth = 0.0f;
    for (NSUInteger i = 0; i < self.values.count; i++) {
        const CGFloat width = [[self.values objectAtIndex:i] floatValue] * CGRectGetWidth(self.bounds);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousWidth, 0.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), previousWidth, CGRectGetHeight(self.bounds));
        previousWidth += width;
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f,
                         CGRectGetHeight(self.contentView.bounds));
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            CGRectGetWidth(self.contentView.bounds),
                            CGRectGetHeight(self.contentView.bounds));
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

@end
