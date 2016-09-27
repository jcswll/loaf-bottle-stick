//
//  LBSFullscreenLayout.h
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/23/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import UIKit;

@interface LBSFullscreenLayout : UICollectionViewFlowLayout

+ (nullable instancetype)layoutWithSize:(CGSize)layoutSize;

@property (strong, nonatomic, nonnull) NSIndexPath * pageIndexPath;

/** Set the page index after the collection view's content offset changes, such as when scrolled. */
- (void)updatePageIndex;

@end
