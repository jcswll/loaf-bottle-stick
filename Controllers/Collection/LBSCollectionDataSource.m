//
//  LBSCollectionDataSource.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/24/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSCollectionDataSource.h"
#import "LBSMarketCell.h"
#import "LBSMarketTableController.h"
#import "LoafBottleStick-Swift.h"

typedef NSIndexPath * (^IndexPathTransform)(NSIndexPath *);


@interface LBSCollectionDataSource ()

/** This Block captures the most recent item movement info and calculates where a passed-in index path ended up. */
@property (strong, nonatomic, nonnull) IndexPathTransform postMovementIndexPathTransform;

- (void)registerViewsWithCollectionView:(UICollectionView *)collectionView;

@end


@implementation LBSCollectionDataSource
{
    NSMutableArray<MarketPresentation *> * _presentations;
}

+ (instancetype)dataSourceForView:(UICollectionView *)collectionView
{
    return [[self alloc] initForView:collectionView];
}
                             
- (instancetype)initForView:(UICollectionView *)collectionView
{
    self = [super init];
    if( !self ) return nil;
    
    _presentations = [[MarketPresentation dummies] mutableCopy];

    // Use identity transform until item movement actually occurs.
    _postMovementIndexPathTransform = ^NSIndexPath * (NSIndexPath * path){
        return path;
    };

    [self registerViewsWithCollectionView:collectionView];
    
    return self;
}

//- (void)setInOverview:(BOOL)inOverview
//{
//    _inOverview = inOverview;
//    
//    for( MarketPresentation * presentation in _presentations ){
//        [presentation setInOverview:inOverview];
//    }
//}

- (void)registerViewsWithCollectionView:(UICollectionView*)collectionView
{
    [MarketPresentation registerCellWithCollectionView:collectionView];
}

- (NSIndexPath *)pathAfterMovementForIndexPath:(NSIndexPath *)path
{
    IndexPathTransform transform = [self postMovementIndexPathTransform];
    return transform(path);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [_presentations count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger itemIndex = [indexPath item];
    MarketPresentation * presentation = _presentations[itemIndex];
    
    return [presentation configureCellForCollectionView:collectionView atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = [sourceIndexPath row];
    NSUInteger destinationIndex = [destinationIndexPath row];
    MarketPresentation * movingItem = _presentations[sourceIndex];
    
    [_presentations removeObjectAtIndex:sourceIndex];
    [_presentations insertObject:movingItem atIndex:destinationIndex];
    
    [self setPostMovementIndexPathTransform:^NSIndexPath * (NSIndexPath * path){
        
        // This is the path of the item that moved.
        if( [path row] == sourceIndex ){
            return destinationIndexPath;
        }
        
        BOOL beforeSourceIndex = [path row] < sourceIndex;
        BOOL atDestIndex = [path row] == destinationIndex;
        
        if( atDestIndex ){
            // This path was the destination. If before source: it moved right; after source: it moved left
            NSUInteger offset = beforeSourceIndex ? 1 : -1;
            return [NSIndexPath indexPathForRow:[path row] + offset
                                      inSection:[path section]];
        }
        
        BOOL beforeDestIndex = [path row] < destinationIndex;
        
        // Before source, after destination: moved right
        if( beforeSourceIndex && !beforeDestIndex ){
            return [NSIndexPath indexPathForRow:[path row] + 1
                                      inSection:[path section]];
        }
        
        // After source, before destination: moved left
        if( !beforeSourceIndex && beforeDestIndex ){
            return [NSIndexPath indexPathForRow:[path row] - 1
                                      inSection:[path section]];
        }
        
        // Either both before or both after: index has not changed
        return path;
    }];
}

@end
