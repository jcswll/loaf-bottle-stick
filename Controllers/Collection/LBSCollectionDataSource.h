//
//  LBSCollectionDataSource.h
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/24/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import UIKit;

@interface LBSCollectionDataSource : NSObject <UICollectionViewDataSource>

+ (instancetype)dataSourceForView:(UICollectionView *)collectionView;

@property (assign, nonatomic, getter=isInOverview) BOOL inOverview;

/** The new location of the given index path after items have been rearranged. */
- (NSIndexPath *)pathAfterMovementForIndexPath:(NSIndexPath *)path;

@end
