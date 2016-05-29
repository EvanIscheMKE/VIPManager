//
//  HDDatGridTestController.m
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDDataGridController.h"
#import "NSString+StringAdditions.h"
#import "HDDataGridTestHeader.h"
#import "UIFont+FontAdditions.h"
#import "UIColor+ColorAdditions.h"
#import "HDVisualDataGridCell.h"

@implementation HDDataGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont stormGolfFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor whiteColor];
    if (self.textLabel) {
        self.textLabel.text = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

@end

@implementation HDCustomCollectionFlowLayout



- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 1.0f;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

#if 0

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *results = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView *collectionView = self.collectionView;
    const CGPoint contentOffset = collectionView.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [results addObject:layoutAttributes];
        
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            BOOL cellsExist = numberOfItemsInSection > 0;
            UICollectionViewLayoutAttributes *firstObjectAttrs, *lastObjectAttrs;
            
            if (cellsExist) {
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            } else {
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                       atIndexPath:lastObjectIndexPath];
            }
            
            CGFloat topHeaderHeight = (cellsExist) ? CGRectGetHeight(layoutAttributes.frame) : 0.0f;
            CGFloat bottomHeaderHeight = CGRectGetHeight(layoutAttributes.frame);
            CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, collectionView.contentInset);
            
            CGPoint origin = frameWithEdgeInsets.origin;
            
            origin.y = MIN( MAX( contentOffset.y + collectionView.contentInset.top,
                                CGRectGetMinY(firstObjectAttrs.frame) - topHeaderHeight ),
                           CGRectGetMaxY(lastObjectAttrs.frame) - bottomHeaderHeight );
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){ .origin = origin, .size = layoutAttributes.frame.size };
        }
    }
    
    return results;
    
}

#endif


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end

NSString * const HDDataGridReuseIdentifier = @"HDTransactionTableViewReuseIdentifier";
NSString * const HDVisualDataGridReuseIdentifier = @"HDSalesTableViewReuseIdentifier";
NSString * const HDDataGridHeaderIdentifier = @"HDDataGridHeaderIdentifier";
NSString * const HDDataGridFooterIdentifier = @"HDDataGridFooterIdentifier";
@implementation HDDataGridController {
    CGFloat _spacing;
    NSMutableArray *_finalColumnSections;
}

- (instancetype)init {
    HDCustomCollectionFlowLayout *layout = [HDCustomCollectionFlowLayout new];
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    if (self = [super initWithCollectionViewLayout:layout]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[HDDataGridTestHeader class]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:HDDataGridHeaderIdentifier];
    [self.collectionView registerClass:[HDDataGridCell class] forCellWithReuseIdentifier:HDDataGridReuseIdentifier];
    [self.collectionView registerClass:[HDVisualDataGridCell class] forCellWithReuseIdentifier:HDVisualDataGridReuseIdentifier];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.item / self.columnWidths.count;
    NSUInteger column = indexPath.item % self.columnWidths.count;
    NSLog(@"ROW:%lu COLUMN:%lu", row, column);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_finalColumnSections) {
        
        _finalColumnSections = [NSMutableArray new];
        
        NSUInteger index = 0;
        CGFloat totalHeight = 0;
        for (NSNumber *number in self.columnWidths) {
            CGFloat reduceBy = (index == 0 || index == self.columnWidths.count - 1) ? .5f : 1.0;
            if (index == self.columnWidths.count - 1) {
                [_finalColumnSections addObject:@(CGRectGetWidth(self.view.bounds) - totalHeight)];
            } else {
                totalHeight += [number doubleValue];
                [_finalColumnSections addObject:@([number doubleValue] - reduceBy)];
            }
        }
    }
    return CGSizeMake([_finalColumnSections[indexPath.item % self.columnWidths.count] floatValue] - .5f, COLLECTIONVIEW_DEFAULT_ROW_HEIGHT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    HDDataGridTestHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                      withReuseIdentifier:HDDataGridHeaderIdentifier
                                                                             forIndexPath:indexPath];
    [header layoutColumnWidths:self.columnWidths columnTitles:self.columnTitles];
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), COLLECTIONVIEW_DEFAULT_ROW_HEIGHT);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)reloadData {
    _finalColumnSections = nil;
    [self.collectionView reloadData];
}

- (void)row:(NSUInteger *)row column:(NSUInteger *)column fromIndexPath:(NSIndexPath *)indexPath {
    *row = indexPath.item / self.columnWidths.count;
    *column = indexPath.item % self.columnWidths.count;
}

- (NSArray *)columnWidths {
    return nil;
}

- (NSArray *)columnTitles {
    return nil;
}

@end
