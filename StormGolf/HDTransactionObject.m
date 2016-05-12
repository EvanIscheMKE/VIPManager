//
//  HDTransactionObject.m
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDTransactionObject.h"

@implementation HDTransactionObject

- (NSString *)description {
    return [NSString stringWithFormat:@"TRANSACTIONID:%zd, USERID:%zd, COST:%f, TIMESTAMP:%@, USERNAME:%@, DESCRIPTION:%@ ",self.iD,
            self.userID,
            self.cost,
            self.date,
            self.username,
            self.title];
}

- (BOOL)addition {
    return [self.title isEqualToString:@"VIP Card"] || [self.title isEqualToString:@"Created Account"];
}

@end
