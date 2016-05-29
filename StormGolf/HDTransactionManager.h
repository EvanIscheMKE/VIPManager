//
//  HDTransactionManager.h
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

typedef void (^HDSalesCompletionBlock)(NSUInteger count, double total);
@interface HDTransactionManager : NSObject
+ (HDTransactionManager *)sharedManager;
- (NSUInteger)updateCurrentTransactionQueryResults:(NSArray *)results;
- (void)infoForItem:(NSString *)itemDescription
         completion:(HDSalesCompletionBlock)completionBlock;
@end
