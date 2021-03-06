//
//  HDItemManager.m
//  StormGolf
//
//  Created by Evan Ische on 4/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManager.h"
#import "HDHelper.h"

NSString * const HDItemUserDefaultsKey = @"HDItemUserDefaultsKey";
NSString * const HDDescriptionKey = @"description";
NSString * const HDCostKey = @"cost";

@implementation HDItem

- (instancetype)initWithDescription:(NSString *)description cost:(double)cost {
    if (self = [super init]) {
        self.itemDescription = description;
        self.itemCost = cost;
    }
    return self;
}

#pragma mark - Decoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
       self.itemCost = [aDecoder decodeDoubleForKey:HDCostKey];
       self.itemDescription = [aDecoder decodeObjectForKey:HDDescriptionKey];
    }
    return self;
}

#pragma mark - Encoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemDescription forKey:HDDescriptionKey];
    [aCoder encodeDouble:self.itemCost forKey:HDCostKey];
}

- (NSArray *)data {
    return @[self.itemDescription, [HDHelper stringFromNumber:fabs(self.itemCost)]];
}

@end

@interface HDItemManager ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation HDItemManager

+ (HDItemManager *)sharedManager {
    static HDItemManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [HDItemManager new];
    });
    return sharedManager;
}

#pragma mark - Public

- (void)addItem:(HDItem *)item {
    [self.items addObject:item];
    [self _save];
}

- (void)removeItem:(HDItem *)item {
    [self.items removeObjectIdenticalTo:item];
    [self _save];
}

- (HDItem *)itemAtIndex:(NSInteger)index {
    return self.items[index];
}

- (void)saveChanges {
    [self _save];
}

- (NSMutableArray *)items {
    
    if (_items) {
        return _items;
    }
    
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *itemsAsData = [[NSUserDefaults standardUserDefaults] objectForKey:HDItemUserDefaultsKey];
    for (NSData *itemData in itemsAsData) {
        [items addObject:[NSKeyedUnarchiver unarchiveObjectWithData:itemData]];
    }
    
    if (items.count) {
        _items = items;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"plist"];
        NSArray *itemsAsDictionary = [[NSArray alloc] initWithContentsOfFile:path];
        for (NSDictionary *itemDictionary in itemsAsDictionary) {
            HDItem *item = [[HDItem alloc] initWithDescription:itemDictionary[HDDescriptionKey] cost:[itemDictionary[HDCostKey] doubleValue]];
            [items addObject:item];
        }
        [self _save:items];
        _items = items;
    }
    return _items;
}

- (CGFloat)currentVIPCardPrice {
    CGFloat price = 0.0f;
    for (HDItem *item in self.items) {
        if ([item.itemDescription isEqualToString:@"VIP Card"]) {
            price = item.itemCost;
            break;
        }
    }
    return price;
}

- (void)removeItemAtIndex:(NSInteger)index {
    [self.items removeObjectAtIndex:index];
    [self _save];
}

- (NSUInteger)count {
    return self.items.count;
}

#pragma mark - Private

- (void)_save {
    [self _save:nil];
}

- (void)_save:(NSMutableArray *)items {
    NSMutableArray *saveTheseItems = [NSMutableArray new];
    for (HDItem *item in (items == nil) ? self.items : items) {
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [saveTheseItems addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveTheseItems forKey:HDItemUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
