//
//  HDHelper.h
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDHelper : NSObject
+ (float)currentUserBalanceWithUserID:(NSUInteger)userID;
+ (float)currentUser:(NSUInteger)userID balanceForTransactionID:(NSUInteger)transactionID;
+ (NSArray *)userObjectsFromArray:(NSArray *)rawUserData
                  withColumnNames:(NSArray *)columns;
+ (NSArray *)transactionObjectsFromArray:(NSArray *)rawTransactionData
                         withColumnNames:(NSArray *)columns;
+ (NSDateFormatter *)formatter;
@end