//
//  AJFViewController.h
//  AJFCollectionViewWaterfallLayout
//
//  Created by Austin Fitzpatrick on 7/2/14.
//  Copyright (c) 2014 Austin Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJFCollectionViewWaterfallLayoutDelegate.h"

@interface AJFViewController : UICollectionViewController <UICollectionViewDataSource, AJFCollectionViewWaterfallLayoutDelegate>

@end
