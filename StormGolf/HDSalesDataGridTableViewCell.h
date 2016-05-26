//
//  HDSalesDataGridTableViewCell.h
//  StormGolf
//
//  Created by Evan Ische on 5/23/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

#import "HDDefaultDataGridCell.h"

@class HDDataVisualizationView;
@interface HDSalesDataGridTableViewCell : HDDefaultDataGridCell
@property (nonatomic, strong) HDDataVisualizationView *dataView;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *amountSold;
@property (nonatomic, copy) NSString *totalSold;
@end
