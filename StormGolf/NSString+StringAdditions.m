//
//  NSString+StringAdditions.m
//  StormGolf
//
//  Created by Evan Ische on 5/20/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDHelper.h"
#import "NSString+StringAdditions.h"

@implementation NSString (StringAdditions)

+ (NSString *)formattedStringFromDate:(NSDate *)date {
    return [[HDHelper formatter] stringFromDate:date];
}

+ (NSString *)stringWithFrontOffset:(NSString *)string {
    return [NSString stringWithFormat:@"   %@",string];
}

@end
