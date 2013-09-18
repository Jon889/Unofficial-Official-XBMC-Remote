//
//  ShowInfoCollectionViewCell.m
//  XBMC Remote
//
//  Created by Jonathan on 16/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewCell.h"

@implementation ShowInfoCollectionViewCell

-(CGSize)sizeOfCellForWidth:(CGFloat)width {
    CGRect frame = self.contentLabel.frame;
    frame.size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.bounds.size.width, CGFLOAT_MAX)];
    self.contentLabel.frame = frame;
    return CGSizeMake(width, self.titleLabel.bounds.size.height + frame.size.height);
}

-(void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
-(void)setContent:(NSString *)content {
    self.contentLabel.text = content;
}

@end
