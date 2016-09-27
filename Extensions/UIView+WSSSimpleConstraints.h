//
//  UIView+WSSSimpleConstraints.h
//
//  Created by Joshua Caswell on 10/14/15.
//  Copyright © 2015 Josh Caswell. All rights reserved.
//

@import UIKit;

typedef NS_OPTIONS(NSUInteger, WSSConstraintDirection)
{
    WSSConstraintDirectionLeft = 1 << 0,
    WSSConstraintDirectionUp = 1 << 1,
    WSSConstraintDirectionRight = 1 << 2,
    WSSConstraintDirectionDown = 1 << 3,
    
    WSSConstraintDirectionHorizontal = (1 << 0) | (1 << 2),
    WSSConstraintDirectionVertical = (1 << 1) | (1 << 3),
    
    WSSConstraintDirectionAll = 0x0F,
};

@interface UIView (WSSSimpleConstraints)

/** The receiver and its superview are constrained to have their edges equal in the given directions. */
- (void)WSSFitToSuperviewInDirections:(WSSConstraintDirection)directions;

/** The receiver is constrained inset from its superview by the standard distance ("-" in the Auto Layout VFL). */
- (void)WSSSpaceAtStandardDistanceFromSuperviewInDirections:(WSSConstraintDirection)directions;

/** The receiver is constrained inset from its superview by the given amount in all of the given directions. */
- (void)WSSSpaceAtDistance:(CGFloat)space
 fromSuperviewInDirections:(WSSConstraintDirection)directions;

/**
 * This view and its superview are constrained to have center positions equal in the given directions.
 *
 * `directions` must be one or both of `WSSConstraintDirectionHorizontal` and `WSSConstraintDirectionVertical`.
 */
- (void)WSSCenterInSuperviewInDirections:(WSSConstraintDirection)directions;

@end
