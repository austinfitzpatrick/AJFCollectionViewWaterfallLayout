//
//  AJFCollectionVIewWaterfallLayout.h
//  AJFCollectionViewWaterfallLayout
//
//  Created by Austin Fitzpatrick on 7/2/14.
//  Copyright (c) 2014 Austin Fitzpatrick. All rights reserved.
//

/**
 *  Major Inspiration from https://github.com/chiahsien/CHTCollectionViewWaterfallLayout
 */

#import <UIKit/UIKit.h>
#import "AJFCollectionViewWaterfallLayoutDelegate.h"

@interface AJFCollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak, readonly) id<AJFCollectionViewWaterfallLayoutDelegate> delegate;

@end
