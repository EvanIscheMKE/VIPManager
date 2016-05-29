//
//  HDTransactionObject.m
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionObject.h"
#import "HDHelper.h"

@implementation HDTransactionObject

- (NSArray *)dataWithStartingBalance:(CGFloat)startingBalance {
    return @[self.username,
             [HDHelper stringFromNumber:startingBalance],
             [HDHelper stringFromNumber:startingBalance + self.cost],
             [HDHelper stringFromNumber:fabs(self.cost)],
             self.admin,
             [[HDHelper formatter] stringFromDate:self.date],
             self.title];
}

@end
