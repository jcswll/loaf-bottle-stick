//
//  LBSFullscreenLayout.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/23/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSFullscreenLayout.h"

@interface LBSFullscreenLayout ()

/** The size of the collection view's bounds; used directly for the size of cells. */
@property (assign, nonatomic) CGSize layoutSize;

@end

@implementation LBSFullscreenLayout
{
    NSInteger _numItems;
    BOOL _didInitialLayout;
    // The index of the currently-displayed cell. Needed (and updated) when returning from overview mode.
    NSUInteger _pageIndex;
}

+ (instancetype)layoutWithSize:(CGSize)layoutSize
{
    return [[self alloc] initWithLayoutSize:layoutSize];
}

- (id)initWithLayoutSize:(CGSize)layoutSize
{
    self = [super init];
    if( !self ) return nil;
    
    // "Line" spacing is between _columns_ for horizontal scrolling
    [self setMinimumLineSpacing:0];
    [self setSectionInset:UIEdgeInsetsZero];
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _layoutSize = layoutSize;
    [self setItemSize:_layoutSize];
   
    return self;
}

- (void)setLayoutSize:(CGSize)layoutSize
{
    _layoutSize = layoutSize;
    [self setItemSize:_layoutSize];
}

- (NSIndexPath *)_pageIndexPath
{
    return [NSIndexPath indexPathForItem:_pageIndex
                               inSection:0];
}

- (void)setPageIndexPath:(NSIndexPath *)indexPath
{
    _pageIndex = [indexPath item];
}

- (void)updatePageIndex
{
    CGFloat xOffset = [[self collectionView] contentOffset].x;
    CGFloat width = [self layoutSize].width;
    
    _pageIndex = floor(xOffset / width);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    _numItems = [[self collectionView] numberOfItemsInSection:0];
    
    // This is not an appropriate place to set paging during transitions,
    // because both layouts recieve this message in indeterminate order.
    // However, there is no transition on initial presentation.
    if( !_didInitialLayout ){
        [[self collectionView] setPagingEnabled:YES];
        _didInitialLayout = YES;
    }
}

- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout
{
    [super prepareForTransitionFromLayout:oldLayout];
    
    [self setLayoutSize:[[self collectionView] bounds].size];
    
    [[self collectionView] setPagingEnabled:YES];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)_
{
    return CGPointMake(_pageIndex * [self layoutSize].width, 0);
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake([self layoutSize].width * _numItems,
                      [self layoutSize].height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGSize newSize = newBounds.size;
    BOOL sizeDidChange = !CGSizeEqualToSize([self layoutSize], newSize);
    if( sizeDidChange ){
        [self setLayoutSize:newSize];
    }
    
    return sizeDidChange;
}

@end
