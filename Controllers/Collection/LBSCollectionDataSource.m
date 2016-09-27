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

static NSString * const kMarketCellNibName = @"LBSMarketCell";
static NSString * const kMarketCellReuseIdentifier = @"MarketCell";

typedef NSIndexPath * (^IndexPathTransform)(NSIndexPath *);

@interface LBSCollectionDataSource ()

/** This Block captures the most recent item movement info and calculates where a passed-in index path ended up. */
@property (strong, nonatomic, nonnull) IndexPathTransform postMovementIndexPathTransform;

- (void)registerViewsWithCollectionView:(UICollectionView *)collectionView;

@end

@implementation LBSCollectionDataSource
{
    NSArray<NSString *> * _names;
    NSMutableArray<LBSMarketTableController *> * _tables;
}

+ (instancetype)dataSourceForView:(UICollectionView *)collectionView
{
    return [[self alloc] initForView:collectionView];
}
                             
- (instancetype)initForView:(UICollectionView *)collectionView
{
    self = [super init];
    if( !self ) return nil;
    
    _names = @[@"Groceria Abbandando",
               @"Mercado de Luis",
               @"Klaus Lebensmittelmarkt",
               @"Épicerie Pierre",
               @"Doyle's Grocery",
               @"Hans supermarkt",
               @"Mercearia de João",
               @"प्रसाद की किराने की दुकान"];
    
    _tables = [NSMutableArray array];
    for( NSString * name in _names ){
        [_tables addObject:[[LBSMarketTableController alloc] initWithMarketName:name]];
    }

    // Use identity transform until item movement actually occurs.
    _postMovementIndexPathTransform = ^NSIndexPath * (NSIndexPath * path){
        return path;
    };

    [self registerViewsWithCollectionView:collectionView];
    
    return self;
}
                             
- (void)registerViewsWithCollectionView:(UICollectionView*)collectionView
{
    UINib * cellNib = [UINib nibWithNibName:kMarketCellNibName
                                     bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:kMarketCellReuseIdentifier];
}

- (NSIndexPath *)pathAfterMovementForIndexPath:(NSIndexPath *)path
{
    IndexPathTransform transform = [self postMovementIndexPathTransform];
    return transform(path);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [_tables count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBSMarketCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMarketCellReuseIdentifier
                                                                     forIndexPath:indexPath];
    NSUInteger itemIndex = [indexPath item];
    LBSMarketTableController * tableController = _tables[itemIndex];
    UIView * tableView = [tableController tableView];

    [cell setInOverview:[self isInOverview]];
    [cell setTableView:tableView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = [sourceIndexPath row];
    NSUInteger destinationIndex = [destinationIndexPath row];
    LBSMarketTableController * movingItem = _tables[sourceIndex];
    
    [_tables removeObjectAtIndex:sourceIndex];
    [_tables insertObject:movingItem atIndex:destinationIndex];
    
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
