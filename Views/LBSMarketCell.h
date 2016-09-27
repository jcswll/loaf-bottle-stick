//
//  LBSMarketCell.h
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/19/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import UIKit;

@interface LBSMarketCell : UICollectionViewCell

@property (weak, nonatomic, nullable) UIView * tableView;
@property (assign, nonatomic, getter=isInOverview) BOOL inOverview;

@end
