//
//  HDVisualDataGridCell.h
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@interface HDVisualDataGridCell : UICollectionViewCell
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) NSUInteger max;
@property (nonatomic, assign) NSUInteger min;
@property (nonatomic, assign) NSUInteger plot;
@property (nonatomic, strong) UIColor *strokeColor;
@end
