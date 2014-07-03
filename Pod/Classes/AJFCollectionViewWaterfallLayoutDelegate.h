//
//  AJFCollectionViewWaterfallLayoutDelegate.h
//  AJFCollectionViewWaterfallLayout
//
//  Created by Austin Fitzpatrick on 7/2/14.
//  Copyright (c) 2014 Austin Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AJFCollectionViewWaterfallLayoutDelegate <NSObject, UICollectionViewDelegate>

- (NSInteger) collectionView:(UICollectionView*) collectionView numberOfColumnsInSection:(NSInteger) section;
- (CGSize) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout*) layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout*) collectionViewLayout columnSpacingForSection:(NSInteger) section;
- (NSInteger) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

@end
