//
//  AJFCollectionVIewWaterfallLayout.m
//  AJFCollectionViewWaterfallLayout
//
//  Created by Austin Fitzpatrick on 7/2/14.
//  Copyright (c) 2014 Austin Fitzpatrick. All rights reserved.
//

#import "AJFCollectionViewWaterfallLayout.h"

@interface AJFCollectionViewWaterfallLayout ()

@property (nonatomic, strong) NSMutableArray *allItemAttributes;

//array of arrays containing the item attributes for every section
@property (nonatomic, strong) NSMutableArray *itemAttributesBySectionNumber;

//array of arrays containing the total column height for every section
@property (nonatomic, strong) NSMutableArray *columnHeightsBySectionNumber;

//array of maximum column heights
@property (nonatomic, strong) NSMutableArray *maximumColumnHeightsBySectionNumber;

//union rects for calculating which cells to show
@property (nonatomic, strong) NSMutableArray *unionRects;

@end

const NSInteger AJFDefaultWaterfallLayoutColumnSpacing = 10.0f;
const NSInteger AJFUnionCount = 20;

@implementation AJFCollectionViewWaterfallLayout



- (CGSize) collectionViewContentSize{
    CGFloat maximumY = 0;
    for (NSInteger i = 0; i < [self.maximumColumnHeightsBySectionNumber count]; i++){
        maximumY += [self.maximumColumnHeightsBySectionNumber[i] floatValue];
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), maximumY);
}

- (UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= [self.itemAttributesBySectionNumber count]){
        return nil;
    } else if (indexPath.item >= [self.itemAttributesBySectionNumber[indexPath.section] count]){
        return nil;
    } else {
        return self.itemAttributesBySectionNumber[indexPath.section][indexPath.item];
    }
}

- (NSArray*) layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSInteger i;
    NSInteger begin = 0;
    NSInteger end = self.unionRects.count;
    
    NSMutableArray *attrs = [NSMutableArray array];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * AJFUnionCount;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * AJFUnionCount, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    
    return [NSArray arrayWithArray:attrs];
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

- (id<AJFCollectionViewWaterfallLayoutDelegate>) delegate{
    if ([self.collectionView.delegate conformsToProtocol:@protocol(AJFCollectionViewWaterfallLayoutDelegate)]){
        return (id<AJFCollectionViewWaterfallLayoutDelegate>) self.collectionView.delegate;
    } else {
        [NSException raise:@"The collection view's delegate must conform to AJFCollectionViewWaterfallLayoutDelegate" format:@"Set a delegate that conforms to AJFCollectionViewWaterfallLayoutDelegate and implement the required methods."];
    }
    return nil;
}


- (void) prepareLayout{
    [super prepareLayout];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    //clear out the arrays
    [self.itemAttributesBySectionNumber removeAllObjects];
    [self.columnHeightsBySectionNumber removeAllObjects];
    [self.maximumColumnHeightsBySectionNumber removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.unionRects removeAllObjects];
    
    CGFloat previousColumnHeight = 0;
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfColumns = [self.delegate collectionView:self.collectionView numberOfColumnsInSection:section];
        NSAssert(numberOfColumns > 0, @"The number of columns must be greater than 0");
        CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSection:section];
        CGFloat minimumColumnSpacing = AJFDefaultWaterfallLayoutColumnSpacing;
        UIEdgeInsets sectionInset = [self sectionInsetsForSection:section];
        [self.itemAttributesBySectionNumber addObject:[NSMutableArray array]];
        
        [self.columnHeightsBySectionNumber insertObject:[NSMutableArray array] atIndex:section];
        for (NSInteger column = 0; column < numberOfColumns; column++){
            [self.columnHeightsBySectionNumber[section] insertObject:@(0) atIndex:column];
        }
        
        CGFloat sectionWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
        CGFloat cellWidth = floorf((sectionWidth - (numberOfColumns - 1) * minimumColumnSpacing) / numberOfColumns);
        
        //todo: support section header and footer
        
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray array];
        
        for (NSInteger cellId = 0; cellId < numberOfItemsInSection; cellId++){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellId inSection:section];
            //add the cell to the shortest column in this section
            NSInteger columnNumber = [self shortestColumnIndexForSection:section];
            CGFloat xOffset = sectionInset.left + (cellWidth + minimumColumnSpacing) * columnNumber;

            CGFloat yOffset = previousColumnHeight + [self.columnHeightsBySectionNumber[section][columnNumber] floatValue];
            
            CGSize suggestedCellSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            CGFloat cellHeight = (suggestedCellSize.height > 0 && suggestedCellSize.width > 0) ? floorf(suggestedCellSize.height * cellWidth / suggestedCellSize.width) : 0;
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, cellWidth, cellHeight);
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            self.columnHeightsBySectionNumber[section][columnNumber] = @(CGRectGetMaxY(attributes.frame) + minimumInteritemSpacing - previousColumnHeight);
        }
        [self.itemAttributesBySectionNumber[section] addObject:itemAttributes];
        CGFloat maximumColumnHeight = [self maximumColumnHeightForSection:section];
        previousColumnHeight += maximumColumnHeight;
        [self.maximumColumnHeightsBySectionNumber insertObject:@(maximumColumnHeight) atIndex:section];
    }
    
    NSInteger idx = 0;
    NSInteger itemCount = [self.allItemAttributes count];
    while (idx < itemCount) {
        CGRect rect1 = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        idx = MIN(idx + AJFUnionCount, itemCount) - 1;
        CGRect rect2 = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        [self.unionRects addObject:[NSValue valueWithCGRect:CGRectUnion(rect1, rect2)]];
        idx++;
    }
}

#pragma mark - Initializers and Private Methods

- (NSMutableArray*) unionRects{
    if (!_unionRects) _unionRects = [NSMutableArray array];
    return _unionRects;
}

- (NSMutableArray*) allItemAttributes{
    if (!_allItemAttributes) _allItemAttributes = [NSMutableArray array];
    return _allItemAttributes;
}

- (NSMutableArray*) maximumColumnHeightsBySectionNumber{
    if (!_maximumColumnHeightsBySectionNumber) _maximumColumnHeightsBySectionNumber = [NSMutableArray array];
    return _maximumColumnHeightsBySectionNumber;
}

- (NSMutableArray*) itemAttributesBySectionNumber{
    if (!_itemAttributesBySectionNumber) _itemAttributesBySectionNumber = [NSMutableArray array];
    return _itemAttributesBySectionNumber;
}

- (NSMutableArray*) columnHeightsBySectionNumber{
    if (!_columnHeightsBySectionNumber) _columnHeightsBySectionNumber = [NSMutableArray array];
    return _columnHeightsBySectionNumber;
}

#pragma mark - Delegate Helpers

- (CGFloat) maximumColumnHeightForSection:(NSInteger) section{
    NSArray *columnHeights = self.columnHeightsBySectionNumber[section];
    CGFloat maximumColumnHeight = [columnHeights[0] floatValue];
    for (NSInteger i = 1; i< [columnHeights count]; i++){
        if ([columnHeights[i] floatValue] > maximumColumnHeight){
            maximumColumnHeight = [columnHeights[i] floatValue];
        }
    }
    return maximumColumnHeight;
}

- (NSInteger) shortestColumnIndexForSection:(NSInteger) section{
    NSArray *columnHeights = self.columnHeightsBySectionNumber[section];
    NSInteger shortestIndex = 0;
    for (NSInteger i = 1; i < [columnHeights count]; i++){
        if ([columnHeights[i] intValue] < [columnHeights[shortestIndex] intValue]){
            shortestIndex = i;
        }
    }
    return shortestIndex;
}

- (CGFloat) minimumInteritemSpacingForSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return AJFDefaultWaterfallLayoutColumnSpacing;
    }
}

- (UIEdgeInsets) sectionInsetsForSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else{
        return UIEdgeInsetsZero;
    }
}

@end
