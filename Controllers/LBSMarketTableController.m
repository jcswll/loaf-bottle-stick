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
#import "LoafBottleStick-Swift.h"

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
    [InventoryPresentation registerCellsForTableView:[self tableView]];
       
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
    NSUInteger row = [indexPath row];
    MerchPresentation * presentation = [[self inventory] subPresentations][row];
    
    return [presentation configureCellInTableView:tableView atIndexPath:indexPath];
}

@end
