//
//  UIFont+FontAdditions.m
//  StormGolf
//
//  Created by Evan Ische on 5/25/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIFont+FontAdditions.h"

@implementation UIFont (FontAdditions)

+ (UIFont *)stormGolfFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans" size:fontSize];
}

+ (UIFont *)stormGolfLightFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"GillSans-Light" size:fontSize];
}

@end
