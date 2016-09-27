//
//  LBSMarketCell.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/19/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSMarketCell.h"
#import "LBSShadowLayoutAttributes.h"
#import "UIView+WSSSimpleConstraints.h"

@interface LBSMarketCell ()

/** Turn layer shadow off or on; this is used during movement in overview mode. */
- (void)setDisplaysShadow:(BOOL)display;
- (void)constructConstraints;

@end

@implementation LBSMarketCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self constructConstraints];
}

- (void)prepareForReuse
{
    [super prepareForReuse]; 
    [self setDisplaysShadow:NO];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttrs
{
    BOOL displayShadow = NO;
    if( [layoutAttrs respondsToSelector:@selector(displayShadow)] ){
        displayShadow = [(LBSShadowLayoutAttributes *)layoutAttrs displayShadow];
    }
    // Shadow value retrieved before passing up just in case super does something stupid with the attributes object
    [super applyLayoutAttributes:layoutAttrs];
    [self setDisplaysShadow:displayShadow];
    [self layoutIfNeeded];
}

- (void)setTableView:(UIView *)tableView
{
    _tableView = tableView;
    
    [[self contentView] addSubview:_tableView];
    [_tableView WSSCenterInSuperviewInDirections:WSSConstraintDirectionAll];
    [_tableView WSSFitToSuperviewInDirections:WSSConstraintDirectionAll];
    [_tableView setUserInteractionEnabled:![self isInOverview]];
    if( [_tableView respondsToSelector:@selector(setShowsVerticalScrollIndicator:)] ){
        [(UITableView *)_tableView setShowsVerticalScrollIndicator:![self isInOverview]];
    }
}

- (void)setDisplaysShadow:(BOOL)doesDisplay
{
    CGFloat opacity = doesDisplay ? 0.5 : 0.0;
    BOOL doesMask = !doesDisplay;
    
    [[self layer] setShadowOpacity:opacity];
    [[self layer] setMasksToBounds:doesMask];
}

- (void)constructConstraints
{
    [[self contentView] WSSCenterInSuperviewInDirections:WSSConstraintDirectionAll];
    [[self contentView] WSSFitToSuperviewInDirections:WSSConstraintDirectionAll];
}

@end
