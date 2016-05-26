//
//  HDItemManagerTableViewCell.h
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

#import "HDDefaultDataGridCell.h"
@interface HDItemManagerTableViewCell : HDDefaultDataGridCell
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *itemCost;
@end
