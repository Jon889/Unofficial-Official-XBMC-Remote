//
//  PosterCell.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 17/3/13.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "PosterCell.h"

@implementation PosterCell

@synthesize posterThumbnail = _posterThumbnail;
@synthesize posterLabel = _posterLabel;
@synthesize busyView = _busyView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        float labelHeight = (int)(frame.size.height * 0.19f);
        float labelTop = 10;
        float borderWidth = 0;//[self halfSizeIfRetina:1.0f];
        self.restorationIdentifier = @"posterCell";
        _posterThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(borderWidth, borderWidth, frame.size.width - borderWidth * 2, frame.size.height - borderWidth * 2)];
        [_posterThumbnail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [_posterThumbnail setClipsToBounds:YES];
        [_posterThumbnail setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_posterThumbnail];
        
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(borderWidth, frame.size.height - labelHeight - labelTop, frame.size.width - borderWidth * 2, labelHeight + labelTop - borderWidth)];
        [labelView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = labelView.bounds;
        gradient.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor]];
        [labelView.layer addSublayer:gradient];
        
        CGRect posterFrame = labelView.bounds;
        posterFrame.origin.y = labelTop;
        posterFrame.size.height = labelHeight;
        _posterLabel = [[PosterLabel alloc] initWithFrame:posterFrame];
        [_posterLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [_posterLabel setBackgroundColor:[UIColor clearColor]];
        [_posterLabel setTextColor:[UIColor whiteColor]];
        [_posterLabel setTextAlignment:NSTextAlignmentCenter];

        
        [_posterLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [_posterLabel setShadowOffset:CGSizeMake(0,1)];
        [_posterLabel setNumberOfLines:2];
        [_posterLabel setMinimumScaleFactor:8.0/[[_posterLabel font] pointSize]];
        [_posterLabel setAdjustsFontSizeToFitWidth:YES];

        [labelView addSubview:_posterLabel];
        [self.contentView addSubview:labelView];
        
        _busyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _busyView.hidesWhenStopped = YES;
        _busyView.center = CGPointMake(frame.size.width / 2, (frame.size.height / 2) - borderWidth);
        _busyView.tag = 8;
        [self.contentView addSubview:_busyView];

        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.0f green:132.0f/255.0f blue:1.0f alpha:1]];
        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (float)halfSizeIfRetina:(float)size{
    BOOL isRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2);
    size = isRetina ? size / 2 : size;
    return size;
}

-(void)setOverlayWatched:(BOOL)enable{
    if (enable == YES){
        if (overlayWatched == nil){
            overlayWatched = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OverlayWatched"]];
            [overlayWatched setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleBottomMargin];
            overlayWatched.frame = CGRectMake(self.contentView.frame.size.width - overlayWatched.frame.size.width + 2,
                                              self.contentView.frame.size.height - overlayWatched.frame.size.height + 1,
                                              overlayWatched.frame.size.width,
                                              overlayWatched.frame.size.height);
            [self.contentView addSubview:overlayWatched];
        }
        overlayWatched.hidden = NO;
    }
    else{
        overlayWatched.hidden = YES;
    }
}

@end