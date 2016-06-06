//
//  HDDatGridTestController.m
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDHelper.h"
#import "HDDataGridController.h"
#import "NSString+StringAdditions.h"
#import "HDDataGridHeader.h"
#import "UIFont+FontAdditions.h"
#import "UIColor+ColorAdditions.h"
#import "HDVisualDataGridCell.h"

@interface HDDataGridCell ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation HDDataGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.editable = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        NSDateFormatter *formatter = [HDHelper formatter];
        formatter.dateStyle = NSDateFormatterLongStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
        
        /**/
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont stormGolfFontOfSize:14.0f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    if (_editable) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPress:)];
        [self.contentView addGestureRecognizer:self.longPressGestureRecognizer];
    } else {
        if (self.longPressGestureRecognizer) {
            [self.contentView removeGestureRecognizer:self.longPressGestureRecognizer];
            self.longPressGestureRecognizer = nil;
        }
    }
}

- (IBAction)_longPress:(id)sender {
    self.textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
    self.textField.backgroundColor = [UIColor yellowColor];
    self.textField.font = self.textField.font;
    self.textField.textColor = self.textLabel.textColor;
    self.textLabel.text = self.textLabel.text;
    [self.contentView addSubview:self.textField];
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
    self.textLabel.frame = self.contentView.bounds;
    self.textField.frame = self.contentView.bounds;
}

@end

@implementation HDCustomCollectionFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    UICollectionView *collectionView = self.collectionView;
    const CGPoint contentOffset = collectionView.contentOffset;
    
    NSMutableArray *results = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableArray *copiedResults = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        [copiedResults addObject:[layoutAttributes copy]];
    }
    results = copiedResults;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [results addObject:layoutAttributes];
        
    }];
    
    NSUInteger index = 1;
    for (UICollectionViewLayoutAttributes *layoutAttributes in results) {
        
        if (layoutAttributes.representedElementKind == nil) {
            UICollectionViewLayoutAttributes *currentLayoutAttributes = results[index];
            UICollectionViewLayoutAttributes *prevLayoutAttributes = layoutAttributes;
            NSInteger maximumSpacing = 1.0f;
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            
            if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            BOOL cellsExist = numberOfItemsInSection > 0;
            UICollectionViewLayoutAttributes *firstObjectAttributes, *lastObjectAttributes;
            if (cellsExist) {
                firstObjectAttributes = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttributes = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            } else {
                firstObjectAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             atIndexPath:firstObjectIndexPath];
                lastObjectAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            atIndexPath:lastObjectIndexPath];
            }
            
            CGFloat topHeaderHeight = (cellsExist) ? CGRectGetHeight(layoutAttributes.frame) : 0.0f;
            CGFloat bottomHeaderHeight = CGRectGetHeight(layoutAttributes.frame);
            CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, collectionView.contentInset);
            
            CGPoint origin = frameWithEdgeInsets.origin;
            
            origin.y = MIN( MAX( contentOffset.y + collectionView.contentInset.top,
                                CGRectGetMinY(firstObjectAttributes.frame) - topHeaderHeight ),
                           CGRectGetMaxY(lastObjectAttributes.frame) - bottomHeaderHeight );
            
            CGRect attributeFrame = CGRectZero;
            attributeFrame.origin = origin;
            attributeFrame.size = layoutAttributes.frame.size;
            layoutAttributes.frame = attributeFrame;
            
        }
        index++;
    }
    
    return results;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end

NSString * const HDDataGridReuseIdentifier = @"HDTransactionTableViewReuseIdentifier";
NSString * const HDVisualDataGridReuseIdentifier = @"HDSalesTableViewReuseIdentifier";
NSString * const HDDataGridHeaderIdentifier = @"HDDataGridHeaderIdentifier";
NSString * const HDDataGridFooterIdentifier = @"HDDataGridFooterIdentifier";
@implementation HDDataGridController

- (instancetype)init {
    HDCustomCollectionFlowLayout *layout = [HDCustomCollectionFlowLayout new];
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), COLLECTIONVIEW_DEFAULT_ROW_HEIGHT);
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    if (self = [super initWithCollectionViewLayout:layout]) { } return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.navigationController.toolbar.bounds) + 8.0f, 0.0f);
     self.collectionView.backgroundColor = [UIColor flatDataGridSeperatorColor];
    [self.collectionView registerClass:[HDDataGridHeader class]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:HDDataGridHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:HDDataGridFooterIdentifier];
    [self.collectionView registerClass:[HDDataGridCell class] forCellWithReuseIdentifier:HDDataGridReuseIdentifier];
    [self.collectionView registerClass:[HDVisualDataGridCell class] forCellWithReuseIdentifier:HDVisualDataGridReuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfRowsInDataGridView * self.numberOfColumnsInDataGridView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthForCellAtIndexPath:indexPath], [self heightForCellAtIndexPath:indexPath]);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reuseableView = nil;
    
    if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                              withReuseIdentifier:HDDataGridFooterIdentifier
                                                                                     forIndexPath:indexPath];
        footer.backgroundColor = [UIColor flatDataGridSeperatorColor];
        CGRect bounds = CGRectMake(0.0, 1.0f, CGRectGetWidth(footer.bounds), CGRectGetHeight(footer.bounds) - 1.0f);
        UIView *container = [[UIView alloc] initWithFrame:bounds];
        container.backgroundColor = [UIColor whiteColor];
        [footer addSubview:container];
        
        reuseableView = footer;
    }
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        HDDataGridHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                      withReuseIdentifier:HDDataGridHeaderIdentifier
                                                                             forIndexPath:indexPath];
        NSMutableArray *columnWidths = [NSMutableArray new];
        NSMutableArray *columnTitles = [NSMutableArray new];
        for (NSUInteger i = 0; i < self.numberOfColumnsInDataGridView; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [columnWidths addObject:@([self widthForCellAtIndexPath:indexPath])];
            [columnTitles addObject:[self titleForHeaderAtIndexPath:indexPath]];
        }
        
        [header layoutColumnWidths:columnWidths columnTitles:columnTitles];
        
        reuseableView = header;
    }
    
    return reuseableView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    const CGFloat screenHeight = CGRectGetHeight(self.collectionView.bounds);
    const CGFloat headerHeight = [self heightForCellAtIndexPath:indexPath];
    const CGFloat cellsHeight  = [self heightForCellAtIndexPath:indexPath] * self.numberOfRowsInDataGridView;
    const CGFloat spaceHeight  = (self.numberOfRowsInDataGridView - 1) * 1.0f;
    
    const CGFloat footerHeight = MAX(screenHeight - headerHeight - cellsHeight - spaceHeight, 0.0f);
    return CGSizeMake(CGRectGetWidth(self.view.bounds), footerHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dataGridDidSelectCellAtIndexPath:indexPath];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0.0f) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)row:(NSUInteger *)row column:(NSUInteger *)column fromIndexPath:(NSIndexPath *)indexPath {
    *row = indexPath.item / self.numberOfColumnsInDataGridView;
    *column = indexPath.item % self.numberOfColumnsInDataGridView;
}

#pragma mark - Override in Subclass

- (void)dataGridDidSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfRowsInDataGridView {
    NSAssert(NO, @"'%@' Must be overridden in subclass",NSStringFromSelector(_cmd));
    return 0;
}

- (NSInteger)numberOfColumnsInDataGridView {
    NSAssert(NO, @"'%@' Must be overridden in subclass",NSStringFromSelector(_cmd));
    return 0;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"'%@' Must be overridden in subclass",NSStringFromSelector(_cmd));
    return 0;
}

- (CGFloat)widthForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"'%@' Must be overridden in subclass",NSStringFromSelector(_cmd));
    return 0;
}

- (NSString *)titleForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"'%@' Must be overridden in subclass",NSStringFromSelector(_cmd));
    return nil;
}

- (void)dataGridHighlightColumnsInRow:(NSInteger)row {
    
    NSInteger startingIndex = row * self.numberOfColumnsInDataGridView;

    for (NSUInteger i = startingIndex; i < startingIndex + self.numberOfColumnsInDataGridView; i++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.backgroundColor = [UIColor flatSTLightBlueColor];
    }
}

- (void)dataGridUnHighlightColumnsInRow:(NSInteger)row {
    
    NSInteger startingIndex = row * self.numberOfColumnsInDataGridView;
    
    for (NSUInteger i = startingIndex; i < startingIndex + self.numberOfColumnsInDataGridView; i++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.backgroundColor = (row % 2 == 0) ? [UIColor flatDataGridCellColor]  : [UIColor whiteColor];
    }
}

@end
