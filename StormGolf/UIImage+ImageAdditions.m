//
//  UIImage+ImageAdditions.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"

@implementation UIImage (ImageAdditions)

+ (UIImage *)additionSignImageWithSize:(CGSize)size {
    
    static UIImage *addition = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        
        const CGFloat inset = size.width / 3.15f;
        
        UIBezierPath *horizontal = [UIBezierPath bezierPath];
        [horizontal moveToPoint:CGPointMake(inset, size.height / 2.0f)];
        [horizontal addLineToPoint:CGPointMake(size.width - inset, size.height / 2.0f)];
        
        UIBezierPath *vertical = [UIBezierPath bezierPath];
        [vertical moveToPoint:CGPointMake(size.width / 2.0f, inset)];
        [vertical addLineToPoint:CGPointMake(size.width / 2.0f, size.height - inset)];
        
        [[UIColor flatSTRedColor] setStroke];
        for (UIBezierPath *path in @[horizontal, vertical]) {
            path.lineWidth = 6.0f;
            path.lineCapStyle = kCGLineCapRound;
            [path stroke];
        }
        
        addition = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return addition;
}

@end
