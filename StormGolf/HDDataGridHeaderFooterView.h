//
//  HDDataGridHeaderFooterView.h
//  StormGolf
//
//  Created by Evan Ische on 5/26/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

extern NSString * const HDDataGridValueKey;
extern NSString * const HDDataGridTextKey;

@interface HDDataGridHeaderFooterView : UITableViewHeaderFooterView
- (void)performLayoutForValues:(NSArray *)values text:(NSArray *)text;
+ (NSDictionary *)transaction;
+ (NSDictionary *)sales;
+ (NSDictionary *)itemManager;
@end
