//
//  LBSCollectionViewController.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/24/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSCollectionViewController.h"
#import "LBSFullscreenLayout.h"
#import "LBSOverviewLayout.h"
#import "LBSCollectionDataSource.h"
#import "UIView+WSSSimpleConstraints.h"

@interface LBSCollectionViewController () <UICollectionViewDelegate>

@property (strong, nonatomic, nullable) UILongPressGestureRecognizer * itemMovementRecognizer;
@property (strong, nonatomic, nullable) LBSFullscreenLayout * fullscreenLayout;
@property (strong, nonatomic, nullable) LBSOverviewLayout * overviewLayout;
@property (strong, nonatomic, nullable) LBSCollectionDataSource * dataSource;
@property (strong, nonatomic, nullable) UICollectionView * collectionView;
@property (assign, nonatomic, getter=isInOverview) BOOL inOverview;

/** Flip between fullscreen and overview layouts, generally in response to button tap. */
- (IBAction)toggleLayout;
/** Action method for itemMovementRecognizer. */
- (void)itemMovementStateChanged:(UILongPressGestureRecognizer *)recognizer;
/** Coordinate the fullscreen layout's page index with the data source's updated ordering after items are moved. */
- (void)updatePageIndexAfterMove;

@end

@implementation LBSCollectionViewController

+ (id)controllerUsingFrame:(CGRect)frame
{
    LBSFullscreenLayout * fullscreenLayout = [LBSFullscreenLayout layoutWithSize:frame.size];
    LBSOverviewLayout * overviewLayout = [LBSOverviewLayout layoutWithSize:frame.size];

    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                           collectionViewLayout:fullscreenLayout];

    LBSCollectionDataSource * dataSource = [LBSCollectionDataSource dataSourceForView:collectionView];

    LBSCollectionViewController * controller = [self new];

    [controller setCollectionView:collectionView];
    [[controller itemMovementRecognizer] setEnabled:NO];
    [controller setInOverview:NO];
    [dataSource setInOverview:NO];
    [controller setFullscreenLayout:fullscreenLayout];
    [controller setOverviewLayout:overviewLayout];
    [controller setDataSource:dataSource];

    [collectionView setBackgroundColor:[UIColor greenColor]];
    [collectionView setDataSource:dataSource];
    [collectionView setDelegate:controller];

    return controller;
}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;

    [[self view] addSubview:collectionView];
    // Keep collection view behind "switch" button
    [[self view] sendSubviewToBack:collectionView];

    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [collectionView WSSCenterInSuperviewInDirections:WSSConstraintDirectionAll];
    [collectionView WSSFitToSuperviewInDirections:WSSConstraintDirectionAll];

    [collectionView addGestureRecognizer:[self itemMovementRecognizer]];
}

- (IBAction)toggleLayout
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    BOOL enteringOverview = ![self isInOverview];
    [self setInOverview:enteringOverview];
    [[self dataSource] setInOverview:enteringOverview];

    UICollectionViewFlowLayout * newLayout = enteringOverview ? [self overviewLayout] : [self fullscreenLayout];
    
    [[self collectionView] setCollectionViewLayout:newLayout
                                          animated:YES
                                        completion:^(BOOL finished) {
                                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                            [[self itemMovementRecognizer] setEnabled:enteringOverview];
                                        }];
}

- (UILongPressGestureRecognizer *)itemMovementRecognizer
{
    if( !_itemMovementRecognizer ){

        _itemMovementRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(itemMovementStateChanged:)];
        [_itemMovementRecognizer setMinimumPressDuration:0.3];
    }

    return _itemMovementRecognizer;
}

- (void)itemMovementStateChanged:(UILongPressGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    if( state == UIGestureRecognizerStateBegan ){

        CGPoint pressPoint = [recognizer locationInView:[self collectionView]];
        NSIndexPath * pressPath = [[self collectionView] indexPathForItemAtPoint:pressPoint];

        if( !pressPath ) return;

        [[self collectionView] beginInteractiveMovementForItemAtIndexPath:pressPath];
        // Force immediate application of special layout attributes
        [UIView animateWithDuration:0.125 animations:^{
            [[self collectionView] updateInteractiveMovementTargetPosition:pressPoint];
        }];
    }
    else if( state == UIGestureRecognizerStateChanged ){

        CGPoint movePoint = [recognizer locationInView:[self collectionView]];

        [[self collectionView] updateInteractiveMovementTargetPosition:movePoint];
    }
    else if( state == UIGestureRecognizerStateEnded ){

        [[self collectionView] endInteractiveMovement];
        [self updatePageIndexAfterMove];
    }
    else if( state == UIGestureRecognizerStateCancelled ){

        [[self collectionView] cancelInteractiveMovement];
    }
}

- (void)updatePageIndexAfterMove
{
   NSIndexPath * previousPath = [[self fullscreenLayout] pageIndexPath];
   NSIndexPath * movedPath = [[self dataSource] pathAfterMovementForIndexPath:previousPath];

   [[self fullscreenLayout] setPageIndexPath:movedPath];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate
{
    // Wait until scrolling has settled to calculate page
    if( willDecelerate ) return;

    if( [self isInOverview] ) return;

    [[self fullscreenLayout] updatePageIndex];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( [self isInOverview] ) return;

    [[self fullscreenLayout] updatePageIndex];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( ![self isInOverview] ) return;

    [[self fullscreenLayout] setPageIndexPath:indexPath];
    [self toggleLayout];
}

@end
