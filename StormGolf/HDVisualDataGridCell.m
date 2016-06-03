//
//  HDVisualDataGridCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDVisualDataGridCell.h"

static const CGFloat INSET_X = 10.0f;
@implementation HDVisualDataGridCell {
    CGFloat _pixelsPerPoint;
    CGFloat _pointMultiple;
    CGFloat _maxWidth;
    CGFloat _plotWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* */
        self.backgroundColor = [UIColor whiteColor];
        self.strokeColor = [UIColor blueColor];
        self.lineWidth = 16.0f;
        
        /* */
        _plotWidth = 0.0f;
        _pointMultiple = 0.0f;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /* */
    _maxWidth = CGRectGetWidth(CGRectInset(self.bounds, INSET_X, 0.0f));
    if (_maxWidth > 0) {
        _pixelsPerPoint = _maxWidth / 100.0f;
    }
    
    self.max = self.max;
    self.plot = self.plot;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [self.strokeColor setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = self.lineWidth;
    [bezierPath moveToPoint:CGPointMake(INSET_X, CGRectGetMidY(self.bounds))];
    [bezierPath addLineToPoint:CGPointMake(MAX(_plotWidth + INSET_X, INSET_X), CGRectGetMidY(self.bounds))];
    [bezierPath stroke];
}

- (void)setMax:(NSUInteger)max {
    _max = max;
    _pointMultiple = 100.0f / _max;
}

- (void)setPlot:(NSUInteger)plot {
    _plot = plot;
    _plotWidth = roundl(_plot * _pointMultiple * _pixelsPerPoint);
}


@end
