//
//  ShowInfoCollectionViewBaseCell.m
//  XBMC Remote
//
//  Created by Jonathan on 17/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "ShowInfoCollectionViewBaseCell.h"

@implementation ShowInfoCollectionViewBaseCell
-(CGSize)sizeOfCellForWidth:(CGFloat)width {
    NSAssert(NO, @"This [%@ %@] method must be overriden, and super method must NOT be called", [self class], NSStringFromSelector(_cmd));
    return CGSizeZero;
}
-(void)setTitle:(NSString *)title {
    NSAssert(NO, @"This [%@ %@] method must be overriden, and super method must NOT be called", [self class], NSStringFromSelector(_cmd));
}
-(void)setContent:(id)content {
    NSAssert(NO, @"This [%@ %@] method must be overriden, and super method must NOT be called", [self class], NSStringFromSelector(_cmd));
}

-(void)setTitleLabel:(UILabel *)titleLabel {
    if (_titleLabel != titleLabel) {
        [_titleLabel removeObserver:self forKeyPath:@"text"];
        _titleLabel = titleLabel;
        _titleLabel.text = [_titleLabel.text uppercaseString];
        [_titleLabel addObserver:self forKeyPath:@"text" options:0 context:nil];
    }
}

-(void)dealloc {
    [_titleLabel removeObserver:self forKeyPath:@"text"];
    //remember: with ARC, [super dealloc] is called automatically
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.titleLabel && [keyPath isEqualToString:@"text"]) {
        [_titleLabel removeObserver:self forKeyPath:@"text"];
        self.titleLabel.text = [self.titleLabel.text uppercaseString];
        [_titleLabel addObserver:self forKeyPath:@"text" options:0 context:nil];
    }
}


@end
