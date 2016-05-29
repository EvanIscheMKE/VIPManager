//
//  HDDatGridTestController.h
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

extern NSString * const HDDataGridReuseIdentifier;
extern NSString * const HDVisualDataGridReuseIdentifier;
extern NSString * const HDDataGridHeaderIdentifier;
extern NSString * const HDDataGridFooterIdentifier;

static const CGFloat COLLECTIONVIEW_DEFAULT_ROW_HEIGHT = 44.0f;
@interface HDDataGridCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@end

@interface HDCustomCollectionFlowLayout : UICollectionViewFlowLayout
@end

@interface HDDataGridController : UICollectionViewController
@property (nonatomic, strong, readonly) NSArray *columnWidths;
@property (nonatomic, strong, readonly) NSArray *columnTitles;
- (void)reloadData;
- (void)row:(NSUInteger *)row
     column:(NSUInteger *)column
fromIndexPath:(NSIndexPath *)indexPath;
@end
