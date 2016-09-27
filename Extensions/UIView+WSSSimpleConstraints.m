//
//  UIView+WSSSimpleConstraints.m
//
//  Created by Joshua Caswell on 10/14/15.
//  Copyright © 2015 Josh Caswell. All rights reserved.
//

#import "UIView+WSSSimpleConstraints.h"

@implementation UIView (WSSSimpleConstraints)

- (void)WSSFitToSuperviewInDirections:(WSSConstraintDirection)directions
{
    [self WSSSpaceAtDistance:0.0 fromSuperviewInDirections:directions];
}

static const CGFloat kWSSStandardSpace = -CGFLOAT_MAX;

- (void)WSSSpaceAtStandardDistanceFromSuperviewInDirections:(WSSConstraintDirection)directions
{
    [self WSSSpaceAtDistance:kWSSStandardSpace fromSuperviewInDirections:directions];
}

- (void)WSSSpaceAtDistance:(CGFloat)space fromSuperviewInDirections:(WSSConstraintDirection)directions
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSString * horizFormat = nil;
    NSString * vertFormat = nil;
    NSString * spaceFormat = nil;
    
    if( space == 0 ){
        spaceFormat = @"";
    }
    else if( space == kWSSStandardSpace ){
        spaceFormat = @"-";
    }
    else {
        spaceFormat = [NSString stringWithFormat:@"-(%f)-", space];
    }
    
    if( directions & WSSConstraintDirectionHorizontal ){
        
        NSString * leftEdge = @"";
        if( directions & WSSConstraintDirectionLeft ){
            leftEdge = [NSString stringWithFormat:@"|%@", spaceFormat];
        }
        
        NSString * rightEdge = @"";
        if( directions & WSSConstraintDirectionRight ){
            rightEdge = [NSString stringWithFormat:@"%@|", spaceFormat];
        }
        
        horizFormat = [NSString stringWithFormat:@"H:%@[view]%@", leftEdge, rightEdge];
    }
    
    if( directions & WSSConstraintDirectionVertical ){
        
        NSString * topEdge = @"";
        if( directions & WSSConstraintDirectionUp ){
            topEdge = [NSString stringWithFormat:@"|%@", spaceFormat];
        };
        
        NSString * bottomEdge = @"";
        if( directions & WSSConstraintDirectionDown ){
            bottomEdge = [NSString stringWithFormat:@"%@|", spaceFormat];
        }
        
        vertFormat = [NSString stringWithFormat:@"V:%@[view]%@", topEdge, bottomEdge];
    }
    
    if( horizFormat ){
        [NSLayoutConstraint activateConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:horizFormat
                                                 options:NSLayoutFormatAlignAllCenterX
                                                 metrics:nil
                                                   views:@{@"view" : self}]];
    }
    
    if( vertFormat ){
        [NSLayoutConstraint activateConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:vertFormat
                                                 options:NSLayoutFormatAlignAllCenterY
                                                 metrics:nil
                                                   views:@{@"view" : self}]];
    }
}

- (void)WSSCenterInSuperviewInDirections:(WSSConstraintDirection)directions
{
    NSAssert(directions == WSSConstraintDirectionHorizontal ||
             directions == WSSConstraintDirectionVertical ||
             directions == WSSConstraintDirectionAll,
             @"Direction for centering must be one or both of WSSConstraintDirectionHorizontal and "
              "WSSConstraintDirectionVertical.");

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if( directions & WSSConstraintDirectionHorizontal ){
        
        [[NSLayoutConstraint constraintWithItem:self
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:[self superview]
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                       constant:0.0]
         setActive:YES];
    }
    
    if( directions & WSSConstraintDirectionVertical ){
        
        [[NSLayoutConstraint constraintWithItem:self
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:[self superview]
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                       constant:0.0]
         setActive:YES];
    }
}

@end
