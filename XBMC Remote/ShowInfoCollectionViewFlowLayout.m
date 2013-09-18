//
//  ShowInfoCollectionViewFlowLayout.m
//  XBMC Remote
//
//  Created by Jonathan on 18/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewFlowLayout.h"

@implementation ShowInfoCollectionViewFlowLayout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
//
//        CGFloat currentHeight = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].frame.size.height;
//    CGFloat firstHeight = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].frame.size.height;
//    int i = 2;
//        while (firstHeight > currentHeight) {
//            UICollectionViewLayoutAttributes *thisAttr = nil;
//            for (UICollectionViewLayoutAttributes *attr in original) {
//                if (attr.indexPath.row == i) {
//                    thisAttr = attr;
//                    break;
//                }
//            }
//            i++;
//            if (!thisAttr) break;
//            currentHeight += thisAttr.frame.size.height;
//            CGRect frame = thisAttr.frame;
//            frame.origin.x = 100;
//            frame.size.width = [self collectionViewContentSize].width - 100;
//            thisAttr.frame = frame;
//
//        }
    
    return original;
}
@end
