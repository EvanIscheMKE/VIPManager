//
//  HDTransactionManager.m
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManager.h"
#import "HDTransactionObject.h"
#import "HDTransactionManager.h"

@interface HDTransactionManager ()
@property (nonatomic, assign, readonly) NSUInteger maxCountFromCurrentQuery;
@end

@implementation HDTransactionManager {
    NSArray *_currentQueryResults;
    NSMutableDictionary *_cache;
}

+ (HDTransactionManager *)sharedManager {
    static HDTransactionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HDTransactionManager new];
    });
    return manager;
}

- (NSUInteger)updateCurrentTransactionQueryResults:(NSArray *)results {
    _currentQueryResults = results;
    _cache = [NSMutableDictionary dictionary];
    return [self maxCountFromCurrentQuery];
}

- (NSUInteger)maxCountFromCurrentQuery {
    
    __block NSUInteger currentMax = 0;
    for (NSUInteger i = 0; i < [HDItemManager sharedManager].count; i++) {
        __block HDItem *item = [[HDItemManager sharedManager] itemAtIndex:i];
        [self infoForItemWithDescription:item.itemDescription completion:^(NSUInteger count, double total) {
            if (item.itemDescription) {
                [_cache setObject:@[@(count), @(total)] forKey:item.itemDescription];
            }
            
            if (count > currentMax) {
                currentMax = count;
            }
        }];
    }
    return currentMax;
}

- (void)infoForItemWithDescription:(NSString *)description
                        completion:(HDSalesCompletionBlock)completionBlock {
    
    if (_cache[description]) {
        if (completionBlock) {
            completionBlock([[_cache[description] firstObject] unsignedIntegerValue], [[_cache[description] lastObject] unsignedIntegerValue]);
        }
    }

    NSUInteger count = 0;
    double total = 0.0f;
    for (HDTransactionObject *transaction in _currentQueryResults) {
        if ([transaction.title isEqualToString:description]) {
            count++;
            total += fabs(transaction.cost);
        }
    }
    if (completionBlock) {
        completionBlock(count, total);
    }
}

@end
