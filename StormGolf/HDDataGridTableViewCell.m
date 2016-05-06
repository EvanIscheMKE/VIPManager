//
//  HDDataGridTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/5/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridTableViewCell.h"
#import "UIColor+ColorAdditions.h"


static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = .24414062;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = .078125;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = .078125;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = .078125;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = .078125;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = .22460938;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = .21875;

@implementation HDDataGridTableViewCell {
    NSArray *_values;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _values = @[@(MEMBER_NAME_SCREEN_PERCENTAGE),
                    @(STARTING_BALANCE_SCREEN_PERCENTAGE),
                    @(ENDING_BALANCE_SCREEN_PERCENTAGE),
                    @(ITEM_COST_SCREEN_PERCENTAGE),
                    @(ADMIN_NAME_SCREEN_PERCENTAGE),
                    @(TRANSITION_DATE_SCREEN_PERCENTAGE),
                    @(TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE)];
        
   
        for (NSUInteger i = 0; i < _values.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.text = @"$20.00";
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            
            switch (i) {
                case 0:
                    label.text = @"  EVAN ISCHE";
                    label.textAlignment = NSTextAlignmentLeft;
                    break;
                case 5:
                    label.text = @"2016-05-04 18:36:41";
                    break;
                case 6:
                    label.text = @"VIP Member";
                    break;
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat previousWidth = 0.0f;
    
    NSUInteger index = 0;
    for (UILabel *subview in self.contentView.subviews) {
        const CGFloat labelWidthMultiplier = [[_values objectAtIndex:index] doubleValue];
        const CGFloat labelHeight = CGRectGetHeight(self.contentView.bounds);
        const CGFloat labelWidth = labelWidthMultiplier * CGRectGetWidth(self.contentView.bounds);
        const CGRect labelFrame = CGRectMake(previousWidth, 0.0f, labelWidth, labelHeight);
        subview.frame = labelFrame;
        previousWidth += labelWidthMultiplier  * CGRectGetWidth(self.contentView.bounds);
        
        index++;
    }
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
    
    /* Setup */
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor flatPeterRiverColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    
    /* Member Name */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 250.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 250.0, CGRectGetHeight(self.contentView.bounds));
    
    /* Starting Balance */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 330.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 330.0, CGRectGetHeight(self.contentView.bounds));
    
    /* Ending Balance */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 410.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 410.0, CGRectGetHeight(self.contentView.bounds));
    
    /* Item Cost */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 490.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 490.0, CGRectGetHeight(self.contentView.bounds));
    
    /* Admin */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 570.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 570.0, CGRectGetHeight(self.contentView.bounds));
    
    /* Date */
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 800.0f, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 800.0, CGRectGetHeight(self.contentView.bounds));
    
    if (self.isTopCell) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.0f, 1.0f);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGRectGetWidth(self.contentView.bounds), 1.0f);
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
