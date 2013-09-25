//
//  ShowInfoCollectionViewPosterCell.m
//  XBMC Remote
//
//  Created by Jonathan on 18/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewPosterCell.h"

@implementation ShowInfoCollectionViewPosterCell
+(CGSize)initialSizeOfCellForWidth:(CGFloat)width {
    return CGSizeMake(110, 140);
}
-(CGSize)sizeOfCellForWidth:(CGFloat)width {
    return self.frame.size;
}
-(void)setTitle:(NSString *)title {
    //do nothing
}
-(void)setContent:(id)content {
    self.imageView.image = content;
}


@end
