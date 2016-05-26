//
//  HDToolBar.m
//  StormGolf
//
//  Created by Evan Ische on 5/25/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDToolBar.h"

@implementation HDToolBar

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f = self.frame;
    f.size.height = 54.0f;
    self.frame = f;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize s = [super sizeThatFits:size];
    return CGSizeMake(s.width, 54.0f);
}

@end
