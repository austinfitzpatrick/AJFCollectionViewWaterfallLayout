//
//  AJFViewController.m
//  AJFCollectionViewWaterfallLayout
//
//  Created by Austin Fitzpatrick on 7/2/14.
//  Copyright (c) 2014 Austin Fitzpatrick. All rights reserved.
//

#import "AJFViewController.h"
#define ARC4RANDOM_MAX      0x100000000

@interface AJFViewController ()

@end

@implementation AJFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark UICollectionViewDatasource

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor colorWithRed:((double)arc4random() / ARC4RANDOM_MAX) green:((double)arc4random() / ARC4RANDOM_MAX) blue:((double)arc4random() / ARC4RANDOM_MAX) alpha:1.0f];
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (1 + section) * 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfColumnsInSection:(NSInteger)section{
    return section + 1;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1000, arc4random() % 1000 + 300);
}

@end
