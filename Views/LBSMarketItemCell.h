//
//  LBSMarketItemCell.h
//  LoafBottleStick
//
//  Created by Joshua Caswell on 9/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

@import UIKit;
@import LoafBottleStickKit;

@interface LBSMarketItemCell : UITableViewCell

@property (weak, nonatomic, nullable) id<MarketItemPresentation> presentation;
@property (copy, nonatomic, nullable) NSString * itemName;

@end
