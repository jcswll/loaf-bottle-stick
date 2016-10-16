//
//  LBSMarketTableController.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 9/5/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSMarketTableController.h"
#import "LBSMarketItemCell.h"
#import "UIView+WSSSimpleConstraints.h"

static NSString * const kMarketItemCellIdentifier = @"MarketItemCell";
static NSString * const kMarketItemCellNibName = @"LBSMarketItemCell";
static NSString * const kMarketHeaderNibName = @"LBSMarketTableHeader";

@interface LBSMarketTableController ()

@property (weak, nonatomic, nullable) IBOutlet UILabel * headerLabel;
@property (copy, nonatomic, nonnull) NSString * marketName;
@property (strong, nonatomic, nonnull) InventoryPresentation * inventory;

- (void)registerViews;
- (UIView *)constructTableHeaderView;

@end

@implementation LBSMarketTableController
{
    NSArray * _items;
}

- (instancetype)initWithMarketPresentation:(MarketPresentation *)presentation
{
    self = [super init];
    if( !self ) return nil;
    
    [[self tableView] setAllowsSelection:NO];
    _marketName = [presentation name];
    _inventory = [presentation inventoryPresentation];
    
    [self registerViews];
    
    return self;
}

- (void)registerViews
{
    UINib * cellNib = [UINib nibWithNibName:kMarketItemCellNibName
                                     bundle:nil];
    
    [[self tableView] registerNib:cellNib
           forCellReuseIdentifier:kMarketItemCellIdentifier];
       
    UIView * headerView = [self constructTableHeaderView];
    
    [[self tableView] setTableHeaderView:headerView];
    
    [headerView WSSCenterInSuperviewInDirections:WSSConstraintDirectionHorizontal];
    [headerView WSSFitToSuperviewInDirections:WSSConstraintDirectionHorizontal];
    [headerView WSSFitToSuperviewInDirections:WSSConstraintDirectionUp];
    [headerView layoutIfNeeded];
    
    // Force table view to update frame
    [[self tableView] setTableHeaderView:headerView];
}

- (UIView *)constructTableHeaderView
{
    static const CGFloat kHeaderHeight = 88;
    
    UINib * headerNib = [UINib nibWithNibName:kMarketHeaderNibName
                                       bundle:nil];
    NSArray * headerObjects = [headerNib instantiateWithOwner:self 
                                                      options:nil];
    UIView * headerView = headerObjects[0];
    
    [[self headerLabel] setText:[self marketName]];
    [[NSLayoutConstraint constraintWithItem:headerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:kHeaderHeight] setActive:YES];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self inventory] subPresentations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBSMarketItemCell * cell = [tableView dequeueReusableCellWithIdentifier:kMarketItemCellIdentifier
                                                               forIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    MerchPresentation * item = [[self inventory] subPresentations][row];
    NSString * itemName = [item name];
    
    [[cell name] setText:itemName];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

@end
