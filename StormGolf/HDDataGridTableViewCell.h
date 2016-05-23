//
//  HDDataGridTableViewCell.h
//  StormGolf
//
//  Created by Evan Ische on 5/5/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDDataGridTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *startingBalance;
@property (nonatomic, copy) NSString *endingBalance;
@property (nonatomic, copy) NSString *itemCost;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *transactionDate;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *cashierName;
@end
