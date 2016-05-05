//
//  HDDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/5/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridTableViewCell.h"
#import "UIColor+ColorAdditions.h"

@implementation HDDataGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsTopCell:(BOOL)isTopCell {
    _isTopCell = isTopCell;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor flatPeterRiverColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    
    if (self.isTopCell) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, 1.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.contentView.bounds), 1.0f);
    }
    
    /* Draw Base line */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f,
                         CGRectGetHeight(self.contentView.bounds) - .5f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),
                            CGRectGetWidth(self.contentView.bounds),
                            CGRectGetHeight(self.contentView.bounds) - .5f);
    
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

@end
