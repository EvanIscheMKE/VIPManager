//
//  HDCashierViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCashier : NSObject
@property (nonatomic, assign) BOOL current;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *image;
@end

@interface HDCashierManager : NSObject
@property (nonatomic, strong, readonly) HDCashier *currentCashier;
- (NSUInteger)count;
- (void)addCashier:(HDCashier *)cashier;
- (void)removeCashier:(HDCashier *)cashier;
- (void)removeCashierAtIndex:(NSInteger)index;
- (HDCashier *)cashierAtIndex:(NSInteger)index;
- (void)updateCurrentCashier:(HDCashier *)cashier;
- (void)saveChanges;
+ (HDCashierManager *)sharedManager;
@end

@interface HDCashierCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@interface HDCashierPopoverViewController : UICollectionViewController
@end
