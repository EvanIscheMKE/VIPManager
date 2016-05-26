//
//  HDDefaultDataGridCell.h
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@interface HDDefaultDataGridCell : UITableViewCell
@property (nonatomic, copy) NSArray *values;
- (void)layoutLabels;
@end
