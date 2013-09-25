//
//  ShowInfoCollectionViewFlowLayout.m
//  XBMC Remote
//
//  Created by Jonathan on 18/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewFlowLayout.h"

@implementation ShowInfoCollectionViewFlowLayout

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frm = attr.frame;
    if ([indexPath isEqual:self.indexPathsToFloat[0]]) {
        frm.origin.x = 0;
    } else {
        UICollectionViewLayoutAttributes *first = [self layoutAttributesForItemAtIndexPath:self.indexPathsToFloat[0]];
        frm.origin.y -= first.frame.size.height;
        if (frm.origin.y < first.frame.size.height) {
            frm.origin.x = first.frame.size.width - 5;
            frm.size.width -= (first.frame.size.width - 5) ;
        }
    }
    attr.frame = frm;
    return attr;
}
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    rect.size.height += [self layoutAttributesForItemAtIndexPath:self.indexPathsToFloat[0]].frame.size.height;
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *collector = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in original) {
        [collector addObject:[self layoutAttributesForItemAtIndexPath:attr.indexPath]];
    }
    return collector;
}
-(CGSize)collectionViewContentSize {
    CGSize original = [super collectionViewContentSize];
    original.height -= [self layoutAttributesForItemAtIndexPath:self.indexPathsToFloat[0]].frame.size.height;
    return original;
}
@end
