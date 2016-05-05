//
//  HDItemManager.h
//  StormGolf
//
//  Created by Evan Ische on 4/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

@interface HDItem : NSObject <NSCoding>
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, assign) NSUInteger itemCost;
@end

@interface HDItemManager : NSObject
- (NSUInteger)count;
- (void)addItem:(HDItem *)item;
- (void)removeItem:(HDItem *)item;
- (HDItem *)itemAtIndex:(NSInteger)index;
- (void)saveChanges;
+ (HDItemManager *)sharedManager;
@end
