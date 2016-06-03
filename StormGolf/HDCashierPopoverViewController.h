//
//  HDCashierViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCashier : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *image;
@end

@interface HDCashierManager : NSObject
- (NSUInteger)count;
- (void)addCashier:(HDCashier *)cashier;
- (void)removeCashier:(HDCashier *)cashier;
- (void)removeCashierAtIndex:(NSInteger)index;
- (HDCashier *)cashierAtIndex:(NSInteger)index;
- (void)saveChanges;
+ (HDCashierManager *)sharedManager;
@end

@interface HDCashierPopoverViewController : UITableViewController
@end
