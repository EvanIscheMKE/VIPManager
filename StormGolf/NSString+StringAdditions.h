//
//  NSString+StringAdditions.h
//  StormGolf
//
//  Created by Evan Ische on 5/20/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

@interface NSString (StringAdditions)
+ (NSString *)formattedStringFromDate:(NSDate *)date;
+ (NSString *)stringWithFrontOffset:(NSString *)string;
@end
