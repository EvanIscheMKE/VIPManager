//
//  HDHelper.h
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

typedef void (^ResultsBlock)(float currentBalance);

@interface HDHelper : NSObject
+ (void)currentUserBalanceWithUserID:(NSUInteger)userID
                             results:(ResultsBlock)resultsBlock;
+ (void)currentUser:(NSUInteger)userID
balanceForTransactionID:(NSUInteger)transactionID
            results:(ResultsBlock)resultsBlock;
+ (NSArray *)userObjectsFromArray:(NSArray *)rawUserData
                  withColumnNames:(NSArray *)columns;
+ (NSArray *)transactionObjectsFromArray:(NSArray *)rawTransactionData
                         withColumnNames:(NSArray *)columns;
+ (NSDateFormatter *)formatter;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromNumber:(double)number;
@end
