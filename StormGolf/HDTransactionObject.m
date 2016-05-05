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
    return [NSString stringWithFormat:@"TRANSACTIONID:%zd, USERID:%zd, COST:%f, TIMESTAMP:%@, USERNAME:%@, DESCRIPTION:%@ ",self.transactionID,
            self.userID,
            self.transactionPrice,
            self.transactionDate,
            self.username,
            self.transactionDescription];
}

@end
