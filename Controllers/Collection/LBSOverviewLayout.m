//
//  LBSOverviewLayout.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/19/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSOverviewLayout.h"
#import "LBSShadowLayoutAttributes.h"

@interface LBSOverviewLayout ()

/** The collection view's bounds; used to calculate sizes of elements */
@property (assign, nonatomic) CGSize layoutSize;

- (void)updateSizes;

@end

@implementation LBSOverviewLayout

+ (instancetype)layoutWithSize:(CGSize)layoutSize
{
    return [[self alloc] initWithLayoutSize:layoutSize];
}

- (id)initWithLayoutSize:(CGSize)layoutSize
{
    self = [super init];
    if( !self ) return nil;
    
    [self setScrollDirection:UICollectionViewScrollDirectionVertical];
    _layoutSize = layoutSize;
    [self updateSizes];
    
    return self;
}

- (void)setLayoutSize:(CGSize)layoutSize
{
    _layoutSize = layoutSize;
    [self updateSizes];
}

-(void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout
{
    [super prepareForTransitionFromLayout:oldLayout];
    
    [self setLayoutSize:[[self collectionView] bounds].size];
    
    [[self collectionView] setPagingEnabled:NO];
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

- (LBSShadowLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath
                                                                  withTargetPosition:(CGPoint)position
{
    static const CGFloat kMovingCellOpacity = 0.85;
    static const CGFloat kMovingCellScale = 1.1;
    
    // While an item is being moved, provide special visual effects
    UICollectionViewLayoutAttributes * attrs = [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath
                                                                                         withTargetPosition:position];
    LBSShadowLayoutAttributes * shadowAttrs = [LBSShadowLayoutAttributes copyOf:attrs
                                                                     withShadow:YES];
    
    [shadowAttrs setTransform:CGAffineTransformMakeScale(kMovingCellScale, kMovingCellScale)];
    [shadowAttrs setAlpha:kMovingCellOpacity];
    
    return shadowAttrs;
}

- (void)updateSizes
{
    /** Reduction factor for item size, from layout size. */
    static const CGFloat kItemSizeDivisor = 4;
    /** Reduction factor for line and column spacing, from item size. */
    static const CGFloat kSpacingDivisor = 3;
    /** Inset for top and bottom of section */
    static const CGFloat kSectionInsetVertical = 50;
    
    /** The size of a cell, based on layout size. */
    CGSize derivedItemSize = CGSizeMake([self layoutSize].width / kItemSizeDivisor,
                                        [self layoutSize].height / kItemSizeDivisor);
    CGFloat horizontalSpacing = derivedItemSize.width / kSpacingDivisor;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(kSectionInsetVertical, horizontalSpacing,
                                                 kSectionInsetVertical, horizontalSpacing);
    
    [self setItemSize:derivedItemSize];
    [self setMinimumLineSpacing:horizontalSpacing];
    [self setMinimumInteritemSpacing:horizontalSpacing];
    [self setSectionInset:sectionInset];
}

@end
