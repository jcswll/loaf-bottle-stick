//
//  LBSMarketItemCell.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 9/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSMarketItemCell.h"

@interface LBSMarketItemCell ()

@property (weak, nonatomic, nullable) IBOutlet UITextField * nameField;

@end

@implementation LBSMarketItemCell

- (void)setPresentation:(id<MarketItemPresentation>)presentation
{
    [[self nameField] setDelegate:presentation];
}

- (void)setItemName:(NSString *)itemName
{
    [[self nameField] setText:itemName];
}

- (NSString *)itemName
{
    return [[self nameField] text];
}

@end
