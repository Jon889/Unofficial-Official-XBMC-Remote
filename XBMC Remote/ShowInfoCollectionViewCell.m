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
    frame.size.height = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.bounds.size.width, CGFLOAT_MAX)].height;
    self.contentLabel.frame = frame;
    return CGSizeMake(width, self.titleLabel.bounds.size.height + frame.size.height);
}
-(void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
-(void)setContent:(NSString *)content {
    self.contentLabel.text = content;
}
-(void)setContentLabel:(UILabel *)contentLabel {
    if (_contentLabel != contentLabel) {
        [_contentLabel removeObserver:self forKeyPath:@"text"];
        _contentLabel = contentLabel;
        [_contentLabel addObserver:self forKeyPath:@"text" options:0 context:nil];
    }
}
-(void)dealloc {
    [_contentLabel removeObserver:self forKeyPath:@"text"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.contentLabel && [keyPath isEqualToString:@"text"]) {
        CGRect frame = self.contentLabel.frame;
        frame.size.height = [self.contentLabel sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)].height;
        self.contentLabel.frame = frame;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
