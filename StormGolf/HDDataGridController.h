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
@property (nonatomic, assign, getter=isEditable) BOOL editable;
@end

@interface HDCustomCollectionFlowLayout : UICollectionViewFlowLayout
@end

@interface HDDataGridController : UICollectionViewController

- (void)row:(NSUInteger *)row
     column:(NSUInteger *)column
fromIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfRowsInDataGridView;
- (NSInteger)numberOfColumnsInDataGridView;
- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)widthForCellAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataGridDidSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataGridHighlightColumnsInRow:(NSInteger)row;
- (void)dataGridUnHighlightColumnsInRow:(NSInteger)row;
@end
