//
//  LBSShadowLayoutAttributes.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSShadowLayoutAttributes.h"

@implementation LBSShadowLayoutAttributes

+ (instancetype)copyOf:(UICollectionViewLayoutAttributes *)attrs
            withShadow:(BOOL)displayShadow
{
    LBSShadowLayoutAttributes * newAttrs = [self layoutAttributesForCellWithIndexPath:[attrs indexPath]];
    
    [newAttrs setFrame:[attrs frame]];
    [newAttrs setBounds:[attrs bounds]];
    [newAttrs setCenter:[attrs center]];
    [newAttrs setSize:[attrs size]];
    [newAttrs setTransform3D:[attrs transform3D]];
    [newAttrs setTransform:[attrs transform]];
    [newAttrs setAlpha:[attrs alpha]];
    [newAttrs setZIndex:[attrs zIndex]];
    [newAttrs setHidden:[attrs isHidden]];
    
    [newAttrs setDisplayShadow:displayShadow];
    
    return newAttrs;
}


- (NSUInteger)hash
{
    NSUInteger shadowHash = [self displayShadow] ? [@"YES" hash] : [@"NO" hash];
    
    return [super hash] ^ shadowHash;
}

- (BOOL)isEqual:(id)other
{
    if( ![other isKindOfClass:[self class]] ){
        return NO;
    }
    
    LBSShadowLayoutAttributes * otherAttrs = other;
    return ([otherAttrs displayShadow] == [self displayShadow]) &&
            [super isEqual:other];
}

- (instancetype)copy
{
    LBSShadowLayoutAttributes * attrs = [super copy];
    
    [attrs setDisplayShadow:[self displayShadow]];
    
    return attrs;
}

@end
